///////////////////////////////////////////////////////////////////////////////////

//VERSION 1.0.0
//FUNCTIONS:COMPARE THE PERIOD AND DUTY VIA OUTPUTS AND CMD
//BY RANYANG

////////////////////////////////////////////////////////////////////////////////////

class smc_comparation extends uvm_scoreboard;

	`uvm_component_utils(smc_period)
	uvm_tlm_analysis_fifo #(duty_msg) dt_fifo;
	uvm_tlm_analysis_fifo #(period_msg) prd_fifo;
	uvm_tlm_analysis_fifo #(exp_pulse_msg) epfifo;

	period_msg prd_msg;
	duty_msg dt_msg;
	exp_pulse_msg ep_msg; 

	function new(string name="smc_duty", uvm_component par=null);
		super.new(name, par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		dt_fifo = new("dt_fifo", this);
		prd_fifo = new("prd_fifo", this);
		epfifo = new("epfifo", this);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		forever begin
			dt_fifo.get(dt_msg);
			prd_fifo.get(prd_msg);
			epfifo.get(ep_msg);
			if(ep_msg.p<12) begin
				if(dt_msg.mnm_duty[ep_msg.p]!=ep_msg.duty) begin
					//if(ep_msg.mo==half_b_m ||{ep_msg[ep_msg.p].recirc, ep_msg[ep_msg.p].sign}==00 ||{ep_msg[ep_msg.p].recirc, ep_msg[ep_msg.p].sign}==11)
						uvm_report_error("MYERR", "This is an error");//
				end
				else if(prd_msg.mnm_per[ep_msg.p]!=ep_msg.period) begin
					//if(ep_msg.mo==half_b_p ||{ep_msg[ep_msg.p].recirc, ep_msg[ep_msg.p].sign}==01 ||{ep_msg[ep_msg.p].recirc, ep_msg[ep_msg.p].sign}==10)
						uvm_report_error("MYERR", "This is an error"); //
				end
			end
			if(ep_msg.p>12) begin
				if(dt_msg.mnp_duty[ep_msg.p-12]!=ep_msg.duty) begin
					//if(ep_msg.mo==half_b_m ||{ep_msg[ep_msg.p].recirc, ep_msg[ep_msg.p].sign}==00 ||{ep_msg[ep_msg.p].recirc, ep_msg[ep_msg.p].sign}==11)
						uvm_report_error("MYERR", "This is an error"); //
				end
				else if(prd_msg.mnp_per[ep_msg.p-12]!=ep_msg.period) begin
					//if(ep_msg.mo==half_b_p ||{ep_msg[ep_msg.p].recirc, ep_msg[ep_msg.p].sign}==01 ||{ep_msg[ep_msg.p].recirc, ep_msg[ep_msg.p].sign}==10)
						uvm_report_error("MYERR", "This is an error"); //
				end
			end
		end
	endtask : run_phase

endclass : smc_comparation
