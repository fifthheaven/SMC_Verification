class smc_sequencer extends uvm_sequencer #(in_msg);

	`uvm_component_utils(smc_sequencer)

	function new(string name="smc_sequencer", uvm_component par=null);
		super.new(name, par);
	endfunction : new

endclass : smc_sequencer
