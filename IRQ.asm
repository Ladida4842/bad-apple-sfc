IRQ:
	REP #$39
	PHA : PHY : PHX : PHB : PHK : PLB
	SEP #$30

	LDA CPU.irqflag
	LDX #$80
	LDA #$06 : STA CPU.hdma

	LDA DP.audiosync
	BIT #$02 : BNE .null
	EOR #$01
	LSR
	REP #$20
	LDA #$1800 : STA DMA[0].size
	LDA DP.vramaddr
	STX PPU.display
	BCS .odd
.even
	STA PPU.vramaddr
	LDA #$0000 : STA DMA[0].src
	SEP #$21
	ROL : STA CPU.dma
.null
	JMP HDMA_Update

.odd
	ADC #$0BFF : STA PPU.vramaddr
	LDA #$1800 : STA DMA[0].src
	SEP #$21
	ROL : STA CPU.dma
	LDA DP.vramaddr+1
	STA PPU.bg12gfx
	EOR #$20
	STA DP.vramaddr+1
	JMP HDMA_Update
