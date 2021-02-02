type nul > %~n0.sfc
del %~n0.sfc
asar -wno1029 --pause-mode=on-warning --fix-checksum=on --symbols=wla --symbols-path=%~n0.cpu.sym _main.asm %~n0.sfc