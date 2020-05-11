// Ovserving period
class smc_period extends uvm_scoreboard;

	`uvm_component_utils(smc_period)
	uvm_tlm_analysis_fifo #(rf_msg) rffifo;
	uvm_tlm_analysis_fifo #(exp_pulse_msg) epfifo;
	uvm_analysis_port #(period_msg) p_port;

	period_msg p_msg;
	rf_msg r_msg;
	exp_pulse_msg ep_msg;

	function new(string name="smc_period", uvm_component par=null);
		super.new(name, par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		rffifo = new("rffifo", this);
		epfifo = new("epfifo", this);
		p_port = new("p_port", this);
		p_msg = new();
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		forever begin
			rffifo.get(r_msg);
			epfifo.get(ep_msg);
			if(ep_msg.p<12) begin
				if(ep_msg.ma!=disabled && ep_msg.ma!=center) begin
					if (r_msg.rf_mnm[ep_msg.p] == Rising) begin
						p_msg.mnm_count[ep_msg.p] += 1;
						p_msg.mnm_per[ep_msg.p] = p_msg.mnm_count[ep_msg.p];
						p_msg.mnm_count[ep_msg.p] = 0;
					end
					else if (r_msg.rf_mnm[ep_msg.p] == x_z) begin
						p_msg.mnm_count[ep_msg.p] = 0;
						//`uvm_info("PERIOD", "x or z shows up.", UVM_LOW)
					end
					else
						p_msg.mnm_count[ep_msg.p] += 1;
				end
				else if(ep_msg.ma==center) begin
					if (r_msg.rf_mnm[ep_msg.p] == Rising) begin
						p_msg.mnm_count[ep_msg.p] += 1;
						p_msg.mnm_per[ep_msg.p] = p_msg.mnm_count[ep_msg.p]/2;
						p_msg.mnm_count[ep_msg.p] = 0;
					end
					else if (r_msg.rf_mnm[ep_msg.p] == x_z) begin
						p_msg.mnm_count[ep_msg.p] = 0;
						//`uvm_info("PERIOD", "x or z shows up.", UVM_LOW)
					end
					else
						p_msg.mnm_count[ep_msg.p] += 1;
				end
				else
					p_msg.mnm_count[ep_msg.p] = 0;
			end
			else if(ep_msg.p>11 && ep_msg.p<24) begin
				if(ep_msg.ma!=disabled && ep_msg.ma!=center) begin
					if (r_msg.rf_mnp[ep_msg.p] == Rising) begin
						p_msg.mnp_count[ep_msg.p] += 1;
						p_msg.mnp_per[ep_msg.p] = p_msg.mnp_count[ep_msg.p];
						p_msg.mnp_count[ep_msg.p] = 0;
					end
					else if (r_msg.rf_mnp[ep_msg.p] == x_z) begin
						p_msg.mnp_count[ep_msg.p] = 0;
						//`uvm_info("PERIOD", "x or z shows up.", UVM_LOW)
					end
					else
						p_msg.mnp_count[ep_msg.p] += 1;
				end
				else if(ep_msg.ma==center) begin
					if (r_msg.rf_mnp[ep_msg.p] == Rising) begin
						p_msg.mnp_count[ep_msg.p] += 1;
						p_msg.mnp_per[ep_msg.p] = p_msg.mnp_count[ep_msg.p]/2;
						p_msg.mnp_count[ep_msg.p] = 0;
					end
					else if (r_msg.rf_mnp[ep_msg.p] == x_z) begin
						p_msg.mnp_count[ep_msg.p] = 0;
						//`uvm_info("PERIOD", "x or z shows up.", UVM_LOW)
					end
					else
						p_msg.mnp_count[ep_msg.p] += 1;
				end
				else
					p_msg.mnp_count[ep_msg.p] = 0;

			end
			p_msg.timestamp = $realtime;
			p_port.write(p_msg);
		end
	endtask : run_phase
endclass : smc_period
