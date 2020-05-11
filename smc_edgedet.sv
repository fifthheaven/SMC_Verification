// Collect rising/falling message from output monitor
class smc_edgedet extends uvm_scoreboard;

	`uvm_component_utils(smc_edgedet)
	uvm_tlm_analysis_fifo #(out_msg) edfifo;
	uvm_analysis_port #(rf_msg) ed_port;

	out_msg o_msg;
	logic [11:0] old_mnm, old_mnp;
	// r_msg.rf_mnp[], r_msg.rf_mnm[] contains enum rising/falling/stay
	rf_msg r_msg;

	function new(string name="smc_edgedet", uvm_component par=null);
		super.new(name, par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		edfifo = new("edfifo", this);
		ed_port = new("ed_port", this);
		r_msg = new(Stay);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		forever begin
			edfifo.get(o_msg);
			for (int i=0; i<12; i+=1) begin
				if (((o_msg.MNM[i]==1) && (old_mnm[i]==1)) || ((o_msg.MNM[i]==0) && (old_mnm[i]==0)))
					r_msg.rf_mnm[i] = Stay;
				else if (o_msg.MNM[i]==1 && old_mnm[i]==0)
					r_msg.rf_mnm[i] = Rising;
				else if (o_msg.MNM[i]==0 && old_mnm[i]==1)
					r_msg.rf_mnm[i] = Falling;
				else
					r_msg.rf_mnm[i] = x_z;
			
				if (((o_msg.MNP[i]==1) && (old_mnp[i]==1)) || ((o_msg.MNP[i]==0) && (old_mnp[i]==0)))
					r_msg.rf_mnp[i] = Stay;
				else if (o_msg.MNP[i]==1 && old_mnp[i]==0)
					r_msg.rf_mnp[i] = Rising;
				else if (o_msg.MNP[i]==0 && old_mnp[i]==1)
					r_msg.rf_mnp[i] = Falling;
				else
					r_msg.rf_mnp[i] = x_z;
			end
			r_msg.timestamp = $realtime;
			ed_port.write(r_msg);
			//`uvm_info("EDGE DET", $sformatf("MNM[1] %s @ %0t", r_msg.rf_mnm[1], r_msg.timestamp), UVM_LOW)
			//`uvm_info("EDGE DET", $sformatf("MNP[0] %s @ %0t", r_msg.rf_mnp[0], r_msg.timestamp), UVM_LOW)
			//`uvm_info("EDGE DET", $sformatf("%b %b", o_msg.MNP[0], old_mnp[0]), UVM_LOW)
			old_mnm = o_msg.MNM;
			old_mnp = o_msg.MNP;
		end
	endtask : run_phase

endclass : smc_edgedet
