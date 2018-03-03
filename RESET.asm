RESET:
	incsrc _init.asm

	PEA $2100 : PLD

;create tilemap
	LDA #$80 : STA $15
	REP #$30
	LDA #$4000 : STA $16
	LDA #$0000 : PHA
	LDX #$03FF
	-
	STA $18
	INC
	DEX : BPL -
	SEP #$30

;create palette
	STZ $21
	STZ $22 : STZ $22
	LDA #$20 : STA $21 : STA.w RAM_vram_addr+1
	STZ $22 : STZ $22
	LDA #$4A : STA $22
	LDA #$29 : STA $22
	LDA #$B5 : STA $22
	LDA #$56 : STA $22
	LDA #$FF : STA $22 : STA $22

;initialize regs
	STZ $05
	LDA #$EF : STA $10
	LDA #$01 : STA $10
	LDA #$40 : STA $08
	LDA #$02 : STA $2C
	STZ $0B

	PLD

;audio HDMA setup
	JSR UploadSPCEngine
	JSR TableMaker
	STZ.b RAM_audiostream+2
	LDA #$02 : STA.b RAM_audiostream_sync
	LDA #$7F : STA $4314
	LDA #$41 : STA $4317
	STZ $4324
	REP #$20
	STZ.b RAM_audiostream
	LDA #$4041 : STA $4310
	LDA #$4300 : STA $4320
	SEP #$20

;graphics DMA setup
	REP #$10
	LDA #$80 : STA $2115
	LDX #$1801 : STX $4300
	LDA #$7E : STA $4304
	SEP #$10

;IRQ setup and initial null frame
	CLI
	STZ $420A
	LDA #$D1 : STA $4209
	LDA #$20 : STA $4200
	WAI
	LDA #$80 : STA $2100
	LDA #$06 : STA $420C
	DEC.b RAM_frame
	BRA +

;game loop
	-
	WAI
	+
	JSR decompressor
	BRA -