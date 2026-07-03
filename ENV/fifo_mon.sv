class fifo_mon;

	//creating transaction class object
	fifo_trans trans_h;

	//mailboxes
	mailbox #(fifo_trans) mon_rf;
	mailbox #(fifo_trans) mon_sb;

	//interface
	virtual fifo_if.FMON_MP vif;

	function new (mailbox #(fifo_trans) mon_rf,
		      mailbox #(fifo_trans) mon_sb,
		      virtual fifo_if.FMON_MP vif);
	      this.mon_rf = mon_rf;
	      this.mon_sb = mon_sb;
	      this.vif = vif;
         endfunction


	 task run();
		 forever
		 begin
			 monitor();

			 //put gata to reference model from monitor
			 mon_rf.put(trans_h);

			 //put data to scoreboard from monitor
			 mon_sb.put(trans_h);

			 $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
			 $display($time,"  MONITOR data_in = %d",trans_h.data_in);
			 $display($time,"  MONITOR data_out = %d",trans_h.data_out);
			 $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
		 end
	 endtask


	 task monitor();
		 @(vif.fmn_cb);
		 trans_h = new();

		 //sampling
		 trans_h.rstn = vif.fmn_cb.rstn;
		 trans_h.wr_enb = vif.fmn_cb.wr_enb;
		 trans_h.rd_enb = vif.fmn_cb.rd_enb;
		 trans_h.data_in = vif.fmn_cb.data_in;
		 trans_h.data_out = vif.fmn_cb.data_out;
		 trans_h.full = vif.fmn_cb.full;
		 trans_h.empty = vif.fmn_cb.empty;
		 trans_h.almostfull = vif.fmn_cb.almostfull;
		 trans_h.almostempty = vif.fmn_cb.almostempty;
	 endtask

 endclass
