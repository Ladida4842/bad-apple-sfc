;dynamic ram allocation is used
;all ram addresses must be prefixed with RAM_ and have a defined byte length

norom
org 0
namespace "RAM"
base $7E0000
skip 16			;RESERVED FOR SCRATCH RAM

brightness: skip 1	;stores to $2100
frame: skip 1		;current frame #, 8bit (why do i need a 16bit one?)

audiostream: skip 3	;address for audio streaming
audiostream_sync: skip 1

vram_addr: skip 2

videoframe: skip 2

decompcode: skip 32

warnpc $7E0100
base $7E0100

namespace off
warnpc $7E1F00
base $7E1F00
skip $0100		;RESERVED FOR STACK AND STRIPE IMAGE UPLOADER

warnpc $7F0000

base $7F0000
VRAM_BUFFER:		;general-purpose buffer for data to be uploaded to VRAM

base off