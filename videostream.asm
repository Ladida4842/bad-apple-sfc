decompressor:
	LDA.b RAM_frame
	AND #$03 : BNE .skip
	REP #$30
	LDA.b RAM_videoframe
	CMP #$0CD7
	BEQ .end
	ASL
	ADC.b RAM_videoframe
	TAX
	INC.b RAM_videoframe
	LDA FramePointers,x : STA $8A
	LDA #$2000 : STA $00
	SEP #$20
	LDA FramePointers+2,x : STA $8C
	LDA #$7E
	STA $02
	SEP #$10
	JMP DecompLZ2

.skip
	RTS

.end
	WAI
	SEI
	STZ $4200
	STZ $420C
	BRA $FE