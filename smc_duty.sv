///////////////////////////////////////////////////////////////////////////////////

//VERSION 1.0.3
//FUNCTIONS:CALCULATE THE DUTY VIA OUTPUTS AND CMD
//BY RANYANG

////////////////////////////////////////////////////////////////////////////////////

class smc_duty extends uvm_scoreboard;

	`uvm_component_utils(smc_duty)
	uvm_tlm_analysis_fifo #(rf_msg) rffifo;
	//uvm_tlm_analysis_fifo #(active_msg) acfifo;
	uvm_tlm_analysis_fifo #(exp_pulse_msg) epfifo;
	uvm_analysis_port #(duty_msg) duty_port;

	rf_msg r_msg;
	//active_msg aed_msg;
	exp_pulse_msg ed_msg;
	duty_msg d_msg;
	int pp;

	rf_msg old_rf_mnm[11:0];
	rf_msg old_rf_mnp[11:0];

	function new(string name="smc_duty", uvm_component par=null);
		super.new(name, par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		rffifo = new("rffifo", this);
		//acfifo = new("acfifo", this);
		epfifo = new("epfifo", this);
		duty_port = new("duty_port",this);
		d_msg=new(); //need revise
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		forever begin
			case (ed_msg.mo)
			half_b_m: begin
				if(ed_msg.ma!=disabled && ed_msg.ma!=center) begin
					if (r_msg.rf_mnm[ed_msg.p] == Rising) begin
						if(old_rf_mnm[ed_msg.p]==Falling) begin
							d_msg.mnm_count[ed_msg.p] += 1;
							d_msg.mnm_duty[ed_msg.p] = d_msg.mnm_count[ed_msg.p];
							d_msg.mnm_count[ed_msg.p] = 0;
							old_rf_mnm[ed_msg.p]=r_msg.rf_mnm[ed_msg.p];
							duty_port.write(d_msg);
						end
					end
					else if (r_msg.rf_mnm[ed_msg.p] == Falling) begin
						if(old_rf_mnm[ed_msg.p]==Rising) begin
							d_msg.mnm_count[ed_msg.p] = 0;
							old_rf_mnm[ed_msg.p]=r_msg.rf_mnm[ed_msg.p];
						end
					end
					else
						d_msg.mnm_count[ed_msg.p] += 1;
					end
				else if(ed_msg.ma==center) begin
					if (r_msg.rf_mnm[ed_msg.p] == Rising) begin
						if(old_rf_mnm[ed_msg.p]==Falling) begin
							d_msg.mnm_count[ed_msg.p] += 1;
							d_msg.mnm_duty[ed_msg.p] = d_msg.mnm_count[ed_msg.p]/2;
							d_msg.mnm_count[ed_msg.p] = 0;
							old_rf_mnm[ed_msg.p]=r_msg.rf_mnm[ed_msg.p];
							duty_port.write(d_msg);
							
						end
					end
					else if (r_msg.rf_mnm[ed_msg.p] == Falling) begin
						if(old_rf_mnm[ed_msg.p]==Rising) begin
							d_msg.mnm_count[ed_msg.p] = 0;
							old_rf_mnm[ed_msg.p]=r_msg.rf_mnm[ed_msg.p];
						end
					end
					else
						d_msg.mnm_count[ed_msg.p] += 1;
				end
				else
					d_msg.mnm_count[ed_msg.p] = 0;
			end
			half_b_p: begin
				if(ed_msg.ma!=disabled && ed_msg.ma!=center) begin
					if (r_msg.rf_mnp[ed_msg.p] == Rising) begin
						if(old_rf_mnp[ed_msg.p]==Falling) begin
							d_msg.mnp_count[ed_msg.p] += 1;
							d_msg.mnp_duty[ed_msg.p] = d_msg.mnp_count[ed_msg.p];
							d_msg.mnp_count[ed_msg.p] = 0;
							old_rf_mnp[ed_msg.p]=r_msg.rf_mnp[ed_msg.p];
							duty_port.write(d_msg);
						end
					end
					else if (r_msg.rf_mnp[ed_msg.p] == Falling) begin
						if(old_rf_mnp[ed_msg.p]==Rising) begin
							d_msg.mnp_count[ed_msg.p] = 0;
							old_rf_mnp[ed_msg.p]=r_msg.rf_mnp[ed_msg.p];
						end
					end
					else
						d_msg.mnp_count[ed_msg.p] += 1;
					end
				else if(ed_msg.ma==center) begin
					if (r_msg.rf_mnp[ed_msg.p] == Rising) begin
						if(old_rf_mnp[ed_msg.p]==Falling) begin
							d_msg.mnp_count[ed_msg.p] += 1;
							d_msg.mnp_duty[ed_msg.p] = d_msg.mnm_count[ed_msg.p]/2;
							d_msg.mnp_count[ed_msg.p] = 0;
							old_rf_mnp[ed_msg.p]=r_msg.rf_mnp[ed_msg.p];
							duty_port.write(d_msg);
							
						end
					end
					else if (r_msg.rf_mnp[ed_msg.p] == Falling) begin
						if(old_rf_mnp[ed_msg.p]==Rising) begin
							d_msg.mnp_count[ed_msg.p] = 0;
							old_rf_mnp[ed_msg.p]=r_msg.rf_mnp[ed_msg.p];
						end
					end
					else
						d_msg.mnp_count[ed_msg.p] += 1;
				end
				else
					d_msg.mnp_count[ed_msg.p] = 0;
			end			
			default: begin
				//`uvm_info("CV", $sformatf("%b", {ct_msg[j].recirc, ct_msg[j].sign}), UVM_LOW)
				case ({ed_msg.recirc, ed_msg.sign})
					00: begin
						if(ed_msg.ma!=disabled && ed_msg.ma!=center) begin
							if (r_msg.rf_mnm[ed_msg.p] == Falling) begin
								if(old_rf_mnm[ed_msg.p]==Rising) begin
									d_msg.mnm_count[ed_msg.p] += 1;
									d_msg.mnm_duty[ed_msg.p] = d_msg.mnm_count[ed_msg.p];
									d_msg.mnm_count[ed_msg.p] = 0;
									old_rf_mnm[ed_msg.p]=r_msg.rf_mnm[ed_msg.p];
									duty_port.write(d_msg);
								end
							end
							else if (r_msg.rf_mnm[ed_msg.p] == Rising) begin
								if(old_rf_mnm[ed_msg.p]==Falling) begin
									d_msg.mnm_count[ed_msg.p] = 0;
									old_rf_mnm[ed_msg.p]=r_msg.rf_mnm[ed_msg.p];
								end
							end
							else
								d_msg.mnm_count[ed_msg.p] += 1;
						end
						else if(ed_msg.ma==center) begin
							if (r_msg.rf_mnm[ed_msg.p] == Falling) begin
								if(old_rf_mnm[ed_msg.p]==Rising) begin
									d_msg.mnm_count[ed_msg.p] += 1;
									d_msg.mnm_duty[ed_msg.p] = d_msg.mnm_count[ed_msg.p]/2;
									d_msg.mnm_count[ed_msg.p] = 0;
									old_rf_mnm[ed_msg.p]=r_msg.rf_mnm[ed_msg.p];
									duty_port.write(d_msg);
								end
							end
							else if (r_msg.rf_mnm[ed_msg.p] == Rising) begin
								if(old_rf_mnm[ed_msg.p]==Falling) begin
									d_msg.mnm_count[ed_msg.p] = 0;
									old_rf_mnm[ed_msg.p]=r_msg.rf_mnm[ed_msg.p];
								end
							end
							else
								d_msg.mnm_count[ed_msg.p] += 1;
						end
						else
							d_msg.mnm_count[ed_msg.p] = 0;
					end
					01: begin
						if(ed_msg.ma!=disabled && ed_msg.ma!=center) begin
							if (r_msg.rf_mnp[ed_msg.p] == Falling) begin
								if(old_rf_mnp[ed_msg.p]==Rising) begin
									d_msg.mnp_count[ed_msg.p] += 1;
									d_msg.mnp_duty[ed_msg.p] = d_msg.mnp_count[ed_msg.p];
									d_msg.mnp_count[ed_msg.p] = 0;
									old_rf_mnp[ed_msg.p]=r_msg.rf_mnp[ed_msg.p];
									duty_port.write(d_msg);
								end
							end
							else if (r_msg.rf_mnp[ed_msg.p] == Rising) begin
								if(old_rf_mnp[ed_msg.p]==Falling) begin
									d_msg.mnp_count[ed_msg.p] = 0;
									old_rf_mnp[ed_msg.p]=r_msg.rf_mnp[ed_msg.p];
								end
							end
							else
								d_msg.mnp_count[ed_msg.p] += 1;
						end
						else if(ed_msg.ma==center) begin
							if (r_msg.rf_mnp[ed_msg.p] == Falling) begin
								if(old_rf_mnp[ed_msg.p]==Rising) begin
									d_msg.mnp_count[ed_msg.p] += 1;
									d_msg.mnp_duty[ed_msg.p] = d_msg.mnm_count[ed_msg.p]/2;
									d_msg.mnp_count[ed_msg.p] = 0;
									old_rf_mnp[ed_msg.p]=r_msg.rf_mnp[ed_msg.p];
									duty_port.write(d_msg);
								end
							end
							else if (r_msg.rf_mnp[ed_msg.p] == Rising) begin
								if(old_rf_mnp[ed_msg.p]==Falling) begin
									d_msg.mnp_count[ed_msg.p] = 0;
									old_rf_mnp[ed_msg.p]=r_msg.rf_mnp[ed_msg.p];
								end
							end
							else
								d_msg.mnp_count[ed_msg.p] += 1;
						end
						else
							d_msg.mnp_count[ed_msg.p] = 0;
					end
					10: begin
						if(ed_msg.ma!=disabled && ed_msg.ma!=center) begin
							if (r_msg.rf_mnp[ed_msg.p] == Rising) begin
								if(old_rf_mnp[ed_msg.p]==Falling) begin
									d_msg.mnp_count[ed_msg.p] += 1;
									d_msg.mnp_duty[ed_msg.p] = d_msg.mnp_count[ed_msg.p];
									d_msg.mnp_count[ed_msg.p] = 0;
									old_rf_mnp[ed_msg.p]=r_msg.rf_mnp[ed_msg.p];
									duty_port.write(d_msg);
								end
							end
							else if (r_msg.rf_mnp[ed_msg.p] == Falling) begin
								if(old_rf_mnp[ed_msg.p]==Rising) begin
									d_msg.mnp_count[ed_msg.p] = 0;
									old_rf_mnp[ed_msg.p]=r_msg.rf_mnp[ed_msg.p];
								end
							end
							else
								d_msg.mnp_count[ed_msg.p] += 1;
							end
						else if(ed_msg.ma==center) begin
							if (r_msg.rf_mnp[ed_msg.p] == Rising) begin
								if(old_rf_mnp[ed_msg.p]==Falling) begin
									d_msg.mnp_count[ed_msg.p] += 1;
									d_msg.mnp_duty[ed_msg.p] = d_msg.mnm_count[ed_msg.p]/2;
									d_msg.mnp_count[ed_msg.p] = 0;
									old_rf_mnp[ed_msg.p]=r_msg.rf_mnp[ed_msg.p];
									duty_port.write(d_msg);
									
								end
							end
							else if (r_msg.rf_mnp[ed_msg.p] == Falling) begin
								if(old_rf_mnp[ed_msg.p]==Rising) begin
									d_msg.mnp_count[ed_msg.p] = 0;
									old_rf_mnp[ed_msg.p]=r_msg.rf_mnp[ed_msg.p];
								end
							end
							else
								d_msg.mnp_count[ed_msg.p] += 1;
						end
						else
							d_msg.mnp_count[ed_msg.p] = 0;
					end
					11: begin
						if(ed_msg.ma!=disabled && ed_msg.ma!=center) begin
							if (r_msg.rf_mnm[ed_msg.p] == Falling) begin
								if(old_rf_mnm[ed_msg.p]==Rising) begin
									d_msg.mnm_count[ed_msg.p] += 1;
									d_msg.mnm_duty[ed_msg.p] = d_msg.mnm_count[ed_msg.p];
									d_msg.mnm_count[ed_msg.p] = 0;
									old_rf_mnm[ed_msg.p]=r_msg.rf_mnm[ed_msg.p];
									duty_port.write(d_msg);
								end
							end
							else if (r_msg.rf_mnm[ed_msg.p] == Rising) begin
								if(old_rf_mnm[ed_msg.p]==Falling) begin
									d_msg.mnm_count[ed_msg.p] = 0;
									old_rf_mnm[ed_msg.p]=r_msg.rf_mnm[ed_msg.p];
								end
							end
							else
								d_msg.mnm_count[ed_msg.p] += 1;
						end
						else if(ed_msg.ma==center) begin
							if (r_msg.rf_mnm[ed_msg.p] == Falling) begin
								if(old_rf_mnm[ed_msg.p]==Rising) begin
									d_msg.mnm_count[ed_msg.p] += 1;
									d_msg.mnm_duty[ed_msg.p] = d_msg.mnm_count[ed_msg.p]/2;
									d_msg.mnm_count[ed_msg.p] = 0;
									old_rf_mnm[ed_msg.p]=r_msg.rf_mnm[ed_msg.p];
									duty_port.write(d_msg);
								end
							end
							else if (r_msg.rf_mnm[ed_msg.p] == Rising) begin
								if(old_rf_mnm[ed_msg.p]==Falling) begin
									d_msg.mnm_count[ed_msg.p] = 0;
									old_rf_mnm[ed_msg.p]=r_msg.rf_mnm[ed_msg.p];
								end
							end
							else
								d_msg.mnm_count[ed_msg.p] += 1;
						end
						else
							d_msg.mnm_count[ed_msg.p] = 0;
					end
					default: begin
					end
				endcase
			end
		endcase			
		end
	endtask : run_phase

endclass : smc_duty
