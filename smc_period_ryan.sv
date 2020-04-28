///////////////////////////////////////////////////////////////////////////////////

//VERSION 1.0.0
//FUNCTIONS:CALCULATE THE PERIOD VIA OUTPUTS AND CMD
//BY RANYANG

////////////////////////////////////////////////////////////////////////////////////

class smc_period extends uvm_scoreboard;

	`uvm_component_utils(smc_period)
	uvm_tlm_analysis_fifo #(rf_msg) rffifo;
	uvm_tlm_analysis_fifo #(command_msg) cmdfifo;
	uvm_analysis_port #(period_msg) prdport;

	period_msg prd_msg;
	rf_msg r_msg;
	command_msg cmd_msg;  //need command msg to determine align mode and high/low active
	realtime old_timestamp_mnm,old_timestamp_mnp;
	reg [7:0] mnm_count,mnp_count;
	reg [7:0] mnm_period;
	reg [7:0] mnp_period;

	function new(string name="smc_period", uvm_component par=null);
		super.new(name, par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		rffifo = new("rffifo", this);
		old_r_msg = new(Stay);
		prd_msg=new();
		mnm_count=0;
		mnp_count=0;
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		old_timestamp=$realtime
		forever begin
			rffifo.get(r_msg);
			cmdfifo.get(cmd_msg);
			if(cmd_msg.align!=center) begin
				for (int i=0; i<12; i+=1) begin
					if (r_msg.rf_mnm[i] == raise) begin
						prd_msg.mnm_period[i]=mnm_count;
						mnm_count=0;
						old_timestamp_mnm=r_msg.timestamp;
					end
					else begin
						mnm_count=mnm_count+1;
					end

					if (r_msg.rf_mnp[i] == raise) begin
						prd_msg.mnp_period[i]=mnp_count;
						mnp_count=0;
						old_timestamp_mnp=r_msg.timestamp;
					end
					else begin
						mnp_count=mnp_count+1;
					end
				end
			end
			else begin
				for (int i=0; i<12; i+=1) begin
					if (r_msg.rf_mnm[i] == raise) begin
						prd_msg.mnm_period[i]=mnm_count/2;
						mnm_count=0;
						old_timestamp_mnm=r_msg.timestamp;
					end
					else begin
						mnm_count=mnm_count+1;
					end

					if (r_msg.rf_mnp[i] == raise) begin
						prd_msg.mnp_period[i]=mnp_count/2;
						mnp_count=0;
						old_timestamp_mnp=r_msg.timestamp;
					end
					else begin
						mnp_count=mnp_count+1;
					end
				end
			end
		end
	endtask : run_phase

endclass : smc_period
