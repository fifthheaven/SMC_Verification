class smc_command_split extends uvm_scoreboard;

	`uvm_component_utils(smc_command_split)
	uvm_tlm_analysis_fifo #(command_msg) cmdfifo;
	uvm_tlm_analysis_fifo #(out_msg) outfifo;
	uvm_tlm_analysis_fifo #(recirc_sign_msg) rsfifo;  //recirc_sign msg needed
	uvm_analysis_port #(align_msg) align_port;
	uvm_analysis_port #(active_msg) active_port;


	command_msg c_msg;
	recirc_sign_msg rs_msg;
	align_msg a_msg;
	active_msg ac_msg;
	out_msg o_msg;

	function new(string name="smc_command_split", uvm_component par=null);
		super.new(name, par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		cmdfifo = new("cmdfifo", this);
		outfifo = new("outfifo", this);
		rsfifo = new("rsfifo", this);
		align_port = new("align_port", this);
		active_port = new("active_port", this);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		forever begin
			cmdfifo.get(c_msg);
			rsfifo.get(rs_msg);
			for(int i=16;i<28;i++) begin
				if(c_msg.data[i][7:6]==10 || c_msg.data[i][7:6]==11) begin 
	//MCCCn[7:0]->MCCCn[MCOM],control output mode(00->half H-bridge PWM on pin MnCxM,01->half H-bridge PWM on pin MnCxP,10->Full H-bridge,11->dual full H-bridge)
					case({c_msg.data[2][7],rs_msg.cdc[i-16][15]})  //MCCTL1[7]->MCCTL1[RECIRC],MCDC[i][15]->MCDCx[SIGN[4]]
						00: begin 
							ac_msg.mnm_ac_m[i]=low_ac;
							ac_msg.mnp_ac_m[i]=high; 
							case(c_msg.data[i][5:4])
								00: a_msg.mnm_a_m[i]=none; //channel disable
								01: a_msg.mnm_a_m[i]=Left;	//channel left aligned
								10: a_msg.mnm_a_m[i]=Right;	//channel right aligned
								11: a_msg.mnm_a_m[i]=Center;	//channel center aligned
							endcase
						end
						01: begin 
							ac_msg.mnm_ac_m[i]=high; 
							ac_msg.mnp_ac_m[i]=low_ac;  
							case(c_msg.data[i][5:4])
								00: a_msg.mnp_a_m[i]=none; //channel disable
								01: a_msg.mnp_a_m[i]=Left;	//channel left aligned
								10: a_msg.mnp_a_m[i]=Right;	//channel right aligned
								11: a_msg.mnp_a_m[i]=Center;	//channel center aligned
							endcase
						end
						10: begin 
							ac_msg.mnm_ac_m[i]=low; 
							ac_msg.mnp_ac_m[i]=high_ac;   
							case(c_msg.data[i][5:4])
								00: a_msg.mnp_a_m[i]=none; //channel disable
								01: a_msg.mnp_a_m[i]=Left;	//channel left aligned
								10: a_msg.mnp_a_m[i]=Right;	//channel right aligned
								11: a_msg.mnp_a_m[i]=Center;	//channel center aligned
							endcase
						end
						11: begin 
							ac_msg.mnm_ac_m[i]=high_ac; 
							ac_msg.mnp_ac_m[i]=low;   
							case(c_msg.data[i][5:4])
								00: a_msg.mnm_a_m[i]=none; //channel disable
								01: a_msg.mnm_a_m[i]=Left;	//channel left aligned
								10: a_msg.mnm_a_m[i]=Right;	//channel right aligned
								11: a_msg.mnm_a_m[i]=Center;	//channel center aligned
							endcase
						end
					endcase

					else if(MCCC[i][7:6]==00) begin
						ac_msg.mnm_ac_m[i]=low_ac;  
						case(c_msg.data[i][5:4])
							00: a_msg.mnm_a_m[i]=none; //channel disable
							01: a_msg.mnm_a_m[i]=Left;	//channel left aligned
							10: a_msg.mnm_a_m[i]=Right;	//channel right aligned
							11: a_msg.mnm_a_m[i]=Center;	//channel center aligned
						endcase
					end
					else begin
						ac_msg.mnp_ac_m[i]=low_ac;  
						case(c_msg.data[i][5:4])
							00: a_msg.mnp_a_m[i]=none; //channel disable
							01: a_msg.mnp_a_m[i]=Left;	//channel left aligned
							10: a_msg.mnp_a_m[i]=Right;	//channel right aligned
							11: a_msg.mnp_a_m[i]=Center;	//channel center aligned
						endcase
					end
				end
			end
			active_port.write(ac_msg);
			align_port.write(a_msg);
		end	
	endtask : run_phase

endclass : smc_command_split


/*
case(c_msg.r[i]) 
				mccc0: begin 
					case(c_msg.data[5:4])
						00: a_msg.mnm[0]=none; //channel disable
						01: a_msg.mnm[0]=Left;	//channel left aligned
						10: a_msg.mnm[0]=Right;	//channel right aligned
						11: a_msg.mnm[0]=Center;	//channel center aligned
					endcase
				end
				mccc1: begin 
					case(c_msg.data[5:4])
						00: a_msg.mnm[1]=none; //channel disable
						01: a_msg.mnm[1]=Left;	//channel left aligned
						10: a_msg.mnm[1]=Right;	//channel right aligned
						11: a_msg.mnm[1]=Center;	//channel center aligned
					endcase
				end
				mccc2: begin 
					case(c_msg.data[5:4])
						00: a_msg.mnm[2]=none; //channel disable
						01: a_msg.mnm[2]=Left;	//channel left aligned
						10: a_msg.mnm[2]=Right;	//channel right aligned
						11: a_msg.mnm[2]=Center;	//channel center aligned
					endcase
				end
				mccc3: begin 
					case(c_msg.data[5:4])
						00: a_msg.mnm[3]=none; //channel disable
						01: a_msg.mnm[3]=Left;	//channel left aligned
						10: a_msg.mnm[3]=Right;	//channel right aligned
						11: a_msg.mnm[3]=Center;	//channel center aligned
					endcase
				end
				mccc4: begin 
					case(c_msg.data[5:4])
						00: a_msg.mnm[4]=none; //channel disable
						01: a_msg.mnm[4]=Left;	//channel left aligned
						10: a_msg.mnm[4]=Right;	//channel right aligned
						11: a_msg.mnm[4]=Center;	//channel center aligned
					endcase
				end
				mccc5: begin 
					case(c_msg.data[5:4])
						00: a_msg.mnm[5]=none; //channel disable
						01: a_msg.mnm[5]=Left;	//channel left aligned
						10: a_msg.mnm[5]=Right;	//channel right aligned
						11: a_msg.mnm[5]=Center;	//channel center aligned
					endcase
				end
				mccc6: begin 
					case(c_msg.data[5:4])
						00: a_msg.mnm[6]=none; //channel disable
						01: a_msg.mnm[6]=Left;	//channel left aligned
						10: a_msg.mnm[6]=Right;	//channel right aligned
						11: a_msg.mnm[6]=Center;	//channel center aligned
					endcase
				end
				mccc7: begin 
					case(c_msg.data[5:4])
						00: a_msg.mnm[7]=none; //channel disable
						01: a_msg.mnm[7]=Left;	//channel left aligned
						10: a_msg.mnm[7]=Right;	//channel right aligned
						11: a_msg.mnm[7]=Center;	//channel center aligned
					endcase
				end
				mccc8: begin 
					case(c_msg.data[5:4])
						00: a_msg.mnm[8]=none; //channel disable
						01: a_msg.mnm[8]=Left;	//channel left aligned
						10: a_msg.mnm[8]=Right;	//channel right aligned
						11: a_msg.mnm[8]=Center;	//channel center aligned
					endcase
				end
				mccc9: begin 
					case(c_msg.data[5:4])
						00: a_msg.mnm[9]=none; //channel disable
						01: a_msg.mnm[9]=Left;	//channel left aligned
						10: a_msg.mnm[9]=Right;	//channel right aligned
						11: a_msg.mnm[9]=Center;	//channel center aligned
					endcase
				end
				mccc10: begin 
					case(c_msg.data[5:4])
						00: a_msg.mnm[10]=none; //channel disable
						01: a_msg.mnm[10]=Left;	//channel left aligned
						10: a_msg.mnm[10]=Right;	//channel right aligned
						11: a_msg.mnm[10]=Center;	//channel center aligned
					endcase
				end
				mccc11: begin 
					case(c_msg.data[5:4])
						00: a_msg.mnm[11]=none; //channel disable
						01: a_msg.mnm[11]=Left;	//channel left aligned
						10: a_msg.mnm[11]=Right;	//channel right aligned
						11: a_msg.mnm[11]=Center;	//channel center aligned
					endcase
				end
			endcase
*/
