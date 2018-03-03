!S = $D8			; 0x10 bytes in $7E00XX that aren't touched during interrupts (NMI or IRQ)

macro ReadByte()
	STX $8A
	LDA [$8A]
	INX
	BNE +
	LDX #$8000
	INC.b $03+!S
	INC $8C
+
endmacro

DecompLZ2:
	PHB
	SEP #$20
	REP #$10
	LDA $02
	PHA
	PLB
	STA.b $02+!S	; dest_bank (direct-copy)
	STA.b $0B+!S	; dest_bank (indirect-copy)
	STA.b $0C+!S	; src_bank (indirect-copy)
	INC
	STA.b $00+!S	; dest_bank [plus or minus]
	LDA #$54
	STA.b $01+!S	; mvn (direct-copy)
	STA.b $0A+!S	; mvn (indirect-copy)
	LDA #$4C
	STA.b $04+!S	; jmp (direct-copy)
	STA.b $0D+!S	; jmp (indirect-copy)
	LDA $8C
	STA.b $03+!S	; src_bank (direct-copy)
	LDX.w #.back
	STX.b $05+!S	; jmp to (direct-copy)
	LDX.w #.back2
	STX.b $0E+!S	; jmp to (indirect-copy)
	
	LDY $00		; dest_low
	LDX $8A		; src_low
	STZ $8A
	STZ $8B
	BRA .main
	
.end
	SEP #$30
	PLB
	RTS

.case_e0_or_end
	LDA $8D
	CMP #$1F
	BEQ .end

	AND #$03
	STA $8E
	EOR $8D
	ASL
	ASL
	ASL
	XBA
	%ReadByte()
	STA $8D
	XBA
	BRA .type

.case_80_or_else
	BMI .case_e0_or_end

	%ReadByte()
	XBA
	%ReadByte()
	
	STX.b $08+!S
	REP #$21
	ADC $00
	TAX
	LDA $8D
	SEP #$20
	JMP $000A+!S

.back2
	LDX.b $08+!S
	
.main
	%ReadByte()
	STA $8D
	STZ $8E
	AND #$E0
	TRB $8D

.type
	ASL
	BCS .case_80_or_else
	BMI .case_40_or_60
	ASL
	BMI .case_20

.case_00
	REP #$20
	LDA $8D
	STX $8D
	
-	SEP #$20
	JMP $0001+!S
	
.back
	CPX $8D
	BCS .main
	
	INC.b $03+!S
	INC $8C
	CPX #$0000
	BEQ ++
	
	DEX
	STX.b $08+!S
	REP #$21
	LDX #$8000
	STX $8D
	TYA
	SBC.b $08+!S
	TAY
	LDA.b $08+!S
	BRA -
	
++	LDX #$8000
	BRA .main

.case_20
	%ReadByte()
	STX.b $08+!S
	PHA
	PHA
	REP #$20
	
.case_20_main
	LDA $8D
	INC
	LSR
	TAX
	PLA
	
-	STA $0000,Y
	INY
	INY
	DEX
	BNE -
	
	SEP #$20
	BCC +
	STA $0000,Y
	INY
+	LDX.b $08+!S
	BRA .main
	
.case_40_or_60
	ASL
	BMI .case_60
	%ReadByte()
	XBA
	%ReadByte()

	XBA
	STX.b $08+!S
	REP #$20
	PHA
;Replace BRA .case_20_main the code itself
	LDA $8D
	INC
	LSR
	TAX
	PLA
-	STA $0000,Y
	INY
	INY
	DEX
	BNE -
	SEP #$20
	BCC +
	STA $0000,Y
	INY
+	LDX.b $08+!S
	JMP .main
	
.case_60
	%ReadByte()
	STX.b $08+!S
	LDX $8D
-	STA $0000,Y
	INC
	INY
	DEX
	BPL -
	LDX.b $08+!S
	JMP .main