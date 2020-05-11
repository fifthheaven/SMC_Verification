class smc_monin extends uvm_monitor;

	`uvm_component_utils(smc_monin)
	virtual smc_intf intf;
	uvm_analysis_port #(in_msg) monin_ag;
	in_msg msg;

	function new(string name="smc_monin", uvm_component par=null);
		super.new(name, par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		msg = in_msg::type_id::create("msg");
		monin_ag = new("monin_ag", this);
		if (!uvm_config_db #(virtual smc_intf)::get(this, "", "intf", intf))
			`uvm_fatal("SMC MON IN", "Something wrong in intf config.")
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		forever begin
			@ (posedge intf.monin_intf.QCLK);
			msg.QCLK = intf.monin_intf.QCLK;
			msg.QRESET = intf.monin_intf.QRESET;
			msg.QWRITE = intf.monin_intf.QWRITE;
			msg.QSEL = intf.monin_intf.QSEL;
			msg.QADDR = intf.monin_intf.QADDR;
			msg.QDATAIN = intf.monin_intf.QDATAIN;
			msg.timestamp = $realtime;
			monin_ag.write(msg);
		end
	endtask : run_phase

endclass : smc_monin
