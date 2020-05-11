// Verify if a pin is off (Period = 0)
class off_det extends uvm_scoreboard;

	`uvm_component_utils(off_det)
	uvm_tlm_analysis_fifo #(obs_val_msg) odfifo;
	uvm_analysis_imp #(exp_val_msg, off_det) od_imp;

	obs_val_msg o_msg;
	exp_val_msg e_msg;

	bit e_receive = 0;
	// Store timestamp and obesrved pin values (Corresponding to enum pin)
	logic [24:0] s_pin;
	logic [24:0] s_pin_old;
	realtime s_time;
	realtime s_time_old;

	pin p;

	function new(string name="off_det", uvm_component par=null);
		super.new(name, par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		odfifo = new("odfifo", this);
		od_imp = new("od_imp", this);
		e_msg = new();
	endfunction : build_phase

	function void write (exp_val_msg ep_msg);
		e_msg.timestamp = ep_msg.timestamp;
		e_receive = 1;
	endfunction : write

	task run_phase(uvm_phase phase);
		forever begin
			odfifo.get(o_msg);
			s_pin[12:1] = o_msg.MNM[11:0];
			s_pin[24:13] = o_msg.MNP[11:0];
			s_time = o_msg.timestamp;
			// Compare M&P OUTPUT when EXPECTED VALUES received
			if (e_receive) begin
				if (e_msg.timestamp==s_time && e_msg.timestamp!=0) begin // Exclude time = 0
					//`uvm_info("OD", $sformatf("%0t %s %b | m2c0p:%b", s_time, e_msg.p, e_msg.val, s_pin[17]), UVM_LOW)
					// VERIFY: EXP = OBS = 0
					for (int i=1; i<25; i+=1) begin
						if (s_pin[i])
							`uvm_error("OD", $sformatf("%s  SHOULD BE OFF  @%0t", p.next(i), e_msg.timestamp))
					end
				end
				else if (!e_msg.timestamp); // Do nothing when time = 0
				else if (e_msg.timestamp == s_time_old) begin
					for (int i=1; i<25; i+=1) begin
						if (s_pin_old[i])
							`uvm_error("OD", $sformatf("%s  SHOULD BE OFF  @%0t", p.next(i), e_msg.timestamp))
					end
				end
				else begin
					`uvm_error("OD", "Timestamp mismatch!")
					`uvm_error("OD", $sformatf("Timestamp mismatch!   e %0t s %0t", e_msg.timestamp, s_time))
				end
			end
			
			s_time_old = s_time;
			for (int k=0; k<25; k+=1)
				s_pin_old[k] = s_pin[k];
			e_receive = 0;
			end
	endtask : run_phase

endclass : off_det 
