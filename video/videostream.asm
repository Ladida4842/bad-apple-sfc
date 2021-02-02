decompressor:
	LDA DP.audiosync
	CMP #$02 : BNE RESET_loop
	REP #$30
	LDA DP.videoframe
	CMP.w #!length+1
	BEQ RESET_end
	ASL
	ADC DP.videoframe
	TAX
	INC DP.videoframe
	LDY.w FramePointers,x
	LDA.w FramePointers+1,x
	LDX #$0000
	AND #$FF00
	ORA #$007F
	
	incsrc decomp.asm


FramePointers:
	!counter = 0
	while !counter <= !length
		if !counter < 10
			!count = 000!counter
		elseif !counter < 100
			!count = 00!counter
		elseif !counter < 1000
			!count = 0!counter
		else
			!count = !counter
		endif
		dl ba!{count}
		!counter #= !counter+1
	endif