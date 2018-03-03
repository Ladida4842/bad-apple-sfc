!dsp_r = $F2
!dsp_d = $F3

!io0 = $F4
!io1 = $F5
!io2 = $F6
!io3 = $F7

!vol_l0 = $00
!vol_r0 = $01
!p_l0 = $02
!p_h0 = $03
!srcn0 = $04
!adsr0_1 = $05
!adsr0_2 = $06
!gain0 = $07
!envx0 = $08
!outx0 = $09

!vol_l1 = $10
!vol_r1 = $11
!p_l1 = $12
!p_h1 = $13
!srcn1 = $14
!adsr1_1 = $15
!adsr1_2 = $16
!gain1 = $17
!envx1 = $18
!outx1 = $19

!mvol_l = $0C
!mvol_r = $1C
!evol_l = $2C
!evol_r = $3C
!kon = $4C
!kof = $5C
!flg = $6C
!endx = $7C

!efb = $0D
!pmon = $2D
!non = $3D
!eon = $4D
!dir = $5D
!esa = $6D
!edl = $7D

!coef0 = $0F
!coef1 = $1F
!coef2 = $2F
!coef3 = $3F
!coef4 = $4F
!coef5 = $5F
!coef6 = $6F
!coef7 = $7F

!timer_ctrl = $F1
!timer0 = $FA
!timer1 = $FB
!timer2 = $FC
!timer_read0 = $FD
!timer_read1 = $FE
!timer_read2 = $FF

macro wdsp(arg1, arg2)
	MOV A, #<arg1>
	MOV Y, #<arg2>
	MOVW !dsp_r, YA
endmacro

macro wdsp_reg(arg1, arg2)
	MOV $F2, #<arg1>
	MOV A, <arg2>
	MOV $F3, A
endmacro

macro WaitMS(arg1)
	PUSH A
	PUSH Y
	PUSH X
	MOV Y, #<arg1>
	MOV A, #$00
	MOV !timer2, #$40
	MOV !timer_ctrl, #$04
	-
	MOV A, !timer_read2
	BEQ -
	DEC Y
	BNE -
	POP X
	POP Y
	POP A
endmacro

macro Stall(arg1)
	PUSH A
	MOV A, #<arg1>
	-
	DEC A
	BNE -
	POP A
endmacro