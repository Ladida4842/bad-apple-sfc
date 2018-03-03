UploadSPCEngine:
	LDA.b #SampleTable>>16 : STA $02
	LDA.b #SampleTable>>8 : STA $01
	LDA.b #SampleTable : STA $00

SPC700Upload:
	PHP
	REP #$30
	LDY #$0000
	LDA #$BBAA
-	CMP $2140 : BNE -
	SEP #$20
	LDA #$CC
	BRA .initupload

.nextblock
	LDA [$00],y
	INY
	XBA
	LDA #$00
	BRA .skip

.loop
	XBA
	LDA [$00],y
	INY
	XBA
-	CMP $2140 : BNE -
	INC
.skip
	REP #$20
	STA $2140
	SEP #$20
	DEX
	BNE .loop
-	CMP $2140 : BNE -
-	ADC #$03 : BEQ -

.initupload
	PHA
	REP #$20
	LDA [$00],y
	INY #2
	TAX
	LDA [$00],y
	INY #2
	STA $2142
	SEP #$20
	CPX #$0001
	LDA #$00
	ROL
	STA $2141
	ADC #$7F
	PLA
	STA $2140
-	CMP $2140 : BNE -
	BVS .nextblock
	STZ $2140
	STZ $2141
	STZ $2142
	STZ $2143
	PLP
	RTS

SampleTable:
	dw .espc-.bspc,$0200
.bspc
	incbin spc_code_hdma.spc
.espc
	dw $0000,$0200