class fifo_env;

	//all verification instance
	fifo_gen gen_h;
	fifo_dr  dr_h;
	fifo_mon mon_h;
	fifo_rf  rf_h;
	fifo_sb  sb_h;

	//mailbox
	mailbox #(fifo_trans) gen_dr = new();
	mailbox #(fifo_trans) mon_rf = new();
	mailbox #(fifo_trans) rf_sb  = new();
	mailbox #(fifo_trans) mon_sb = new();
	

	//interface
	virtual fifo_if.FDR_MP dr_if;
	virtual fifo_if.FMON_MP if_mon;

	function new(virtual fifo_if.FDR_MP dr_if,
		     virtual fifo_if.FMON_MP if_mon);
	     this.dr_if  = dr_if;
	     this.if_mon = if_mon;
        endfunction


	function void build();
//		gen_h = new(gen_dr);
		dr_h  = new(gen_dr,dr_if);
		mon_h = new(mon_rf,mon_sb,if_mon);
		rf_h  = new(mon_rf,rf_sb);
		sb_h  = new(rf_sb,mon_sb);
	endfunction


	task run();
		fork
			gen_h.run();
			dr_h.run();
			mon_h.run();
			rf_h.run();
			sb_h.run();
		join_none
	endtask

endclass
