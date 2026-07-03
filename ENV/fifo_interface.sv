interface fifo_if(input bit clk);

	logic rstn;

	//write signals
	logic wr_enb;
	logic [`DATA_WIDTH-1 : 0] data_in;

	//read signals
	logic rd_enb;
	logic [`DATA_WIDTH-1 : 0]data_out;

	//flags
	logic full;
	logic empty;
	logic almostfull;
	logic almostempty;

	clocking fdr_cb@(posedge clk);
		default input #1 output #1;
		output rstn;
		output wr_enb,rd_enb;
		output data_in;
	endclocking

	clocking fmn_cb@(posedge clk);
		default input #1 output #1;
		input rstn;
		input wr_enb,rd_enb;
		input data_in,data_out;
		input full,empty;
		input almostfull,almostempty;
	endclocking


	modport FDR_MP(clocking fdr_cb);

	modport FMON_MP(clocking fmn_cb);

endinterface
