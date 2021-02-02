;== SFC-side MMIO ==============================================| 

PPU = $2100
struct PPU PPU
	.display:	skip 1
	.obsel:		skip 1
	.oamaddr:
	.oamaddrLo:	skip 1
	.oamaddrHi:	skip 1
	.oamdata:	skip 1
	.bgmode:	skip 1
	.mosaic:	skip 1
	.bg1map:	skip 1
	.bg2map:	skip 1
	.bg3map:	skip 1
	.bg4map:	skip 1
	.bg12gfx:	skip 1
	.bg34gfx:	skip 1
	.bg1x:		skip 1
	.bg1y:		skip 1
	.bg2x:		skip 1
	.bg2y:		skip 1
	.bg3x:		skip 1
	.bg3y:		skip 1
	.bg4x:		skip 1
	.bg4y:		skip 1
	.vramctrl:	skip 1
	.vramaddr:
	.vramaddrLo:	skip 1
	.vramaddrHi:	skip 1
	.vramdata:
	.vramdataLo:	skip 1
	.vramdataHi:	skip 1
	.m7sel:		skip 1
	.m7a:		skip 1
	.m7b:		skip 1
	.m7c:		skip 1
	.m7d:		skip 1
	.m7x:		skip 1
	.m7y:		skip 1
	.cgramaddr:	skip 1
	.cgramdata:	skip 1
	.bg12mask:	skip 1
	.bg34mask:	skip 1
	.objmask:	skip 1
	.win1L:		skip 1
	.win1R:		skip 1
	.win2L:		skip 1
	.win2R:		skip 1
	.bgmasklog:	skip 1
	.objmasklog:	skip 1
	.mainscr:	skip 1
	.subscr:	skip 1
	.mainscrmask:	skip 1
	.subscrmask:	skip 1
	.cgwsel:	skip 1
	.cgadsub:	skip 1
	.coldata:	skip 1
	.setini:	skip 1
	.multLo:	skip 1
	.multHi:	skip 1
	.multBk:	skip 1
	.latch:		skip 1
	.oamread:	skip 1
	.vramread:
	.vramreadLo:	skip 1
	.vramreadHi:	skip 1
	.cgramread:	skip 1
	.hcount:	skip 1
	.vcount:	skip 1
	.stat77:	skip 1
	.stat78:	skip 1
endstruct

APU = $2140
struct APU APU
	.io0:	skip 1
	.io1:	skip 1
	.io2:	skip 1
	.io3:	skip 1
endstruct

WRAM = $2180
struct WRAM WRAM
	.data:		skip 1
	.addr:
	.addrLo:	skip 1
	.addrHi:	skip 1
	.addrBk:	skip 1
endstruct

NES = $4016
struct NES NES
	.joy0:		skip 1
	.joy1:		skip 1
endstruct

CPU = $4200
struct CPU CPU
	.interrupt:	skip 1
	.iowrite:	skip 1
	.multA:		skip 1
	.multB:		skip 1
	.dividend:
	.dividendLo:	skip 1
	.dividendHi:	skip 1
	.divisor:	skip 1
	.htime:
	.htimeLo:	skip 1
	.htimeHi:	skip 1
	.vtime:
	.vtimeLo:	skip 1
	.vtimeHi:	skip 1
	.dma:		skip 1
	.hdma:		skip 1
	.fastrom:	skip 1
			skip 2
	.nmiflag:	skip 1
	.irqflag:	skip 1
	.ppustatus:	skip 1
	.ioread:	skip 1
	.quotient:
	.quotientLo:	skip 1
	.quotientHi:	skip 1
	.product:
	.productLo:
	.remainder:
	.remainderLo:	skip 1
	.productHi:
	.remainderHi:	skip 1
			skip -1
endstruct

struct JOY extends CPU
	.Lo:		skip 1
	.Hi:		skip 1
endstruct align 2

DMA = $4300
struct DMA DMA
	.ctrl:		skip 1
	.reg:		skip 1
	.src:
	.srcLo:		skip 1
	.srcHi:		skip 1
	.srcBk:		skip 1
	.size:
	.sizeLo:
	.ind:
	.indLo:		skip 1
	.sizeHi:
	.indHi:		skip 1
	.indBk:		skip 1
	.table:
	.tableLo:	skip 1
	.tableHi:	skip 1
	.line:		skip 1
	.misc:		skip 1
endstruct align 16


;== APU-side MMIO ==============================================| 

SPC = $F0
struct SPC SPC
	.speed:		skip 1
	.timerctrl:	skip 1
	.dspaddr:	skip 1
	.dspdata:	skip 1
	.io0:		skip 1
	.io1:		skip 1
	.io2:		skip 1
	.io3:		skip 1
	.misc0:		skip 1
	.misc1:		skip 1
	.timer0:	skip 1
	.timer1:	skip 1
	.timer2:	skip 1
	.counter0:	skip 1
	.counter1:	skip 1
	.counter2:	skip 1
endstruct

DSP = $00
struct DSP DSP
	.volL:		skip 1
	.volR:		skip 1
	.pitch:
	.pitchLo:	skip 1
	.pitchHi:	skip 1
	.srcn:		skip 1
	.adsr1:		skip 1
	.adsr2:		skip 1
	.gain:		skip 1
	.envx:		skip 1
	.outx:		skip 1
			skip 5
	.coef:		skip 1
endstruct align 16

struct REG extends DSP
			skip -4
	.mainvolL:	skip 1
	.efb:		skip 15
	.mainvolR:	skip 16
	.echovolL:	skip 1
	.pitchmod:	skip 15
	.echovolR:	skip 1
	.noiseOn:	skip 15
	.keyOn:		skip 1
	.echoOn:	skip 15
	.keyOff:	skip 1
	.srcdir:	skip 15
	.flg:		skip 1
	.echodir:	skip 15
	.endx:		skip 1
	.echodelay:	skip 1
endstruct