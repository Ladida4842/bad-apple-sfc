BRK:	;crash handler. creates static for now, will create debug info later
	SEP #$34
	PHK : PLB
	LDA $4212 : BPL $FB
	LDA $4212 : BMI $FB
	STZ $4200 : STZ $420C
	PEA $2100 : PLD
	STZ $30 : STZ $33 : STZ $2C : STZ $2E : STZ $31
	STZ $05 : STZ $06
	STZ $21 : LDA #$FF : STA $22 : STA $22
	LDA #$0F : STA $00
	EOR #$0F : BRA $FA