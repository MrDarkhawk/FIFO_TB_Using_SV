`ifndef FIFO_GEN_SV
`define FIFO_GEN_SV
virtual class fifo_gen;

	//creating transaction class object
	fifo_trans trans_h,trans_h_copy;

	//mailbox
	mailbox #(fifo_trans) gen_dr;

	//description
	function new (mailbox #(fifo_trans) gen_dr);
		this.gen_dr = gen_dr;
		trans_h = new();
	endfunction


	virtual task run();
	endtask

/*	task run();
		repeat(2) begin
			trans_h = new();
			trans_h.rstn = ~trans_h.rstn;
			gen_dr.put(trans_h);
		end

		trans_h = new();
		repeat(20) begin
			trans_h = new();
			if(!trans_h.randomize())
				$error("FIFO_GEN","RANDOMIZATION FAILED");
			gen_dr.put(trans_h);
			#10;
		end
	endtask
*/
	task put_trans();
		trans_h_copy = new trans_h;
		gen_dr.put(trans_h_copy);
	endtask

endclass

`endif
