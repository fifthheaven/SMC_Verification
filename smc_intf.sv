interface smc_intf();

	logic QCLK;
	logic QRESET;
	logic QWRITE;
	logic QSEL;
	logic [6:0] QADDR;
	logic [15:0] QDATAIN;
	logic [15:0] QDATAOUT;
	logic [11:0] MNM;
	logic [11:0] MNP;

	modport drv_intf (input QCLK, output QRESET, output QWRITE, output QSEL, output QADDR, output QDATAIN);
	modport monout_intf (input QCLK, input QDATAOUT, input MNM, input MNP);
	modport monin_intf(input QCLK, input QRESET, input QWRITE, input QSEL, input QADDR, input QDATAIN);

endinterface : smc_intf
