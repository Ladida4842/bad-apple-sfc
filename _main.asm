;Loli Maker Plus
;(C) 2015-2016 Ladida

incsrc _macros.asm	;general macros, not all used
incsrc _RAM.asm		;RAM addresses, important

norom

%org($008000)

incsrc RESET.asm
incsrc IRQ.asm
incsrc BRK.asm

incsrc _spcupload.asm

incsrc audiostream.asm
incsrc videostream.asm

incsrc decomp_lz2.asm

incsrc pointers.txt

%warnpc($00FFC0)
incsrc _header.asm

%incbin(badapple_new.brr,$410000)

incsrc files.txt

org $7FFFFF
db $00