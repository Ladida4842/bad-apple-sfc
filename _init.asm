;SNES INITIALIZATION
;initialize most of the cpu and ppu registers to recommended (?) values
;
;SOME NOTES ON INITIAL STATE OF SNES:
;A, X, Y are NOT initialized (except on cold boot?), maintain last value before reset
;DP, SP, and DB, however, are initialized (to $0000, $01FF, and $00)
;stack seems hardcoded in emulation
;initial processor status is:	nv1BdIzc E
;on switching to native:	nvMXdIzC e
;this seems to always be the case (but dont rely on it... <_< )

CLC : XCE
REP #$28
LDA #$2100 : TCD
LDX #$80 : STX $00
TAY : TAX : INX
STY $01
STZ $02
STZ $05
STZ $07
STZ $09
STZ $0B
STZ $0D : STZ $0D
STZ $0F : STZ $0F
STZ $11 : STZ $11
STZ $13 : STZ $13
STY $15
STZ $16
STZ $1A
STX $1B
STZ $1C : STZ $1C
STY $1E : STX $1E
STZ $1F : STZ $1F
STZ $21 : STY $22
STZ $23
STZ $25
STZ $27
STZ $29
STZ $2B
STZ $2D
STY $2F
LDX #$30 : STX $30
STY $31
LDX #$E0 : STX $32
STY $33
STZ $40
STZ $42
ASL : TCD
LDA #$FF00 : STA $00
STZ $02
STZ $04
STZ $06
STZ $08
STZ $0A
STZ $0C			;FastROM (LDA #$0100 : STA $0C enable, STZ $0C disable)
TYA : TCD		;direct page now remains at $0000

;clear VRAM
;can be removed if layer gfx and tilemaps are properly uploaded before being displayed
LDX #$80 : STX $2115
REP #$10
STZ $2116
LDX #$7FFF
-
STZ $2118
DEX : BPL -

LDX #$1FFF : TXS	;stack set up here. change LDX value to move it

;RAM initialization routine here. clears $0000-$1FFF by default
DEX	;LDX #$1FFE
-
STZ $00,x
DEX #2 : BPL -

SEP #$30
PHK : PLB		;data bank now equal to program bank. done late because wasnt needed
STZ $4016		;initializing controller reads. probably bogus with auto-joypad