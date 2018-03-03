macro tableloop(count1, count2)
	LDA #$F0 : STA [$00],y
	INY
	REP #$20
	LDA $03 : STA [$00],y
	CLC : ADC #$00E0
	STA $03
	INY #2
	SEP #$20

	LDA #<count1> : STA [$00],y
	INY
	REP #$20
	LDA $03 : STA [$00],y
	CLC : ADC #<count2>
	STA $03
	INY #2
	SEP #$20

	LDA #$00 : STA [$00],y
	INY
endmacro

TableMaker:
LDA #$7F : STA $02
REP #$30
STZ $00
STZ $03
LDA #$0047 : STA $05
LDX #$0000
LDY #$0000
SEP #$20

-
%tableloop($A9,$0052)
%tableloop($A9,$0052)
%tableloop($A0,$0040)
DEC $05 : BMI +
JMP -
+
SEP #$30
RTS



HDMA_Update:
	CLC
	DEC.b RAM_audiostream_sync
	BPL +
	SEC
	LDA #$02
	STA.b RAM_audiostream_sync
	+
	LDA.b RAM_audiostream+2
	BPL +
	INC $4317
	STZ.b RAM_audiostream+2
	+
	REP #$30
	LDX.b RAM_audiostream
	LDA .addresses,x : STA $4312
	LDA.w #.longtable
	BCC .long
	.short
	LDA.w #.shorttable
	.long
	STA $4322
	SEP #$20
	INX #2
	CPX #$01B0
	BCC +
	LDA #$FF : STA.b RAM_audiostream+2
	LDX #$0000
	+
	STX.b RAM_audiostream
	SEP #$10
	RTS

	.addresses
		incsrc addresses.txt

	.shorttable
		db $01,$69
		rep 71 : dd $00010101
		db $01,$01
		db $01,$FF,$00

	.longtable
		db $01,$69
		rep 76 : dd $00010101
		db $01,$FF,$00