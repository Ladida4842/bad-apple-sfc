;Bad Apple!!

;original track from Lotus Land Story (C) ZUN
;remix (C) Nomico [voice], Masayoshi Minoshima, Alstroemeria Records
;animation source (C) Anira
;source code (C) Ladida

@asar 1.80


!fastrom = 1
!stack = $433B

!length = 4380		;# of video frames, -1


optimize address mirrors

norom
check bankcross off
org 0
fillbyte $00 : fill $800000
incsrc _common.asm
incsrc RAM.asm
check bankcross on


arch 65816
exhirom

incbin audio/badapple_32khz.brr -> $400000
incsrc video/files.txt

org $80C000

incsrc RESET.asm
incsrc IRQ.asm
;incsrc video/videostream.asm
incsrc audio/audiostream.asm
incsrc audio/_spcupload.asm

incsrc _header.asm