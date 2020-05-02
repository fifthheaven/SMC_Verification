///////////////////////////////////////////////////////////////////////////////////

//VERSION 1.0.0
//FUNCTIONS:CALCULATE THE DUTY VIA OUTPUTS AND CMD
//BY RANYANG

////////////////////////////////////////////////////////////////////////////////////

class smc_duty extends uvm_scoreboard;

	`uvm_component_utils(smc_duty)
	uvm_tlm_analysis_fifo #(rf_msg) rffifo;
	uvm_tlm_analysis_fifo #(active_msg) acfifo;
	uvm_tlm_analysis_fifo #(align_msg) alignfifo;
	uvm_analysis_port #(duty_msg) duty_port;

	rf_msg r_msg;
	active_msg ac_msg;
	align_msg a_msg;
	duty_msg d_msg;

	rf_msg old_rf_mnm[11:0];
	rf_msg old_rf_mnp[11:0];

	function new(string name="smc_duty", uvm_component par=null);
		super.new(name, par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		rffifo = new("rffifo", this);
		acfifo = new("acfifo", this);
		alignfifo = new("alignfifo", this);
		duty_port = new("duty_port",this);
		d_msg=new(); //need revise
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		forever begin
			rffifo.get(r_msg);
			acfifo.get(ac_msg);
			alignfifo.get(a_msg);
			for(int i=0;i<12;i+=1) begin
				if(ac_msg.mnm_ac_m[i]==high) begin
					if(a_msg.mnm_a_m[i]!=none && a_msg.mnm_a_m[i]!=center) begin
						if (r_msg.rf_mnm[i] == Fall) begin
							if(old_rf_mnm[i]==Rising) begin
								d_msg.mnm_count[i] += 1;
								d_msg.mnm_duty[i] = d_msg.mnm_count[i];
								d_msg.mnm_count[i] = 0;
								old_rf_mnm[i]=r_msg.rf_mnm[i]
							end
						end
						else if (r_msg.rf_mnm[i] == Rising) begin
							if(old_rf_mnm[i]==Fall) begin
								d_msg.mnm_count[i] = 0;
								old_rf_mnm[i]=r_msg.rf_mnm[i]
							end
						end
						else
							p_msg.mnm_count[i] += 1;
					end
					else if(a_msg.mnm_a_m[i]==center) begin
						if (r_msg.rf_mnm[i] == Fall) begin
							if(old_rf_mnm[i]==Rising) begin
								d_msg.mnm_count[i] += 1;
								d_msg.mnm_duty[i] = d_msg.mnm_count[i]/2;
								d_msg.mnm_count[i] = 0;
								old_rf_mnm[i]=r_msg.rf_mnm[i]
							end
						end
						else if (r_msg.rf_mnm[i] == Rising) begin
							if(old_rf_mnm[i]==Fall) begin
								d_msg.mnm_count[i] = 0;
								old_rf_mnm[i]=r_msg.rf_mnm[i]
							end
						end
						else
							p_msg.mnm_count[i] += 1;
					end
					else
						p_msg.mnm_count[i] = 0;
				end

				if(ac_msg.mnp_ac_m[i]==high) begin
					if(a_msg.mnp_a_m[i]!=none && a_msg.mnp_a_m[i]!=center) begin
						if (r_msg.rf_mnp[i] == Fall) begin
							if(old_rf_mnp[i]==Rising) begin
								d_msg.mnp_count[i] += 1;
								d_msg.mnp_duty[i] = d_msg.mnp_count[i];
								d_msg.mnp_count[i] = 0;
								old_rf_mnp[i]=r_msg.rf_mnp[i]
							end
						end
						else if (r_msg.rf_mnp[i] == Rising) begin
							if(old_rf_mnp[i]==Fall) begin
								d_msg.mnp_count[i] = 0;
								old_rf_mnp[i]=r_msg.rf_mnp[i]
							end
						end
						else
							p_msg.mnp_count[i] += 1;
					end
					else if(a_msg.mnp_a_m[i]==center) begin
						if (r_msg.rf_mnp[i] == Fall) begin
							if(old_rf_mnp[i]==Rising) begin
								d_msg.mnp_count[i] += 1;
								d_msg.mnp_duty[i] = d_msg.mnp_count[i]/2;
								d_msg.mnp_count[i] = 0;
								old_rf_mnp[i]=r_msg.rf_mnp[i]
							end
						end
						else if (r_msg.rf_mnp[i] == Rising) begin
							if(old_rf_mnp[i]==Fall) begin
								d_msg.mnp_count[i] = 0;
								old_rf_mnp[i]=r_msg.rf_mnp[i]
							end
						end
						else
							p_msg.mnp_count[i] += 1;
					end
					else
						p_msg.mnp_count[i] = 0;
				end
			end
		end
		duty_port.write(d_msg);
	endtask : run_phase

endclass : smc_duty
