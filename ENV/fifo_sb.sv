`ifndef FIFO_SB_SV
`define FIFO_SB_SV

class fifo_sb;

	//Queue array for wait data
	bit[`DATA_WIDTH-1 : 0]act_trans_q[$];
	bit[`DATA_WIDTH-1 : 0]exp_trans_q[$];

	bit[`DATA_WIDTH-1 : 0]act_data,exp_data;

	//crating transaction class object
	fifo_trans act_trans,exp_trans;

	//mailbox
	mailbox #(fifo_trans) mon_sb;
	mailbox #(fifo_trans) rf_sb;

	//FUNCTIONAL COVERAGE
	covergroup cvg;
		//write enb bins
		COV1 : coverpoint act_trans.wr_enb{bins WR_ENB0 = (0 => 1);
						   bins WR_ENB1 = (1 => 0);}

		//rd_enb bins				   
		COV2 : coverpoint act_trans.rd_enb{bins RD_ENB0 = (0 => 1);
						   bins RD_ENB1 = (1 => 1);}

		//full flag bins				   
		COV3 : coverpoint act_trans.full{bins FULL0 = (0 => 1);
						 bins FULL1 = (1 => 0);}
		
		//empty flag bins				 
		COV4 : coverpoint act_trans.empty{bins EMPTY0 = (0 => 1);
						  bins EMPTY1 = (1 => 0);}

		
		//almostfull flag bins				  
		COV5 : coverpoint act_trans.almostfull{bins ALMOSTFULL0 = (0 => 1);
						       bins ALMOSTFULL1 = (1 => 0);}

		//almostempty flag bins				       
		COV6 : coverpoint act_trans.almostempty{bins ALMOSTEMPTY0 = (0 => 1);
							bins ALMOSTEMPTY1 = (1 => 0);}

		//data_in bins
		COV7 : coverpoint act_trans.data_in iff (act_trans.wr_enb){bins DATA_IN_LOW = {[0:30]};
						    			   bins DATA_IN_MID = {[125:145]};
						    			   bins DATA_IN_HIGH = {[240:255]};}

		//data_out bins
		COV8 : coverpoint exp_trans.exp_data iff(exp_trans.rd_enb){bins DATA_OUT_LOW = {[0:30]};
						     			   bins DATA_OUT_MID = {[125:145]};
									   bins DATA_OUT_HIGH = {[240:255]};}

		//cross coverage for wr_enb and rd_enb
		COV9 : cross act_trans.wr_enb,act_trans.rd_enb;

	endgroup
					    

	function new (mailbox #(fifo_trans) mon_sb,
		      mailbox #(fifo_trans) rf_sb);
	      this.mon_sb = mon_sb;
	      this.rf_sb = rf_sb;
	      cvg = new();
      	endfunction

	task run();
		forever
		begin
			act_trans = new();
			exp_trans = new();

			fork
				begin
					//get data from scorboard to monitor
					mon_sb.get(act_trans);
	//				cvg.sample();
					act_trans_q.push_back(act_trans.data_out);
				end
				begin
					//get data from reference model to score board
					rf_sb.get(exp_trans);
					exp_trans_q.push_back(exp_trans.exp_data);
				end
			join
				
//			$display($time,"  SCORE BOARD ACT_DATA = %d",act_trans.data_out);
//			$display($time,"  SCORE BOARD EXP_DATA = %d",exp_trans.exp_data);

			//checker 
			check_data(act_trans,exp_trans);
			cvg.sample();
		end
	endtask

	//checker logic method
	task check_data(fifo_trans act_trans,fifo_trans exp_trans);
		begin
			fork
				wait(act_trans_q.size != 0);
				wait(exp_trans_q.size != 0);
			join

		if(act_trans.data_out == exp_trans.exp_data)
			$display("PASS....!!!!!  act_data %d == %d exp_data",act_trans.data_out,exp_trans.exp_data);
		else
			$display("FAIL....?????  act_data %d == %d exp_data",act_trans.data_out,exp_trans.exp_data);

		if(act_trans.full == exp_trans.exp_full)
			$display("PASS....!!!!!  act_full %b <===> %b  exp_full",act_trans.full,exp_trans.exp_full);
		else
			$display("FAIL....?????  act_full %b <===> %b  exp_full",act_trans.full,exp_trans.exp_full);

		if(act_trans.empty == exp_trans.exp_empty)
			$display("PASS....!!!!!  act_empty %b <===> %b  exp_empty",act_trans.empty,exp_trans.exp_empty);
		else
			$display("FAIL....?????  act_empty %b <===> %b  exp_empty",act_trans.empty,exp_trans.exp_empty);


		if(act_trans.almostfull == exp_trans.exp_almostfull)
			$display("PASS....!!!!!  act_almost_full %b <===> %b  exp_almost_full",act_trans.almostfull,exp_trans.exp_almostfull);
		else
			$display("FAIL....?????  act_almost_full %b <===> %b  exp_almost_full",act_trans.almostfull,exp_trans.exp_almostfull);

		if(act_trans.almostempty == exp_trans.exp_almostempty)
			$display("PASS....!!!!!  act_almost_empty %b <===> %b  exp_almost_empty",act_trans.almostempty,exp_trans.exp_almostempty);
		else
			$display("FAIL....?????  act_almost_empty %b <===> %b  exp_almost_empty",act_trans.almostempty,exp_trans.exp_almostempty);
		end	
	endtask
endclass

`endif
