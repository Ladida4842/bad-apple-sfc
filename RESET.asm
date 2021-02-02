RESET:
	incsrc _init.asm

	PEA PPU : PLD
	dpbase PPU
	optimize dp always

;create tilemap
;	LDA #$80 : STA PPU.vramctrl
	REP #$30
	LDA #$4000 : STA PPU.vramaddr
	LDY #$0000
	LDX #$0017 : STX $0000
--	TYA
	LDX #$001F
	CLC
-	STA PPU.vramdata
	ADC #$0018
	DEX : BPL -
	INY
	DEC $0000 : BPL --
	LDX #$00FF
	LDA #$03FF
-	STA PPU.vramdata
	DEX : BPL -
	INX
	TXA
-	STA $7F0000,x
	DEX #2 : BNE -
	SEP #$30

;create palette
	STZ PPU.cgramaddr
	STZ PPU.cgramdata
	STZ PPU.cgramdata
	LDX #$05
	LDA #$21
	STA PPU.cgramaddr
-	LDA .palette,x
	STA PPU.cgramdata
	DEX : BPL -

;initialize regs
	STZ PPU.bgmode
	LDA #$40 : STA PPU.bg2map
	LDA #$EF : STA PPU.bg2y
	LDA #$01 : STA PPU.bg2y
	INC : STA PPU.mainscr
	STZ PPU.bg12gfx

	PEA DMA : PLD
	dpbase DMA

	REP #$20
	STZ DP.videoframe
	LDA #$2000 : STA DP.vramaddr
	STZ DP.audiostream
	LDA #$0200 : STA DP.audiostream+2
;	STZ DP.decomp.src
;	STZ DP.decomp.src+2
;	STZ DP.decomp.dest+1
;	STZ DP.decomp.misc
;	STZ DP.decomp.backup
;	STZ DP.decomp.backup+2

;audio HDMA setup
	JSR UploadSPCEngine
	JSR TableMaker
	SEP #$30
;	STZ DP.audiostream+2
;	LDA #$02 : STA DP.audiosync
	LDA #$80 : STA DMA[1].srcBk
	LDA #$40 : STA DMA[1].indBk
	LDA #$80
	STA DMA[2].srcBk
	REP #$20
;	STZ DP.audiostream
	LDA #$4041 : STA DMA[1].ctrl
	LDA #$4300 : STA DMA[2].ctrl

;graphics DMA setup
	LDX #$80 : STX PPU.vramctrl
	LDA #$1801 : STA DMA[0].ctrl
	LDX #$7F : STX DMA[0].srcBk

;decompressor setup
	JSR DecompLC_LZ2_init

;IRQ setup and initial null frame
	LDA #$00D8 : STA CPU.vtime
	LDA #$0088 : STA CPU.htime
	SEP #$20
	LDA #$30 : STA CPU.interrupt
	CLI
;	LDA #$0C
;-	WAI
;	DEC : BPL -
;	LDA #$80 : STA PPU.display
;	LDA #$06 : STA CPU.hdma
;	DEC DP.frame
	STZ DP.frame
	BRA decompressor

.palette
	db $FF,$FF,$56,$B5,$29,$4A

;video loops here when it ends
.end
	SEI
	STZ CPU.interrupt
	STZ CPU.hdma
	STZ PPU.mainscr
	BRA $FE

;video loop
.loop
	WAI
	incsrc video/videostream.asm