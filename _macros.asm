; ExHiROM macros ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; use these instead of regular commands. ROM must be assembled as norom, with -nocheck ;

macro org(addr)
if <addr>&$400000 != $400000
	assert <addr>&$008000 == $008000
	org <addr>&$3FFFFF|$400000
elseif <addr>>>16 < $80
	org <addr>&$3FFFFF|$400000
	if <addr>>>16 >= $70 && <addr>&$008000 != $008000
		print pc
		print "code will assemble; will not be accessible during runtime"
	elseif <addr>>>16 >= $7E && <addr>&$008000 == $008000
		print pc
		print "code will assemble; should be accessed through banks $3E-3F or $BE-BF"
	endif
else
	org <addr>&$3FFFFF
endif
base <addr>
endmacro

macro warnpc(addr)
if <addr>&$400000 != $400000
	assert <addr>&$008000 == $008000
	warnpc <addr>&$3FFFFF|$400000
elseif <addr>>>16 < $80
	warnpc <addr>&$3FFFFF|$400000
else
	warnpc <addr>&$3FFFFF
endif
endmacro

macro incbin(file, addr)
if <addr>&$400000 != $400000
	assert <addr>&$008000 == $008000
	incbin <file> -> <addr>&$3FFFFF|$400000
elseif <addr>>>16 < $80
	if <addr>>>16 >= $70 && <addr>&$008000 != $008000
		print "file will insert; will not be accessible during runtime"
	elseif <addr>>>16 >= $7E && <addr>&$008000 == $008000
		print "file will insert; should be accessed through banks $3E-3F or $BE-BF"
	endif
	incbin <file> -> <addr>&$3FFFFF|$400000
else
	incbin <file> -> <addr>&$3FFFFF
endif
endmacro


; DMA macros ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

macro VRAMWrite(data, dmadef, srcbank, srcaddr, destaddr, datasize)
PHA : PHY : PHP
REP #$20		; 16-bit A
SEP #$10		; 8-bit XY
LDY <data>		; usually #$80
STY $2115		; increment after reading the high byte of the VRAM data write ($2119)
LDA <destaddr>		;
STA $2116		; VRAM address
LDA <dmadef>		; usually #$1801
STA $4300		; 2 regs write once, $2118
LDA <srcaddr>		;
STA $4302		; set the lower two bytes of the source address
LDY <srcbank>		;
STY $4304		;
LDA <datasize>		; number of bytes to transfer
STA $4305		;
LDY #$01		; DMA channel 0
STY $420B		;
PLP : PLY : PLA
endmacro

macro VRAMRead(data, dmadef, destbank, destaddr, srcaddr, datasize)
PHA : PHY : PHP
REP #$20		; 16-bit A
SEP #$10		; 8-bit XY
LDY <data>		; usually #$80
STY $2115		; increment after reading the high byte of the VRAM data read ($213A)
LDA <srcaddr>		;
STA $2116		; VRAM address
LDA $2139		; "dummy read"
LDA <dmadef>		; usually #$3981
STA $4300		; 2 regs write once, $2139
LDA <destaddr>		;
STA $4302		; set the lower two bytes of the destination address
LDY <destbank>		;
STY $4304		;
LDA <datasize>		; number of bytes to transfer
STA $4305		;
LDY #$01		; DMA channel 0
STY $420B		;
PLP : PLY : PLA
endmacro

macro CGRAMWrite(srcbank, srcaddr, destaddr, datasize)
PHA : PHY : PHP
REP #$20		; 16-bit A
SEP #$10		; 8-bit XY
LDY <destaddr>		;
STY $2121		;
LDA #$2202		; usually #$2202
STA $4300		; 1 reg write twice, $2122
LDA <srcaddr>		;
STA $4302		; set the lower two bytes of the destination address
LDY <srcbank>		;
STY $4304		;
LDA <datasize>		; number of bytes to transfer
STA $4305		;
LDY #$01		; DMA channel 0
STY $420B		;
PLP : PLY : PLA
endmacro

macro CGRAMRead(srcaddr, destbank, destaddr, datasize)
PHA : PHY : PHP
REP #$20		; 16-bit A
SEP #$10		; 8-bit XY
LDY <srcaddr>		;
STY $2121		;
LDA #$3B82		; usually #$3B82
STA $4300		; 1 reg read twice, $213B
LDA <destaddr>		;
STA $4302		; set the lower two bytes of the destination address
LDY <destbank>		;
STY $4304		;
LDA <datasize>		; number of bytes to transfer
STA $4305		;
LDY #$01		; DMA channel 0
STY $420B		;
PLP : PLY : PLA
endmacro

macro WRAMRW(dmadef, destaddr, destbank, srcaddr, srcbank, datasize)
PHA : PHY : PHP
REP #$20		; 16-bit A
SEP #$10		; 8-bit XY
LDA <destaddr>		;
STA $2181		;
LDY <destbank>		;
STY $2183		;
LDA #$80<dmadef>	; #$8000 (or #$8080 for read)
STA $4300		; 1 reg write (read) once, $2180
LDA <srcaddr>		;
STA $4302		; set the lower two bytes of the destination address
LDY <srcbank>		;
STY $4304		;
LDA <datasize>		; number of bytes to transfer
STA $4305		;
LDY #$01		; DMA channel 0
STY $420B		;
PLP : PLY : PLA
endmacro

macro OAMWrite(srcbank, srcaddr, datasize)
PHA : PHY : PHP
REP #$20		; 16-bit A
SEP #$10		; 8-bit XY
STZ $2102
LDA #$0400		;
STA $4300		; 1 reg write once, $2104
LDA <srcaddr>		;
STA $4302		; set the lower two bytes of the source address
LDY <srcbank>		;
STY $4304		;
LDA <datasize>		; number of bytes to transfer
STA $4305		;
LDY #$01		; DMA channel 0
STY $420B		;
PLP : PLY : PLA
endmacro

macro OAMRead(destbank, destaddr, datasize)
PHA : PHY : PHP
REP #$20		; 16-bit A
SEP #$10		; 8-bit XY
LDA #$3880		;
STA $4300		; 1 reg read once, $2138
LDA <destaddr>		;
STA $4302		; set the lower two bytes of the destination address
LDY <destbank>		;
STY $4304		;
LDA <datasize>		; number of bytes to transfer
STA $4305		;
LDY #$01		; DMA channel 0
STY $420B		;
PLP : PLY : PLA
endmacro


; Push Everything macros ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; if i = 0, dont push processor status but push dp, else push p but dont push dp ;;;;;;;

macro pushall(i)
if <i>
PHP
endif
REP #$30
PHA : PHY : PHX : PHB : PHK : PLB
if <i>
else
PHD : LDA #$0000 : TCD
endif
SEP #$30
endmacro

macro pullall(i)
REP #$30
if <i>
else
PLD
endif
PLB : PLX : PLY : PLA
if <i>
PLP
endif
endmacro