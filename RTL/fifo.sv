//FIFO
//SYNCHRONOUS

`define DEPTH 16
`define DATA_WIDTH 8
`define ADDR_WIDTH 4


module fifo(clk,
	    rstn,
	//INPUT
	    wr_enb,
	    rd_enb,
	    data_in,
	//OUTPUT
	    data_out,
	    empty,
	    full,
    	    almost_full,
    	    almost_empty);


	//port direction
	input clk,rstn;

	//input port
	input wr_enb,rd_enb;
	input[`DATA_WIDTH-1:0]data_in;
	
	//output port
	output reg[`DATA_WIDTH-1:0]data_out;
	output empty,full;
	output almost_full,almost_empty;

	//internal memory
	reg[`DATA_WIDTH-1:0]ram[0:`DEPTH-1];
	reg[`ADDR_WIDTH:0]wr_pointer;
	reg[`ADDR_WIDTH:0]rd_pointer;

	integer i;
	
	//full and empty logic
	assign full = (wr_pointer[`ADDR_WIDTH] !== rd_pointer[`ADDR_WIDTH] && wr_pointer[`ADDR_WIDTH-1:0] == rd_pointer[`ADDR_WIDTH-1:0] ? 1'b1 : 1'b0);
	assign empty = ((wr_pointer == rd_pointer) ? 1'b1 : 1'b0);

	//almost full and almost empty logic
	assign almost_full  = (wr_pointer[`ADDR_WIDTH-1 : 0] == rd_pointer[`ADDR_WIDTH-1 : 0] - 1'b1);
	assign almost_empty = (wr_pointer[`ADDR_WIDTH-1 : 0] == rd_pointer[`ADDR_WIDTH-1 : 0] + 1'b1);


	//implementation
	always@(posedge clk)
	begin
		//reset logic
		if(!rstn)
		begin
			data_out <= `DATA_WIDTH'd0;
			wr_pointer <= 1'b0;
			rd_pointer <= 1'b0;

			for(i = 0; i < `DEPTH; i = i + 1)
			ram[i] <= `DATA_WIDTH'd0;
		end
		else
		begin
			//write and read logic
			if(wr_enb)
			begin
				if(!full)
				begin
					ram[wr_pointer[`ADDR_WIDTH - 1 : 0]] <= data_in;
					wr_pointer <= wr_pointer + 1'b1;
				end
				else 
				begin
					wr_pointer <= wr_pointer;
				end
			end

			if(rd_enb)
			begin
				if(!empty)
				begin
					data_out <= ram[rd_pointer[`ADDR_WIDTH - 1 : 0]];
					rd_pointer <= rd_pointer + 1'b1;
				end
				else
				begin
					rd_pointer <= rd_pointer;
				end
			end
		end
	end
endmodule

