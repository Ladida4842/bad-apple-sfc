TableMaker:
	PEA $0000 : PLD
	dpbase $0000
	REP #$31

	LDY #$05E1
	LDX #RAM.addresses
	LDA #$0000
-	STA $00,x
	ADC #$0007
	INX #2
	DEY : BPL -

	LDX #RAM.shorttable
	LDA.w #70
	JSR shortlonggenshort
	LDA #$FF01
	STA $02,x
	STZ $04,x
	SEP #$30

	LDA #$F0 : STA $00
	PEA DMA : PLD
	dpbase DMA
	LDA #$80 : STA DP.indirect+2
	REP #$31
	STZ DP.indirect
	LDA #$0047 : STA DP.counter1
	LDX #$0000
	LDY #$0001
-
	JSR .qq
	TXA : STA [DP.indirect],y
	ADC #$00E0
	TAX
	INY #2
	SEP #$20
	LDA #$A0 : STA [DP.indirect],y
	INY
	REP #$20
	TXA : STA [DP.indirect],y
	ADC #$0040
	TAX
	INY #2
	LDA #$F000 : STA [DP.indirect],y
	INY #2

	DEC DP.counter1 : BPL -
	SEP #$30
	RTS

.qq
	PEA .q-1
.q
	TXA : STA [DP.indirect],y
	ADC #$00E0
	TAX
	INY #2
	SEP #$20
	LDA #$A9 : STA [DP.indirect],y
	INY
	REP #$20
	TXA : STA [DP.indirect],y
	ADC #$0052
	TAX
	INY #2
	LDA #$F000 : STA [DP.indirect],y
	INY #2
	RTS


HDMA_Update:
	LDA #$0F : STA PPU.display
	DEC DP.audiosync
	BPL +
	SEC
	LDA #$02
	STA DP.audiosync
+
	LDA DP.audiostream+2
	BPL +
	INC DMA[1].indBk
	STZ DP.audiostream+2
+
	REP #$30
	LDX DP.audiostream
	LDA RAM.addresses,x : STA DMA[1].src
	LDA #RAM.longtable
	BCC .long
.short
	LDA #RAM.shorttable
.long
	STA DMA[2].src
	SEP #$20
	INX #2
	CPX #$01B0
	BCC +
	LDA #$FF : STA DP.audiostream+2
	LDX #$0000
+
	STX DP.audiostream

	INC DP.frame
	REP #$30
	PLB : PLX : PLY : PLA
	RTI

;.addresses
;	!counter = 0
;	while !counter <= $05E1
;		dw !counter|$0000
;		!counter #= !counter+7
;	endif




;.shorttable
;	db $01,$69
;	;rep 71 : dd $00010101
;	filldword $00010101 : fill 71*4
;	db $01,$01
;	db $01,$FF,$00
;
;.longtable
;	db $01,$69
;	;rep 76 : dd $00010101
;	filldword $00010101 : fill 76*4
;	db $01,$FF,$00


shortlonggenlong:
	LDA #$0101
	STA $02,x
	LDA #$FF01
	STA $04,x
	STZ $06,x
	LDX #RAM.longtable
	LDA.w #75
	BRA shortlonggen
shortlonggenshort:
	PEA shortlonggenlong-1
shortlonggen:
	STA.w DP.counter1
	LDY #$6901
	STY $00,x
	LDA #$0101
	LDY #$0001
-	STA $02,x
	STY $04,x
	INX #4
	DEC.w DP.counter1
	BPL -
	RTS