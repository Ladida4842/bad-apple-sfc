UploadSPCEngine:
	LDX.b #SampleTable>>16 : STX DP.indirect+2
	REP #$30
	LDA.w #SampleTable : STA DP.indirect
	LDY #$0000
	LDA #$BBAA
-	CMP APU.io0 : BNE -
	SEP #$20
	LDA #$CC
	BRA .initupload

.nextblock
	LDA [DP.indirect],y
	INY
	XBA
	LDA #$00
	BRA .skip

.loop
	XBA
	LDA [DP.indirect],y
	INY
	XBA
-	CMP APU.io0 : BNE -
	INC
.skip
	REP #$20
	STA APU.io0
	SEP #$20
	DEX
	BNE .loop
-	CMP APU.io0 : BNE -
-	ADC #$03 : BEQ -

.initupload
	PHA
	REP #$20
	LDA [DP.indirect],y
	INY #2
	TAX
	LDA [DP.indirect],y
	INY #2
	STA APU.io2
	SEP #$20
	CPX #$0001
	LDA #$00
	ROL
	STA APU.io1
	ADC #$7F
	PLA
	STA APU.io0
-	CMP APU.io0 : BNE -
	BVS .nextblock
	STZ APU.io0
	STZ APU.io1
	STZ APU.io2
	STZ APU.io3
	RTS

SampleTable:
;	dw .espc-.bspc,$0200
;.bspc
	incsrc spc_code.asm
;.espc
;	dw $0000,$0200