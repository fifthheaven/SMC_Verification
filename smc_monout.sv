class smc_monout extends uvm_monitor;

	`uvm_component_utils(smc_monout)

	virtual smc_intf intf;
	uvm_analysis_port #(out_msg) monout_ag;
	out_msg msg;

	function new(string name="smc_monout", uvm_component par=null);
		super.new(name, par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		msg = out_msg::type_id::create("out_msg");
		monout_ag = new("monout_ag", this);
		if (!uvm_config_db #(virtual smc_intf)::get(this, "", "intf", intf))
			`uvm_fatal("SMC MON OUT", "Something wrong in intf config.")
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		forever begin
			@(posedge intf.monout_intf.QCLK);
			msg.QDATAOUT = intf.monout_intf.QDATAOUT;
			msg.MNM = intf.monout_intf.MNM;
			msg.MNP = intf.monout_intf.MNP;
			msg.timestamp = $realtime;
			monout_ag.write(msg);
			//`uvm_info("MON OUT", $sformatf("MNP[0] = %b %d", msg.MNP[0], msg.timestamp), UVM_LOW)
		end
	endtask : run_phase

endclass : smc_monout
