// Collect and Send controlling parameters when the PERIOD starts counting
// (Counter overflow)
`uvm_analysis_imp_decl(_ps)
`uvm_analysis_imp_decl(_cc)
class control_values extends uvm_scoreboard;

	`uvm_component_utils(control_values)
	uvm_tlm_analysis_fifo #(bit) cvififo;
	uvm_analysis_imp_ps #(period_start_msg, control_values) cvpimp;
	uvm_analysis_imp_cc #(control_msg, control_values) cvcimp;
	uvm_analysis_port #(exp_val_msg) cv_off_port;
	uvm_analysis_port #(exp_pulse_msg) cv_l_port;
	uvm_analysis_port #(exp_pulse_msg) cv_h_port;
	uvm_analysis_port #(exp_pulse_msg) cv_pl_port;
	uvm_analysis_port #(exp_pulse_msg) cv_pc_port;
	uvm_analysis_port #(exp_pulse_msg) cv_pr_port;
	uvm_analysis_port #(exp_pulse_msg) cv_dt_port;
	uvm_analysis_port #(exp_pulse_msg) cv_prd_port;
	uvm_analysis_port #(exp_pulse_msg) cv_com_port;

	bit clk;
	control_msg ct_msg[24:0];
	period_start_msg ps_msg;
	exp_val_msg e_msg;
	exp_pulse_msg ep_msg;
	realtime per_start = 0, per_startold = 0;
	realtime per_end = 0;
	int period = 0;
	pin p;
	int low_count = 0; // Counting time for released pins (period = 0)

	function new(string name="control_values", uvm_component par=null);
		super.new(name, par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		cvififo = new("cvififo", this);
		cvpimp = new("cvpimp", this);
		cvcimp = new("cvcimp", this);
		cv_off_port = new("cv_off_port", this);
		cv_l_port = new("cv_l_port", this);
		cv_h_port = new("cv_h_port", this);
		cv_pl_port = new("cv_pl_port", this);
		cv_pc_port = new("cv_pc_port", this);
		cv_pr_port = new("cv_pr_port", this);
		cv_dt_port = new("cv_dt_port", this);
		cv_prd_port = new("cv_prd_port", this);
		cv_com_port = new("cv_com_port", this);
		e_msg = new();
		for (int i=0; i<25; i+=1) begin
			ct_msg[i] = new(zero);
		end
	endfunction : build_phase

	function void write_ps (period_start_msg ps_msg);
		per_start = ps_msg.per_start;
		per_end = ps_msg.per_end;
		period = ps_msg.period;
		//`uvm_info("CV period start", $sformatf("PERIOD%d starts at %0t, ends at %0t", period, per_start, per_end), UVM_LOW)
	endfunction : write_ps

	function void write_cc (control_msg ct);
		int i;
		i = ct.p;
		ct_msg[i] = ct;
		//`uvm_info("CV command", $sformatf("%s r%b mo:%s ma:%s s%b cd%b  %0t", ct_msg[i].p, ct_msg[i].recirc, ct_msg[i].mo, ct_msg[i].ma, ct_msg[i].sign, ct_msg[i].cd, ct_msg[i].timestamp), UVM_LOW)
	endfunction : write_cc

	// Assign pins to corresponding ports based on Alignment mode MCAM
	function void assign_MCAM (int j, exp_pulse_msg ep_msg);
		//`uvm_info("CV", $sformatf("%s MCAM %s  %0t", ep_msg.p, ct_msg[j].ma, ct_msg[j].timestamp), UVM_LOW)
		case (ct_msg[j].ma)
			left:
				cv_pl_port.write(ep_msg);
			center:
				cv_pc_port.write(ep_msg);
			right:
				cv_pr_port.write(ep_msg);
		endcase
	endfunction : assign_MCAM

	// Assign pins to corresponding ports based on Output mode MCOM
	function void assign_MCOM (int j, exp_pulse_msg ep_msg);
		case (ct_msg[j].mo)
			half_b_m: begin
				if (j >= 13) // At PLUS Side
					cv_l_port.write(ep_msg);
				else // At MINUS Side
					assign_MCAM(j, ep_msg);
			end
			half_b_p: begin
				if (j < 13)
					cv_l_port.write(ep_msg);
				else
					assign_MCAM(j, ep_msg);
			end
/*			full_b: begin
			end
			dualfull_b: begin
			end
			// DUAL-FULL & FULL
*/			default: begin
				//`uvm_info("CV", $sformatf("%b", {ct_msg[j].recirc, ct_msg[j].sign}), UVM_LOW)
				case ({ct_msg[j].recirc, ct_msg[j].sign})
					00: begin
						if (j >= 13) // PLUS
							cv_h_port.write(ep_msg);
						else
							assign_MCAM(j, ep_msg);
					end
					01: begin
						if (j < 13) // MINUS
							cv_h_port.write(ep_msg);
						else
							assign_MCAM(j, ep_msg);
					end
					10: begin
						if (j < 13) // MINUS
							cv_l_port.write(ep_msg);
						else
							assign_MCAM(j, ep_msg);
					end
					11: begin
						if (j >= 13) // PLUS
							cv_l_port.write(ep_msg);
						else
							assign_MCAM(j, ep_msg);
					end
					default: begin
					end
				endcase
			end
		endcase		
	endfunction : assign_MCOM	

	task run_phase(uvm_phase phase);
		forever begin
			cvififo.get(clk);
			// When PERIOD = 0
			if (!period) begin
				for (int i=1; i<25; i+=1) begin
					e_msg.timestamp = per_start + 10*low_count; // CLOCK RELATED
					//`uvm_info("CV", $sformatf("%s = %b @ %0t", e_msg.p, e_msg.val, e_msg.timestamp), UVM_LOW)
					cv_off_port.write(e_msg);
				end
				low_count += 1;
			end
			// Counter counts when PERIOD != 0
			else if (per_start == per_startold) begin
				//`uvm_info("CV", $sformatf("Nothing happens"), UVM_LOW)
			end
			// When counter starts counting after overflow
			else begin
				`uvm_info("CV", $sformatf("PERIOD%d starts at %0t, ends at %0t", period, per_start, per_end), UVM_LOW)
				//`uvm_info("CV", $sformatf("%s r%b mo:%s ma:%s s%b duty%d cd%b  %0t", ct_msg[4].p, ct_msg[4].recirc, ct_msg[4].mo, ct_msg[4].ma, ct_msg[4].sign, ct_msg[4].duty, ct_msg[4].cd, ct_msg[4].timestamp), UVM_LOW)
				low_count = 0;
				
				// Allocate each pin to its verification scoreboard
				for (int j=1; j<25; j+=1) begin
					ep_msg = new(ct_msg[j].p, period, per_start, per_end, ct_msg[j].recirc, ct_msg[j].mo, ct_msg[j].ma, ct_msg[j].sign, ct_msg[j].duty, ct_msg[j].cd);
					cv_prd_port.write(ep_msg);
					cv_dt_port.write(ep_msg);
					cv_com_port.write(ep_msg);
					if (ct_msg[j].ma == disabled) // If MCAM = 00
						cv_l_port.write(ep_msg);
					else // If MCAM != DISABLED
						assign_MCOM(j, ep_msg);
				end
			end
			per_startold = per_start;
		end
	endtask : run_phase

endclass : control_values 
