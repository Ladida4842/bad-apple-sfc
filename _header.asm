;ROM HEADER
;starts at $00FFC0 (no extended header)
cleartable
%org($00FFC0)
fillbyte $20 : fill 21
%org($00FFC0)

;ROM title, 21 bytes, JIS X 201
db "[TOUHOU] BAD APPLE"
;ショウジョ メーカー プラス	SHI yo U SHI " yo _ ME - KA - _ FU * RA SU

%warnpc($00FFD5)
%org($00FFD5)

db $25		;ROM layout (ExHiROM)
db $00		;Cartridge type (ROM, no external RAM)
db $0D		;ROM size (64MBit, or 8MB)
db $00		;SRAM size (0KB)
db $00		;Country code (Japan NTSC)
db $00		;Developer code (Null)
db $01		;Version number (v1.1)
dw ~$8339 	;Checksum complement
dw $8339 	;Checksum


;ROM VECTORS

dd $FFFFFFFF	;[n/a]
dw $FFFF 	;	COP	(native)
dw BRK		;	BRK	(native)
dw $FFFF 	;[???]	ABORT	(native)
dw $FFFF	;	NMI	(native)
dw $FFFF	;[n/a]	RESET	(native)
dw IRQ		;	IRQ	(native)
dd $FFFFFFFF	;[n/a]
dw $FFFF	;	COP	(emulation)
dw $FFFF	;[n/a]		(emulation)
dw $FFFF	;[???]	ABORT	(emulation)
dw $FFFF	;	NMI	(emulation)
dw RESET	;	RESET	(emulation)
dw $FFFF	;	IRQ/BRK	(emulation)

%warnpc($018000)