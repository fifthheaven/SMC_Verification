// Verify a PWM signal in CENTER alignment
class pwm_center extends uvm_scoreboard;

	`uvm_component_utils(pwm_center)
	uvm_tlm_analysis_fifo #(obs_val_msg) pcfifo;
	uvm_analysis_imp #(exp_pulse_msg, pwm_center) pc_imp;

	obs_val_msg o_msg;
	exp_pulse_msg ep[24:0];

	// Store timestamp and obesrved pin values (Corresponding to enum pin)
	logic [24:0] s_pin;
	realtime s_time;
	// Previous period info. For determine the delay
	realtime prev_start[24:0];
       	realtime prev_end[24:0];
	// For delay state reference
	bit first_cyc[24:0];
	// Determine whether the PWM is at even/odd period
	typedef enum {even, odd} parity;
	parity par[24:0];

	pin p = zero;

	function new(string name="pwm_center", uvm_component par=null);
		super.new(name, par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		pcfifo = new("pcfifo", this);
		pc_imp = new("pc_imp", this);
		for (int j=1; j<25; j+=1) begin
			ep[j] = new(zero, 0, 0, 0, 0, half_b_m, disabled, 0, 0, 0);
		end
	endfunction : build_phase

	function void write (exp_pulse_msg e);
		`uvm_info("PWM C", $sformatf("%s|per%8d|p_s %0t|p_e %0t|r %b|mo %s|ma %s|s %b|duty%8d|cd %b  %0t", e.p, e.period, e.per_start, e.per_end, e.recirc, e.mo, e.ma, e.sign, e.duty, e.cd, e.timestamp), UVM_LOW)
		ep[e.p] = e;
	endfunction : write

	task run_phase(uvm_phase phase);
		forever begin
			pcfifo.get(o_msg);
			s_pin[12:1] = o_msg.MNM[11:0];
			s_pin[24:13] = o_msg.MNP[11:0];
			s_time = o_msg.timestamp;
			
			for (int i=1; i<25; i+=1) begin

				// Determine which cycle we're in for delay
				if (ep[i].per_start > prev_end[i]) begin
					first_cyc[i] = 1;
					par[i] = even;
				end
				else if (ep[i].per_start == prev_end[i]) begin
					first_cyc[i] = 0;
					par[i] = parity'(!par[i]);
				end

/*				if (i==17)
					`uvm_info("PWM C", $sformatf("%0t %0t | period is at %s | first cycle %b", ep[i].per_start, prev_end[i], par[i], first_cyc[i]), UVM_LOW)
*/
				// DELAY shift without previous delay
				if (first_cyc[i]) begin // CLOCK RELATED
					// DUTY
					if (ep[i].per_start<=s_time && s_time<ep[i].per_start+10*(ep[i].duty+ep[i].cd)) begin // CLOCK RELATED
						if (ep[i].recirc ^ s_pin[i]) begin
							`uvm_error("PWM C", $sformatf("WRONG %s   @%0t", ep[i].p, s_time))
							//`uvm_info("PWM C", $sformatf("m2c0p %b", s_pin[17]), UVM_LOW)
						end
					end
					else if (ep[i].per_start+10*(ep[i].duty+ep[i].cd)<=s_time && s_time<ep[i].per_end) begin //CLOCK RELATED
						if (!(ep[i].recirc ^ s_pin[i])) begin
							`uvm_error("PWM C", $sformatf("WRONG %s   @%0t", ep[i].p, s_time))
						end
					end
				end
				// DELAY from previous counter overflow
				else begin
					//`uvm_info("PWM C", $sformatf("%0t %0t %0t %0t", ep[i].per_start, ep[i].per_start+10*ep[i].cd, ep[i].per_start+10*(ep[i].duty+ep[i].cd), ep[i].per_end), UVM_LOW)
					if (par[i] == even) begin // EVEN cycle
						if (ep[i].per_start<=s_time && s_time<ep[i].per_start+10*ep[i].cd) begin // CLOCK RELATED
							if (!(ep[i].recirc ^ s_pin[i])) begin
								`uvm_error("PWM C", $sformatf("WRONG %s   @%0t", ep[i].p, s_time))
							end
						end
						else if (ep[i].per_start+10*ep[i].cd<=s_time && s_time<ep[i].per_start+10*(ep[i].duty+ep[i].cd)) begin // CLOCK RELATED
							if (ep[i].recirc ^ s_pin[i]) begin
								`uvm_error("PWM C", $sformatf("WRONG %s   @%0t", ep[i].p, s_time))
							end
						end
						else if (ep[i].per_start+10*(ep[i].duty+ep[i].cd)<=s_time && s_time<ep[i].per_end) begin //CLOCK RELATED
							if (!(ep[i].recirc ^ s_pin[i])) begin
								`uvm_error("PWM C", $sformatf("WRONG %s   @%0t", ep[i].p, s_time))
							end
						end
					end
					else begin // ODD cycle
						if (ep[i].per_start<=s_time && s_time<ep[i].per_start+10*ep[i].cd) begin // CLOCK RELATED
							if (ep[i].recirc ^ s_pin[i]) begin
								`uvm_error("PWM C", $sformatf("WRONG %s   @%0t", ep[i].p, s_time))
							end
						end
						else if (ep[i].per_start+10*ep[i].cd<=s_time && s_time<ep[i].per_start+10*(ep[i].period + ep[i].cd - ep[i].duty)) begin // CLOCK RELATED
							if (!(ep[i].recirc ^ s_pin[i])) begin
								`uvm_error("PWM C", $sformatf("WRONG %s   @%0t", ep[i].p, s_time))
							end
						end
						else if (ep[i].per_start+10*(ep[i].period + ep[i].cd - ep[i].duty)<=s_time && s_time<ep[i].per_end) begin //CLOCK RELATED
							if (ep[i].recirc ^ s_pin[i]) begin
								`uvm_error("PWM C", $sformatf("WRONG %s   @%0t", ep[i].p, s_time))
							end
						end
					end
				end
			
				prev_start[i] = ep[i].per_start;
				prev_end[i] = ep[i].per_end;
			end
//			`uvm_info("PWM C", $sformatf("m2c0p %b  @%0t", s_pin[17], o_msg.timestamp), UVM_LOW)
		end
	endtask : run_phase
endclass : pwm_center
