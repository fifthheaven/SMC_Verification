class smc_driver extends uvm_driver #(in_msg);

	`uvm_component_utils(smc_driver)
	virtual smc_intf intf;
	in_msg msg;

	function new(string name="smc_driver", uvm_component par=null);
		super.new(name, par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if (!uvm_config_db #(virtual smc_intf)::get(this, "", "intf", intf))
			`uvm_fatal("SMC DRIVER", "Something wrong in intf config.")
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction : connect_phase

	task run_phase(uvm_phase phase);
		forever begin
			seq_item_port.get_next_item(msg);
				@ (posedge intf.drv_intf.QCLK);
				intf.drv_intf.QRESET <= msg.QRESET;
				intf.drv_intf.QWRITE <= msg.QWRITE;
				intf.drv_intf.QSEL <= msg.QSEL;
				intf.drv_intf.QDATAIN <= msg.QDATAIN;
				intf.drv_intf.QADDR <= msg.QADDR;
			seq_item_port.item_done();
		end
	endtask : run_phase

endclass : smc_driver
