COMP:
	vlog -coveropt 3 +cover +acc ../RTL/fifo.sv ../TEST/fifo_pkg.sv ../TOP/fifo_tb_top.sv +incdir+../ENV +incdir+../TEST
SIM:
	vsim -vopt fifo_tb_top -c -do "run -all;exit"

RESET_COMP:
	vsim -vopt fifo_tb_top +RESET_CHECK
RESET1:
	vsim -vopt -coverage fifo_tb_top -c -do "coverage save -onexit -directive -cvg -codeall reset_check.ucdb; run -all; exit" +RESET_CHECK	
RESET2:
	vcover report -html -htmldir RESET reset_check.ucdb

WRITE_READ_COMP:
	vsim -vopt fifo_tb_top +WRITE_READ
WRITE_READ1:
	vsim -vopt -coverage fifo_tb_top -c -do "coverage save -onexit -directive -cvg -codeall write_read.ucdb; run -all; exit" +WRITE_READ
WRITE_READ2:
	vcover report -html -htmldir WRITE_READ write_read.ucdb


SIMTY_COMP:
	vsim -vopt fifo_tb_top +SIMULTANOUSLY
SIMTY1:
	vsim -vopt -coverage fifo_tb_top -c -do "coverage save -onexit -directive -cvg -codeall simultanously.ucdb; run -all; exit" +SIMULTANOUSLY
SIMTY2:
	vcover report -html -htmldir SIMULTANOUSLY simultanously.ucdb

B2B_COMP:
	vsim -vopt fifo_tb_top +BACK_TO_BACK
B2B1:
	vsim -vopt -coverage fifo_tb_top -c -do "coverage save -onexit -directive -cvg -codeall b2b.ucdb; run -all; exit" +BACK_TO_BACK
B2B2:
	vcover report -html -htmldir B2B b2b.ucdb
	
FLAG_COMP:
	vsim -vopt fifo_tb_top +FLAG_TEST
FLAG1:
	vsim -vopt -coverage fifo_tb_top -c -do "coverage save -onexit -directive -cvg -codeall flag.ucdb; run -all; exit" +FLAG_TEST
FLAG2:
	vcover report -html -htmldir FLAG flag.ucdb

CORNER_COMP:
	vsim -vopt fifo_tb_top +CORNER_CASE
CORNER1:
	vsim -vopt -coverage fifo_tb_top -c -do "coverage save -onexit -directive -cvg -codeall corner.ucdb; run -all; exit" +CORNER_CASE
CORNER2:
	vcover report -html -htmldir CORNER corner.ucdb
	
RESET: RESET1

WRITE_READ: WRITE_READ1

SIMTY: SIMTY1

B2B: B2B1

FLAG: FLAG1

CORNER: CORNER1

MERGE:
	vcover merge fifo_merge.ucdb reset_check.ucdb write_read.ucdb b2b.ucdb simultanously.ucdb flag.ucdb corner.ucdb
HTML:
	vcover report -html -htmldir FIFO fifo_merge.ucdb
	
RUN: COMP SIM RESET WRITE_READ SIMTY B2B FLAG CORNER MERGE HTML