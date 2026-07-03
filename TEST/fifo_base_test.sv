class fifo_base_test;

	//creating enviounment class object
	fifo_env env_h;

	//testcases
	fifo_reset_check reset_check;
	fifo_write_read write_read;
	fifo_sim sim;
	fifo_b2b b_to_b;
	fifo_corner corner;
	fifo_flag flag;
	

	//interface
	virtual fifo_if.FDR_MP  dr_if;
	virtual fifo_if.FMON_MP mon_if;


	function new (virtual fifo_if.FDR_MP  dr_if,
		      virtual fifo_if.FMON_MP mon_if);
	      this.dr_if = dr_if;
	      this.mon_if = mon_if;
        endfunction


	task build_and_start();
		env_h = new(dr_if,mon_if);
		env_h.build();

		//RESET testcase
		if($test$plusargs("RESET_CHECK"))
		begin
			reset_check = new(env_h.gen_dr);
			env_h.gen_h = reset_check;
		end

		//WRITE_READ testcase
		if($test$plusargs("WRITE_READ"))
		begin
			write_read = new(env_h.gen_dr);
			env_h.gen_h = write_read;
		end

		//SIMULTANOUSLY testcase
		if($test$plusargs("SIMULTANOUSLY"))
		begin
			sim = new(env_h.gen_dr);
			env_h.gen_h = sim;
		end

		//BACT TO BACK testcase
		if($test$plusargs("BACK_TO_BACK"))
		begin
			b_to_b = new(env_h.gen_dr);
			env_h.gen_h = b_to_b;
		end

		//ALL FLAG testcase
		if($test$plusargs("FLAG_TEST"))
		begin
			flag = new(env_h.gen_dr);
			env_h.gen_h = flag;
		end

		//WORST testcase
		if($test$plusargs("CORNER_CASE"))
		begin
			corner = new(env_h.gen_dr);
			env_h.gen_h = corner;
		end
		
		env_h.run();
	endtask

endclass
