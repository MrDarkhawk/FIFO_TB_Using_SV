`ifndef FIFO_TRANS_SV
`define FIFO_TRANS_SV


class fifo_trans;

	//input signals
	bit rstn = 1'b1;

	rand bit wr_enb,rd_enb;
	rand bit [`DATA_WIDTH-1 : 0]data_in;

	//output signals
	rand bit [`DATA_WIDTH-1 : 0]data_out;
	bit full ,empty;
	bit almostfull,almostempty;

	bit [`DATA_WIDTH-1 : 0]exp_data;
	bit exp_full,exp_empty;
	bit exp_almostfull,exp_almostempty;


	constraint ENB {soft wr_enb == 1'b1; soft rd_enb == 1'b1;}

endclass

`endif
