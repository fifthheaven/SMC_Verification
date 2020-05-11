// Collect observing pin values
class smc_pinval extends uvm_scoreboard;

	`uvm_component_utils(smc_pinval)
	uvm_tlm_analysis_fifo #(out_msg) pvfifo;
	uvm_analysis_port #(obs_val_msg) pv_port;

	out_msg o_msg;
	obs_val_msg ov_msg;

	function new(string name="smc_pinval", uvm_component par=null);
		super.new(name, par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		pvfifo = new("pvfifo", this);
		pv_port = new("pv_port", this);
		ov_msg = new();
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		forever begin
			pvfifo.get(o_msg);
			for (int i=0; i<12; i+=1) begin
				if (o_msg.MNM[i])
					ov_msg.MNM[i] = 1;
				else
					ov_msg.MNM[i] = 0;
				if (o_msg.MNP[i])
					ov_msg.MNP[i] = 1;
				else
					ov_msg.MNP[i] = 0;
			end
			ov_msg.timestamp = $realtime;
			//`uvm_info("PIN OBS", $sformatf("MNM[1] %b | MNP[0] %b  @%0t", ov_msg.MNM[1], ov_msg.MNP[0], ov_msg.timestamp), UVM_LOW)
			pv_port.write(ov_msg);
		end
	endtask : run_phase

endclass : smc_pinval
