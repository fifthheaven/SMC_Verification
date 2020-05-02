///////////////////////////////////////////////////////////////////////////////////

//VERSION 1.0.0
//FUNCTIONS:CALCULATE THE PERIOD VIA OUTPUTS AND CMD
//BY RANYANG

////////////////////////////////////////////////////////////////////////////////////

class smc_period extends uvm_scoreboard;

	`uvm_component_utils(smc_period)
	uvm_tlm_analysis_fifo #(rf_msg) rffifo;
	uvm_tlm_analysis_fifo #(align_msg) alignfifo;
	uvm_analysis_port #(period_msg) prdport;

	period_msg p_msg;
	rf_msg r_msg;
	align_msg a_msg;  //need command msg to determine align mode and high/low active

	function new(string name="smc_period", uvm_component par=null);
		super.new(name, par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		rffifo = new("rffifo", this);
		alignfifo = new("alignfifo", this);
		prdport = new("prdport",this);
		p_msg=new();
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		forever begin
			rffifo.get(r_msg);
			alignfifo.get(a_msg);
			for(int i=0;i<12;i+=1) begin
				if(a_msg.mnm_a_m[i]!=none && a_msg.mnm_a_m[i]!=center) begin
					if (r_msg.rf_mnm[i] == Rising) begin
						p_msg.mnm_count[i] += 1;
						p_msg.mnm_per[i] = p_msg.mnm_count[i];
						p_msg.mnm_count[i] = 0;
					end
					else if (r_msg.rf_mnm[i] == x_z) begin
						p_msg.mnm_count[i] = 0;
						//`uvm_info("PERIOD", "x or z shows up.", UVM_LOW)
					end
					else
						p_msg.mnm_count[i] += 1;
				end
				else if(a_msg.mnm_a_m[i]==center) begin
					if (r_msg.rf_mnm[i] == Rising) begin
						p_msg.mnm_count[i] += 1;
						p_msg.mnm_per[i] = p_msg.mnm_count[i]/2;
						p_msg.mnm_count[i] = 0;
					end
					else if (r_msg.rf_mnm[i] == x_z) begin
						p_msg.mnm_count[i] = 0;
						//`uvm_info("PERIOD", "x or z shows up.", UVM_LOW)
					end
					else
						p_msg.mnm_count[i] += 1;
				end
				else
					p_msg.mnm_count[i] = 0;

				if(a_msg.mnp_a_m[i]!=none && a_msg.mnp_a_m[i]!=center) begin
					if (r_msg.rf_mnp[i] == Rising) begin
						p_msg.mnp_count[i] += 1;
						p_msg.mnp_per[i] = p_msg.mnp_count[i];
						p_msg.mnp_count[i] = 0;
					end
					else if (r_msg.rf_mnp[i] == x_z) begin
						p_msg.mnp_count[i] = 0;
						//`uvm_info("PERIOD", "x or z shows up.", UVM_LOW)
					end
					else
						p_msg.mnp_count[i] += 1;
				end
				else if(a_msg.mnp_a_m[i]==center) begin
					if (r_msg.rf_mnp[i] == Rising) begin
						p_msg.mnp_count[i] += 1;
						p_msg.mnp_per[i] = p_msg.mnp_count[i]/2;
						p_msg.mnp_count[i] = 0;
					end
					else if (r_msg.rf_mnp[i] == x_z) begin
						p_msg.mnp_count[i] = 0;
						//`uvm_info("PERIOD", "x or z shows up.", UVM_LOW)
					end
					else
						p_msg.mnp_count[i] += 1;
				end
				else
					p_msg.mnp_count[i] = 0;
			end
		end
		prdport.write(p_msg);
	endtask : run_phase

endclass : smc_period
