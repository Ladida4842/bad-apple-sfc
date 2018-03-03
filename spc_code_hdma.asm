norom
arch spc700

incsrc _spc_defines.asm

org $0000
base $0200

spc_engine:
	CLRP
	%wdsp(!flg, $20)	;set echo disable flag
	%wdsp(!kon, 0)
	%wdsp(!dir, $00)	;our sample pointer table is at $0400
	%wdsp(!esa, $80)
	%wdsp(!edl, 0)
	%wdsp(!non, 0)
	%wdsp(!eon, 0)
	%wdsp(!mvol_l, $3F)
	%wdsp(!mvol_r, $3F)
	%wdsp(!evol_l, $00)
	%wdsp(!evol_r, $00)


;initialize our channel

%wdsp_reg(!vol_l0, #$7F)
%wdsp_reg(!vol_r0, #$7F)
%wdsp_reg(!p_l0, #$00)
%wdsp_reg(!p_h0, #$10)
%wdsp(!adsr0_1, $0F|$00|$80)
%wdsp(!adsr0_2, $E0|$00)
%wdsp(!gain0, $00)

;this code builds the sample pointer table. dont delete!
	MOV $10, #$00
	MOV $12, #$00
	MOV $11, #$01
	MOV $13, #$01

	MOV A, #$03
	MOV $0100, A

MOV $00, #$00		;low byte of upload destination is 00
MOV $02, #$04		;$02 = bank to upload sound to. switches between $0400 and $8400
%wdsp_reg(!srcn0, #$04)	;change instrument
%wdsp_reg(!kon, #$01)	;start sound
MOV $05, #$0C		;upload timer
;MOV $F0, #$4A
JMP .init		;begin wait




.wait			;wait for next frame here
	CMP !io3, #$69	;HDMA will send #$69 to port 3 on first scanline
	BNE .wait	;previous value=FF, so wait for it to change
	JMP .port0	;first scanline doesnt need port 3 checked again

.loop			;wait for next scanline's HDMA transfer here
	MOV A, !io3
	BMI .endupl	;if port 3 is negative, transfer ended (its usually 0 or 1)
	CMP A, $04	;check if $04 = port 3. mismatch means next transfer hasn't happened
	BNE .loop	;so keep looping
	EOR $04, #$01	;inverse $04 to match next scanline
.port0
	MOV A, !io0	;get first byte of transfer from port 0
	MOV ($00)+y, A	;store to address
	INC Y		;increase index
	BNE .port1	;if index becomes 00
	INC $01		;increase high byte of address
.port1
	MOV A, !io1	;next byte of transfer is in port 1
	MOV ($00)+y, A	;store to address+1
	INC Y		;increase index
	BNE .port2	;if index becomes 00
	INC $01		;increase high byte of address
.port2
JMP .loop
	MOV A, !io2	;final byte of transfer is in port 2
	MOV ($00)+y, A	;store to address+2
	INC Y		;increase index
	BNE .loop	;if index becomes 00
	INC $01		;increase high byte of address
	JMP .loop	;check for next hdma transfer

.endupl
	DEC $05
	BPL .skip

.playsound
	MOV A, Y	;this whole code sets the loop/
	SETC		;end bits on the last sample chunk
	SBC A, #$09
	BCS +
	DEC $01
	+
	MOV Y, A
	MOV A, #$03
	OR A, ($00)+y
	MOV ($00)+y, A
	MOV $13, $02	;this is the moment the loop pointer is changed
	EOR $02, #$80	;bank to upload. 06 becomes 86 and vice versa
	MOV $05, #$0B	;upload timer
.init
	MOV $01, $02	;high byte of upload destination is in $02 (either 05 or 85)
	MOV Y, #$00	;index for upload destination initialized
.skip
	MOV $04, #$01	;$04 is to check if current scanline is still running
	JMP .wait