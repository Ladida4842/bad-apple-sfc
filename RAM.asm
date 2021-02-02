struct DP $804340
	.videoframe:	skip 2
	.vramaddr:	skip 2
	.tablemaker1:	skip 2
	.tablemaker2:	skip 2
			skip 8
	.indirect:	skip 3
	.counter1:	skip 2
	.counter2:	skip 2
	.frame:		skip 1
	.audiostream:	skip 3
	.audiosync:	skip 1
			skip 4
endstruct

struct decomp extends DP
	.src:		skip 3
	.dest:		skip 3
	.misc:		skip 2
	.backup:	skip 4
			skip 4
	.work:		skip 12
			skip 4
endstruct

struct RAM $0600
	.shorttable:	skip $180
	.longtable:	skip $180
	.addresses:	skip $200
endstruct