// Verify if a pin stays at logic HIGH
class high_det extends uvm_scoreboard;

	`uvm_component_utils(high_det)
	uvm_tlm_analysis_fifo #(obs_val_msg) hdfifo;
	uvm_analysis_imp #(exp_pulse_msg, high_det) hd_imp;

	obs_val_msg o_msg;
	exp_pulse_msg ep_msg;

	// Store timestamp and obesrved pin values (Corresponding to enum pin)
	logic [24:0] s_pin;
	realtime s_time;
	// Store received EXP LOW timefrmae
	realtime exp_start[24:0];
	realtime exp_end[24:0];

	pin p = zero;

	function new(string name="high_det", uvm_component par=null);
		super.new(name, par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		hdfifo = new("hdfifo", this);
		hd_imp = new("hd_imp", this);
	endfunction : build_phase

	function void write (exp_pulse_msg ep_msg);
		`uvm_info("HD", $sformatf("%s|per%8d|p_s %0t|p_e %0t|r %b|mo %s|ma %s|s %b|duty%8d|cd %b  %0t", ep_msg.p, ep_msg.period, ep_msg.per_start, ep_msg.per_end, ep_msg.recirc, ep_msg.mo, ep_msg.ma, ep_msg.sign, ep_msg.duty, ep_msg.cd, ep_msg.timestamp), UVM_LOW)
		exp_start[ep_msg.p] = ep_msg.per_start;
		exp_end[ep_msg.p] = ep_msg.per_end;
	endfunction : write

	task run_phase(uvm_phase phase);
		forever begin
			hdfifo.get(o_msg);
			s_pin[12:1] = o_msg.MNM[11:0];
			s_pin[24:13] = o_msg.MNP[11:0];
			s_time = o_msg.timestamp;
			//`uvm_info("HD", $sformatf("m0c0p = %b  |  m0c1m = %b   @%0t", s_mnp[0], s_mnm[1], s_time), UVM_LOW)
			
			for (int i=1; i<25; i+=1) begin
				if (exp_start[i]<=s_time && s_time<exp_end[i]) begin
					if (!s_pin[i])
						`uvm_error("HD", $sformatf("%s should be 1 at %0t", p.next(i), s_time))
				end
			end
		end
	endtask : run_phase
endclass : high_det
