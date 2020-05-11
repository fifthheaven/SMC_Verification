import uvm_pkg :: *;

`include "smc_pkg.svh"

module top();

	smc_intf i();

	smc s(.QCLK(i.QCLK), .QRESET(i.QRESET), .QWRITE(i.QWRITE), .QSEL(i.QSEL), .QADDR(i.QADDR), .QDATAIN(i.QDATAIN), .QDATAOUT(i.QDATAOUT), .MNM(i.MNM), .MNP(i.MNP));

	initial begin
		i.QCLK = 0;
		#5;
		repeat (3000) begin
			#5 i.QCLK = 1;
			#5 i.QCLK = 0;
		end
	end

	initial begin
		uvm_config_db #(virtual smc_intf)::set(null, "*", "intf", i);
		run_test("smc_test");
		#100000
		$display("\n\nClock runs out.\n\n");
		$finish;
	end

endmodule : top
