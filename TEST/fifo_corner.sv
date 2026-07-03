class fifo_corner extends fifo_gen;


	function new(mailbox #(fifo_trans) gen_dr);
		super.new(gen_dr);
	endfunction

	task run();
		trans_h = new();
		repeat(2)begin
			trans_h.rstn = ~trans_h.rstn;
			put_trans();
		end

		$display("---------------WORST----------------");

		repeat(50) begin
			if(!trans_h.randomize() with {wr_enb == 1'b1; rd_enb ==1'b1;})
				$error("FIFO_GEN","RANDOMIZATION FAILED");
			put_trans();
		end

		repeat(20) begin
			if(!trans_h.randomize() with {wr_enb == 1'b1; rd_enb ==1'b0;})
				$error("FIFO_GEN","RANDOMIZATION FAILED");
			put_trans();
		end

		repeat(50) begin
			if(!trans_h.randomize() with {wr_enb == 1'b1; rd_enb == 1'b1;})
				$error("FIFO_GEN","RANDOMIZATION FAILED");
			put_trans();
		end
	endtask
endclass
