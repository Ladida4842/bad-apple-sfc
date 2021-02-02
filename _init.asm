;SNES INITIALIZATION
;initialize most of the cpu and ppu registers to recommended (?) values
;
;SOME NOTES ON INITIAL STATE OF SNES:
;A, X, Y are NOT initialized (except on cold boot?), maintain last value before reset
;DP, SP, and DB, however, are initialized (to $0000, $01FF, and $00)
;stack seems hardcoded in emulation
;OAM is initialized? But not CGRAM or VRAM
;initial processor status is:	nv1BdIzc E
;on switching to native:	nvMXdIzC e
;this seems to always be the case (but dont rely on it... <_< )

	CLC : XCE
	REP #$28
	LDA #PPU : TCD
	dpbase PPU
	optimize dp always

;PPU regs
	LDX #$80 : STX PPU.display
	TAY : TAX : INX
	STY PPU.obsel
	STZ PPU.oamaddr
	STZ PPU.bgmode
	STZ PPU.bg1map
	STZ PPU.bg3map
	STZ PPU.bg12gfx
	STY PPU.bg1x : STY PPU.bg1x
	STY PPU.bg1y : STY PPU.bg1y
	STY PPU.bg2x : STY PPU.bg2x
	STY PPU.bg2y : STY PPU.bg2y
	STY PPU.bg3x : STY PPU.bg3x
	STY PPU.bg3y : STY PPU.bg3y
	STY PPU.bg4x : STY PPU.bg4x
	STY PPU.bg4y : STY PPU.bg4y
	STZ PPU.m7sel
	STX PPU.m7a
	STZ PPU.m7b : STZ PPU.m7b
	STY PPU.m7d : STX PPU.m7d
	STY PPU.m7x : STY PPU.m7x
	STY PPU.m7y : STY PPU.m7y
	STZ PPU.bg12mask
	STY PPU.objmask
	STZ PPU.win1L
	STZ PPU.win2L
	STZ PPU.bgmasklog
	STZ PPU.mainscr
	STZ PPU.mainscrmask
	LDX #$30 : STX PPU.cgwsel
	STY PPU.cgadsub
	LDX #$E0 : STX PPU.coldata
	STY PPU.setini
	STZ APU.io0
	STZ APU.io2

;clear CGRAM
;	STY PPU.cgramaddr
;	TYX
;-	STY PPU.cgramdata
;	STY PPU.cgramdata
;	DEX : BNE -

;clear VRAM
	LDX #$80
	STX PPU.vramctrl
	REP #$10
	STZ PPU.vramaddr
	LDX #$7FFF
-	STZ PPU.vramdata
	DEX : BPL -

	ASL : TCD
	dpbase CPU

;CPU regs
	LDA #$FF00 : STA CPU.interrupt
	STZ CPU.multA
	STZ CPU.dividend
	STZ CPU.divisor
	STZ CPU.htimeHi
	STZ CPU.vtimeHi
	if !fastrom
		STA CPU.hdma
	else
		STZ CPU.hdma
	endif

	TYA : TCD		;direct page
	LDX.w #!stack : TXS	;stack
	optimize dp none

;RAM init [$0000-$1FFF]
;	DEX
;-	STZ $00,x
;	DEX #2
;	BPL -
	STZ $00
	TYX
	INY
	LDA #$1FFF
	MVN $80,$80

	SEP #$30
;	PHK : PLB
	STZ NES.joy0		;init controller (prolly bogus with auto-joy)