///////////////////////////////////////////////////////////////////////////////////

//VERSION 1.0.0
//FUNCTIONS:COMPARE THE PERIOD AND DUTY VIA OUTPUTS AND CMD
//BY RANYANG

////////////////////////////////////////////////////////////////////////////////////

class smc_comparation extends uvm_scoreboard;

	`uvm_component_utils(smc_period)
	uvm_tlm_analysis_fifo #(duty_msg) dt_fifo;
	uvm_tlm_analysis_fifo #(period_msg) prd_fifo;
	uvm_tlm_analysis_fifo #(command_msg) cmd_fifo;

	period_msg prd_msg;
	duty_msg dt_msg;
	command_msg cmd_msg; 

	function new(string name="smc_duty", uvm_component par=null);
		super.new(name, par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		dt_fifo = new("dt_fifo", this);
		prd_fifo = new("prd_fifo", this);
		cmd_fifo = new("cmd_fifo", this);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		forever begin
			dt_fifo.get(dt_msg);
			prd_fifo.get(prd_msg);
			cmd_fifo.get(cmd_msg);
			for(i=0;i<12;i++) begin
				if(dt_msg.mnm_duty[i]!=cmd_msg.MCCDC[i][10:1]) begin
					if(cmd_msg.mnm_status==active)
						`uvm_error() //
				end
				else if(dt_msg.mnm_duty[i]!=cmd_msg.MCCDC[i][10:1]) begin
					if(cmd_msg.mnp_status==active)
						`uvm_error() //
				end
				if(dt_msg.mnm_duty[i]!=cmd_msg.MCPER[10:0]) begin
					if(cmd_msg.mnm_status==active)
						`uvm_error() //
				end
				else if(dt_msg.mnm_duty[i]!=cmd_msg.MCPER[10:0]) begin
					if(cmd_msg.mnp_status==active)
						`uvm_error() //
				end
			end
		end
	endtask : run_phase

endclass : smc_comparation
