DecompLC_LZ2:			;(C) Ladida
	PHB
	STA DP.decomp.work+1
	STA DP.decomp.src+1
	STZ DP.decomp.src
	STX DP.decomp.dest
	SEP #$20
	PHA
	PLB
	STA DP.decomp.work+7
	STA DP.decomp.work+8
	JMP .read
.repeat
	REP #$21
	LDA [DP.decomp.src],y
	XBA
	INY
	STY DP.decomp.backup
	TXY
	ADC DP.decomp.dest
	TAX
	LDA DP.decomp.misc
	JMP.w DP.decomp.work+6
.byte
	LDA [DP.decomp.src],y
	STA $0000,x
	REP #$20
	STY DP.decomp.backup
	LDA DP.decomp.misc
	DEC
	TXY
	INY
	JMP.w DP.decomp.work+6
.long
	ASL
	ASL
	ASL
	AND #$E0
	XBA
	LDA [DP.decomp.src],y
	AND #$03
	STA DP.decomp.misc+1
	INY
	LDA [DP.decomp.src],y
	STA DP.decomp.misc
	INY
	XBA
.command
	BEQ .direct
	BMI .repeat
	ASL
	BPL .byte
	ASL
	BPL .word
.increasing
	LDA [DP.decomp.src],y
	STY DP.decomp.backup
	LDY DP.decomp.misc
-
	STA $0000,x
	INX
	INC
	DEY
	BPL -
	BRA .preread
.direct
	REP #$20
	TXA
	TYX
	TAY
	LDA DP.decomp.misc
	JMP.w DP.decomp.work
.word
	REP #$20
	LDA [DP.decomp.src],y
	STA $0000,x
	INY
	STY DP.decomp.backup
	LDA DP.decomp.misc
	DEC
	DEC
	TXY
	INY
	INY
	JMP.w DP.decomp.work+6
.back2
	SEP #$20
	TYX
.preread
	LDY DP.decomp.backup
	INY
.read
	LDA [DP.decomp.src],y
	CMP #$FF
	BEQ .end
	CMP #$E0
	BCS .long
	STZ DP.decomp.misc+1
	AND #$1F
	STA DP.decomp.misc
	LDA [DP.decomp.src],y
	INY
	AND #$E0
	BRA .command
.back
	TXA
	TYX
	TAY
	SEP #$20
	LDA [DP.decomp.src],y
	CMP #$FF
	BEQ .end
	CMP #$E0
	BCS .long
	STZ DP.decomp.misc+1
	AND #$1F
	STA DP.decomp.misc
	LDA [DP.decomp.src],y
	INY
	AND #$E0
	BRA .command
.end
	PLB
	SEP #$10
	JMP decompressor
.init
	LDX #$54
	STX DP.decomp.work
	STX DP.decomp.work+6
	LDX #$4C
	STX DP.decomp.work+3
	STX DP.decomp.work+9
	LDA #.back
	STA DP.decomp.work+4
	LDA #.back2
	STA DP.decomp.work+10
	RTS