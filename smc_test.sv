class smc_test extends uvm_test;

	`uvm_component_utils(smc_test)
	
	virtual smc_intf intf;
	smc_env env;
	smc_sequence seq;

	function new(string name="smc_test", uvm_component par=null);
		super.new(name, par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		env = smc_env::type_id::create("env", this);
		seq = smc_sequence::type_id::create("seq", this);
		if (!uvm_config_db #(virtual smc_intf)::get(this, "", "intf", intf))
			`uvm_fatal("SMC TEST", "Something wrong in intf config.")
		uvm_config_db #(virtual smc_intf)::set(this, "env", "intf", intf);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.raise_objection(this, "Sequence starts.");
			seq.start(env.agent.sqr);
			#100000;
		phase.drop_objection(this, "Sequence ends.");
	endtask : run_phase

endclass : smc_test
