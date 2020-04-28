///////////////////////////////////////////////////////////////////////////////////

//VERSION 1.0.0
//FUNCTIONS:CALCULATE THE DUTY VIA OUTPUTS AND CMD
//BY RANYANG

////////////////////////////////////////////////////////////////////////////////////

class smc_duty extends uvm_scoreboard;

	`uvm_component_utils(smc_period)
	uvm_tlm_analysis_fifo #(rf_msg) rffifo;
	uvm_tlm_analysis_fifo #(command_msg) cmdfifo;
	uvm_analysis_port #(period_counter_msg) duty_port;

	rf_msg r_msg;
	duty_msg d_msg;
	command_msg cmd_msg;  //need command msg to determine align mode and high/low active
	realtime old_timestamp_mnm,old_timestamp_mnp;
	reg [7:0] mnm_count,mnp_count;
	reg [7:0] mnm_duty;
	reg [7:0] mnp_duty;
	rf_msg [11:0] old_rf_mnm,old_rf_mnp;

	function new(string name="smc_duty", uvm_component par=null);
		super.new(name, par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		rffifo = new("rffifo", this);
		old_r_msg = new(Stay);
		cmd_msg=new(); //need revise,
		d_msg=new(); //need revise
		mnm_count=0;
		mnp_count=0;
		old_rf_mnm=stay;
		old_rf_mnp=stay;
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		old_timestamp=$realtime
		forever begin
			rffifo.get(r_msg);
			cmdfifo.get(cmd_msg);
			if(cmd_msg.align!=center) begin
				for (int i=0; i<12; i+=1) begin
					if(cmd_msg.low_active==1) begin
						if (r_msg.rf_mnm[i] == raise && old_rf_mnm[i]==fall) begin
							d_msg.mnm_duty[i]=mnm_count;
							mnm_count=0;
							old_timestamp_mnm=r_msg.timestamp;
							old_rf_mnm[i]=r_msg.rf_mnm[i];
						end
						else begin
							mnm_count=mnm_count+1;
							if(r_msg.rf_mnm[i] == fall)
								old_rf_mnm[i]=r_msg.rf_mnm[i];
						end

						if (r_msg.rf_mnp[i] == raise && old_rf_mnp[i]==fall) begin
							d_msg.mnp_duty[i]=mnm_count;
							mnp_count=0;
							old_timestamp_mnp=r_msg.timestamp;
							old_rf_mnp[i]=r_msg.rf_mnp[i];
						end
						else begin
							mnp_count=mnp_count+1;
							if(r_msg.rf_mnp[i] == fall)
								old_rf_mnp[i]=r_msg.rf_mnp[i];
						end
					end
					else begin
						if (r_msg.rf_mnm[i] == fall && old_rf_mnm[i]==raise) begin
							d_msg.mnm_duty[i]=mnp_count;
							mnm_count=0;
							old_timestamp_mnm=r_msg.timestamp;
							old_rf_mnm[i]=r_msg.rf_mnm[i];
						end
						else begin
							mnm_count=mnm_count+1;
							if(r_msg.rf_mnm[i] == raise)
								old_rf_mnm[i]=r_msg.rf_mnm[i];
						end

						if (r_msg.rf_mnp[i] == fall && old_rf_mnp[i]==raise) begin
							d_msg.mnp_duty[i]=mnp_count;
							mnp_count=0;
							old_timestamp_mnp=r_msg.timestamp;
							old_rf_mnp[i]=r_msg.rf_mnp[i];
						end
						else begin
							mnp_count=mnp_count+1;
							if(r_msg.rf_mnp[i] == raise)
								old_rf_mnp[i]=r_msg.rf_mnp[i];
						end
					end
				end
			end
			else begin
				for (int i=0; i<12; i+=1) begin
					if(cmd_msg.low_active==1) begin
						if (r_msg.rf_mnm[i] == raise && old_rf_mnm[i]==fall) begin
							d_msg.mnm_duty[i]=mnm_count/2;
							mnm_count=0;
							old_timestamp_mnm=r_msg.timestamp;
							old_rf_mnm[i]=r_msg.rf_mnm[i];
						end
						else begin
							mnm_count=mnm_count+1;
							if(r_msg.rf_mnm[i] == fall)
								old_rf_mnm[i]=r_msg.rf_mnm[i];
						end

						if (r_msg.rf_mnp[i] == raise && old_rf_mnp[i]==fall) begin
							d_msg.mnp_duty[i]=mnp_count/2;
							mnp_count=0;
							old_timestamp_mnp=r_msg.timestamp;
							old_rf_mnp[i]=r_msg.rf_mnp[i];
						end
						else begin
							mnp_count=mnp_count+1;
							if(r_msg.rf_mnp[i] == fall)
								old_rf_mnp[i]=r_msg.rf_mnp[i];
						end
					end
					else begin
						if (r_msg.rf_mnm[i] == fall && old_rf_mnm[i]==raise) begin
							d_msg.mnm_duty[i]=mnm_count/2;
							mnm_count=0;
							old_timestamp_mnm=r_msg.timestamp;
							old_rf_mnm[i]=r_msg.rf_mnm[i];
						end
						else begin
							mnm_count=mnm_count+1;
							if(r_msg.rf_mnm[i] == raise)
								old_rf_mnm[i]=r_msg.rf_mnm[i];
						end

						if (r_msg.rf_mnp[i] == fall && old_rf_mnp[i]==raise) begin
							d_msg.mnp_duty[i]=mnp_count/2;
							mnp_count=0;
							old_timestamp_mnp=r_msg.timestamp;
							old_rf_mnp[i]=r_msg.rf_mnp[i];
						end
						else begin
							mnp_count=mnp_count+1;
							if(r_msg.rf_mnp[i] == raise)
								old_rf_mnp[i]=r_msg.rf_mnp[i];
						end
					end
				end
			end
		end
		pc_port.write(d_msg);
	endtask : run_phase

endclass : smc_duty
