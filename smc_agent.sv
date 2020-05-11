class smc_agent extends uvm_agent;

	`uvm_component_utils(smc_agent)

	virtual smc_intf intf;

	smc_sequencer sqr;
	smc_driver drv;
	smc_monin mi;
	smc_monout mo;
	uvm_analysis_port #(in_msg) ag_in;    // Message from Driver 
	uvm_analysis_port #(out_msg) ag_out;  // Message from Monitor
	
	function new(string name="smc_agent", uvm_component par=null);
		super.new(name, par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		sqr = smc_sequencer::type_id::create("sqr", this);
		drv = smc_driver::type_id::create("drv", this);
		mi = smc_monin::type_id::create("mi", this);
		mo = smc_monout::type_id::create("mo", this);
		ag_in = new("ag_in", this);
		ag_out = new("ag_out", this);

		if (!uvm_config_db #(virtual smc_intf)::get(this, "", "intf", intf))
			`uvm_fatal("SMC AGENT", "Something wrong in intf config.")
		uvm_config_db #(virtual smc_intf)::set(this, "drv", "intf", intf);
		uvm_config_db #(virtual smc_intf)::set(this, "mo", "intf", intf);
		uvm_config_db #(virtual smc_intf)::set(this, "mi", "intf", intf);

	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		drv.seq_item_port.connect(sqr.seq_item_export);
		mi.monin_ag.connect(ag_in);
		mo.monout_ag.connect(ag_out);
	endfunction : connect_phase

endclass : smc_agent
