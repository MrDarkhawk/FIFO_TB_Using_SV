
`include "fifo_defines.sv"
`include "fifo_interface.sv"

package fifo_pkg;
	
	//Enviounment Components
	`include "fifo_trans.sv"
	`include "fifo_gen.sv"
	`include "fifo_dr.sv"
	`include "fifo_mon.sv"
	`include "fifo_rf.sv"
	`include "fifo_sb.sv"
	`include "fifo_env.sv"

	//Testcases
	`include "fifo_reset_check.sv"
	`include "fifo_write_read.sv"
	`include "fifo_sim.sv"
	`include "fifo_b2b.sv"
	`include "fifo_flag.sv"
	`include "fifo_corner.sv"
	`include "fifo_base_test.sv"

endpackage
