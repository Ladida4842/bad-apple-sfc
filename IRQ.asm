macro IRQ_end()
	JSR HDMA_Update
	LDA #$0F : STA $2100
	LDA #$06 : STA $420C
	INC.b RAM_frame
	%pullall(0)
	RTI
endmacro

IRQ:
	%pushall(0)
	LDA $4211
	LDA #$80 : STA $2100
	STZ $420C

	LDA.b RAM_frame
	BIT #$02 : BEQ .null
	LSR : BCS .odd

.even
	REP #$20
	LDA.b RAM_vram_addr : STA $2116
	LDA #$1800 : STA $4305
	LDA #$2000 : STA $4302
	SEP #$21
	ROL : STA $420B
.null
	%IRQ_end()

.odd
	REP #$21
	LDA.b RAM_vram_addr : ADC #$0C00 : STA $2116
	LDA #$1800 : STA $4305
	LDA #$3800 : STA $4302
	SEP #$21
	ROL : STA $420B
	LDA.b RAM_vram_addr+1
	STA $210B
	EOR #$20
	STA.b RAM_vram_addr+1
	%IRQ_end()