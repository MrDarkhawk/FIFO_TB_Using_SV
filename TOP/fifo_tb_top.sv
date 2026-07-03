import fifo_pkg::*;

module fifo_tb_top();

	bit clk;

	fifo_base_test test_h;

	fifo_if inf(clk);

	//dut instantiation
	fifo DUT (.clk(clk),
		  .rstn(inf.rstn),
		  .wr_enb(inf.wr_enb),
		  .rd_enb(inf.rd_enb),
		  .data_in(inf.data_in),
		  .data_out(inf.data_out),
		  .empty(inf.empty),
		  .full(inf.full),
		  .almost_full(inf.almostfull),
		  .almost_empty(inf.almostempty));

	  always
		  #5 clk =~clk;

	  //RESET task
/*	  task reset();
		  inf.rstn = 1'b0;
		  #10;
		  inf.rstn = 1'b1;
	  endtask
*/

	  initial
	  begin
//		  reset();

		  test_h = new(inf.FDR_MP,inf.FMON_MP);
		  test_h.build_and_start();
		  #500 $finish;
	  end

endmodule

