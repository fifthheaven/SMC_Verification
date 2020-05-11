// Clock for reference model
class clk_control extends uvm_scoreboard;

	`uvm_component_utils(clk_control)
	uvm_tlm_analysis_fifo #(in_msg) clkfifo;
	uvm_analysis_port #(bit) clk_port;

	in_msg i_msg;

	function new(string name="clk_control", uvm_component par=null);
		super.new(name, par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		clkfifo = new("clkfifo", this);
		clk_port = new("clk_port", this);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		forever begin
			clkfifo.get(i_msg);
			// Send CLK TIME and VALUE
			clk_port.write(i_msg.QCLK);
		end
	endtask : run_phase
endclass : clk_control
