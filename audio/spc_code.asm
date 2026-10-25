arch spc700-inline
!lagtarget = 4	;target frame counter for the control loop
org $0200
startpos spc_engine

macro wdsp(arg1, arg2)
	MOV A, <arg1>
	MOV Y, <arg2>
	MOVW SPC.dspaddr, YA
endmacro

spc_engine:
	CLRP
	%wdsp(#DSP.REG.flg, #$20)	;unmute, set echo disable flag
	%wdsp(#DSP.REG.keyOn, #0)
	%wdsp(#DSP.REG.srcdir, #$00)	;sample pointer table
	%wdsp(#DSP.REG.echodir, #$80)
	%wdsp(#DSP.REG.echodelay, #0)
	%wdsp(#DSP.REG.noiseOn, #0)
	%wdsp(#DSP.REG.echoOn, #0)
	%wdsp(#DSP.REG.mainvolL, #$7F)
	%wdsp(#DSP.REG.mainvolR, #$7F)
	%wdsp(#DSP.REG.echovolL, #$00)
	%wdsp(#DSP.REG.echovolR, #$00)

;initialize our channel
	%wdsp(#DSP[0].volL, #$7F)
	%wdsp(#DSP[0].volR, #$7F)
	%wdsp(#DSP[0].pitchLo, #$00)
	%wdsp(#DSP[0].pitchHi, #$10)
	%wdsp(#DSP[0].adsr1, #$0F|$00|$80)
	%wdsp(#DSP[0].adsr2, #$E0|$00)
	%wdsp(#DSP[0].gain, #$00)

;set loop and end bits on initial null sample
	MOV A, #$03
	MOV $0100, A
	MOV A, #$00
	MOV Y, #$01

;this code builds the sample pointer table
	MOV $10, A
	MOV $12, A
	MOV $11, Y
	MOV $13, Y

;initial sample clear (otherwise theres a beep since ARAM isnt initialized)
	MOVW $00, YA
-	MOV ($00)+y, A
	INC Y
	CMP Y, #$09
	BCC -

	;MOV $00, #$00			;low byte of upload destination is 00 (handled above)

;null end+loop block right after the $8400 buffer, so if the voice somehow still runs
;off the end then it loops back instead of decoding uninitialized ARAM and potentially crash
;the control loop prevents this from happening, this is a safeguard that the engine does not rely on
	MOV A, #$00
	MOV Y, #$08
-	MOV $9210+y, A
	DBNZ Y, -
	MOV A, #$03
	MOV $9210, A

	MOV $02, #$04				;$02 = bank to upload sound to. switches between $0400 and $8400
	%wdsp(#DSP[0].srcn, #$04)	;change instrument
	%wdsp(#DSP.REG.keyOn, #$01)	;start sound
	MOV $05, #$0C				;upload timer
	MOV $07, #!lagtarget		;$07 = buffer frame counter for control loop (FF = not seen yet)
	;MOV $F0, #$4A
	JMP .init			;begin wait


.wait				;wait for next frame here
	CMP SPC.io3, #$69	;HDMA will send #$69 to port 3 on first scanline
	BNE .wait		;previous value=FF, so wait for it to change
	JMP .port0		;first scanline doesnt need port 3 checked again

.loop				;wait for next scanline's HDMA transfer here
	MOV A, SPC.io3
	BMI .endupl		;if port 3 is negative, transfer ended (its usually 0 or 1)
	CMP A, $04		;check if $04 = port 3. mismatch means next transfer hasn't happened
	BNE .loop		;so keep looping
	EOR $04, #$01		;inverse $04 to match next scanline
.port0
	MOV A, SPC.io0		;get first byte of transfer from port 0
	MOV ($00)+y, A		;store to address
	INC Y			;increase index
	BNE .port1		;if index becomes 00
	INC $01			;increase high byte of address
.port1
	MOV A, SPC.io1		;next byte of transfer is in port 1
	MOV ($00)+y, A		;store to address+1
	INC Y			;increase index
	BNE .loop		;if index becomes 00
	INC $01			;increase high byte of address
.port2
;	MOV A, SPC.io2		;final byte of transfer is in port 2
;	MOV ($00)+y, A		;store to address+2
;	INC Y			;increase index
;	BNE .loop		;if index becomes 00
;	INC $01			;increase high byte of address
	JMP .loop		;check for next hdma transfer

.endupl
	INC $06			;$06 = frames since the loop pointer was last changed
	MOV A, $07
	INC A
	BNE .counted		;pickup already seen for this buffer
	MOV SPC.dspaddr, #DSP.REG.endx
	MOV A, SPC.dspdata
	LSR A			;voice 0 ENDX is set when it jumps to the loop pointer
	BCC .counted
	MOV $07, $06		;so the frame count is how far playback lags the upload
.counted
	DEC $05
	BPL .skip

.playsound
	MOV A, Y		;this whole code sets the loop/
	SETC			;end bits on the last sample chunk
	SBC A, #$09
	BCS +
	DEC $01
+
	MOV Y, A
	MOV A, #$03
	OR A, ($00)+y
	MOV ($00)+y, A

;control loop
;count the number of frames it takes for the audio buffer to switch over by reading ENDX
;calculate pitch to speed up/slow down the dsp to actively control the counter towards !lagtarget
;pitch = $1000 + 4*(lag - !lagtarget), lag clamped to 1-11
	MOV A, $07
	CMP A, #12		;FF (pickup not seen) counts as max lag too
	BCC +
	MOV A, #11
+
	ASL A
	ASL A
	CLRC
	ADC A, #$00-(4*!lagtarget)
	MOV Y, A
	MOV A, #DSP[0].pitchLo
	MOVW SPC.dspaddr, YA
	MOV A, #$10-1
	ADC A, #$00		;carry from the low byte (MOV/MOVW leave it alone)
	MOV Y, A
	MOV A, #DSP[0].pitchHi
	MOVW SPC.dspaddr, YA
	MOV SPC.dspaddr, #DSP.REG.endx
	MOV SPC.dspdata, #$00	;clear ENDX before the loop pointer changes
	MOV $06, #$00
	MOV $07, #$FF

	MOV $13, $02		;this is the moment the loop pointer is changed
	EOR $02, #$80		;bank to upload. 04 becomes 84 and vice versa
	MOV $05, #$0B		;upload timer
.init
	MOV $01, $02		;high byte of upload destination is in $02 (either 04 or 84)
	MOV Y, #$00		;index for upload destination initialized
.skip
	MOV $04, #$01		;$04 is to check if current scanline is still running
	JMP .wait

arch 65816
