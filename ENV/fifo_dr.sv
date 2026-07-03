class fifo_dr;

	//creating transaction class object
	fifo_trans trans_h;

	//mailbox
	mailbox #(fifo_trans) gen_dr;

	//interface
	virtual fifo_if.FDR_MP vif;

	function new(mailbox #(fifo_trans) gen_dr,
		     virtual fifo_if.FDR_MP vif);
	     this.gen_dr = gen_dr;
	     this.vif = vif;
        endfunction

	task run();
		forever
		begin
			//get data from generator to driver
			gen_dr.get(trans_h);
			send_to_dut();
			$display($time,"   DRIVER data_in = %d",trans_h.data_in);
			$display($time,"   DRIVER data_out = %d",trans_h.data_out);
	//		$display("DRIVER = %p",trans_h);
		end
	endtask

	//send data to DUT method
	task send_to_dut();
		@(vif.fdr_cb);

		//sampling 
		vif.fdr_cb.wr_enb  <= trans_h.wr_enb;
		vif.fdr_cb.data_in <= trans_h.data_in;
		vif.fdr_cb.rd_enb  <= trans_h.rd_enb;
		vif.fdr_cb.rstn    <= trans_h.rstn;
	endtask

endclass
