;== Cartridge Header ===========================================| 
org $00FFC0 : fillbyte $20 : fill 21 : skip -21
	db "Bad Apple!!"
warnpc $00FFD5

org $00FFD5
	db $35		;ROM layout (Fast ExHiROM)
	db $00		;Cartridge type (ROM only)
	db $0D		;ROM size (64MBit, or 8MB)
	db $00		;SRAM size (0)
	db $00		;Country code (Japan NTSC)
	db $00		;Developer code (Null)
	db $00		;Version number (v1.00)
	dw ~$0000 	;Checksum complement
	dw $0000 	;Checksum
warnpc $00FFE0

;== CPU Exception Vectors ======================================|
org $00FFE0
-	JML IRQ
	dw NULL		;(Native) COP
	dw NULL		;(Native) BRK
	dw NULL		;(Native) ABORT
	dw NULL		;(Native) NMI
NULL:	RTI : NOP
	dw -		;(Native) IRQ
-	JML RESET
	dw NULL		;(Emulation) COP
	dw NULL		;[null]
	dw NULL		;(Emulation) ABORT
	dw NULL		;(Emulation) NMI
	dw -		;(Emulation) RESET
	dw NULL		;(Emulation) IRQ/BRK
warnpc $010000