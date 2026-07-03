class fifo_rf;

	//creating transaction class object
	fifo_trans trans_h;

	//Queue Array for reference model logic
	bit[`DATA_WIDTH-1 :0]fifo_q[$:`DEPTH];
	bit flag;

	
	//mailbox
	mailbox #(fifo_trans) mon_rf;
	mailbox #(fifo_trans) rf_sb;
	

	function new (mailbox #(fifo_trans) mon_rf,
		      mailbox #(fifo_trans) rf_sb);
	      this.mon_rf = mon_rf;
	      this.rf_sb = rf_sb;
      	endfunction

	task run();
		forever
		begin
			trans_h = new();

			//get data from monitor to reference model
			mon_rf.get(trans_h);

			//reference model logic 
			predict_data(trans_h);
			if(flag)
			begin
				//put data to score board from reference model
				rf_sb.put(trans_h);
			end
			flag = 1'b1;
			$display("======================================================");
			$display($time,"  REFERENCE MODEL ACT_OUT  = %d",trans_h.data_out);
			$display($time,"  REFERENCE MODEL EXP_OUT = %d",trans_h.exp_data);
			$display("======================================================");

		end
	endtask

	//fifo logic for reference model
	task predict_data(fifo_trans trans_h);

		//reset logic
		if(!trans_h.rstn)
		begin
			fifo_q.delete();
		end
		else
			//write logic
			if(trans_h.wr_enb && !trans_h.full)
			begin
				fifo_q.push_back(trans_h.data_in);
			end
			
			//read logic
			if(trans_h.rd_enb && !trans_h.empty)
			begin
				trans_h.exp_data = fifo_q.pop_front();
			end

			//full flag logic
			if(fifo_q.size == `DEPTH)
			begin
				trans_h.exp_full = 1'b1;
			end

			//empty flag logic
			if(fifo_q.size == 1'b0)
			begin
				trans_h.exp_empty = 1'b1;
			end

			//almost_full flag logic
			if(fifo_q.size == `DEPTH - 1'b1)
			begin
				trans_h.exp_almostfull = 1'b1;
			end

			//almost_empty flag logic
			if(fifo_q.size == 1'b1)
			begin
				trans_h.exp_almostempty = 1'b1;
			end
	endtask

endclass
