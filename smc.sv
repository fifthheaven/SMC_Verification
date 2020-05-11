module smc (input QCLK, input QRESET, input QWRITE, input QSEL, input [6:0] QADDR, input [15:0] QDATAIN, output [15:0] QDATAOUT, output [11:0] MNM, output [11:0] MNP);

reg [15:0] SMC_MCPER;
reg [7:0] SMC_MCCTL1;
reg [7:0] SMC_MCCTL0;
reg [7:0] SMC_MCCC3;
reg [7:0] SMC_MCCC2;
reg [7:0] SMC_MCCC1;
reg [7:0] SMC_MCCC0;
reg [7:0] SMC_MCCC7;
reg [7:0] SMC_MCCC6;
reg [7:0] SMC_MCCC5;
reg [7:0] SMC_MCCC4;
reg [7:0] SMC_MCCC11;
reg [7:0] SMC_MCCC10;
reg [7:0] SMC_MCCC9;
reg [7:0] SMC_MCCC8;
reg [15:0] SMC_MCDC1;
reg [15:0] SMC_MCDC0;
reg [15:0] SMC_MCDC3;
reg [15:0] SMC_MCDC2;
reg [15:0] SMC_MCDC5;
reg [15:0] SMC_MCDC4;
reg [15:0] SMC_MCDC7;
reg [15:0] SMC_MCDC6;
reg [15:0] SMC_MCDC9;
reg [15:0] SMC_MCDC8;
reg [15:0] SMC_MCDC11;
reg [15:0] SMC_MCDC10;

reg [11:0] out_MNM;
reg [11:0] out_MNP;
assign MNM = out_MNM;
assign MNP = out_MNP;

int count = 0;

always @(posedge QCLK) begin
	
	for (int i=0; i<12; i+=1) begin
		out_MNM[i] = 0;
		out_MNP[i] = 0;
	end


/*	if (count==0) begin
		out_MNM[1] = 0; 
		out_MNP[4] = 0;
	end
	else if (count == 1) begin
		out_MNM[1] = 0; 
		out_MNP[4] = 0;	
	end
	else if (count == 2) begin
		out_MNM[1] = 0; 
		out_MNP[4] = 0;	
	end	
	else if (count == 3) begin
		out_MNM[1] = 0; 
		out_MNP[4] = 0;	
	end	
	else if (count == 4) begin
		out_MNM[1] = 0; 
		out_MNP[4] = 0;	
	end	
	else if (count == 5) begin
		out_MNM[1] = 0; 
		out_MNP[4] = 0;	
	end	
	else if (count == 6) begin
		out_MNM[1] = 0; 
		out_MNP[4] = 1;	
	end	
	else if (count == 7) begin
		out_MNM[1] = 0; 
		out_MNP[4] = 1;
	end
	else if (count == 8) begin
		out_MNM[1] = 0; 
		out_MNP[4] = 0;
	end
	else if (count == 9) begin
		out_MNM[1] = 0; 
		out_MNP[4] = 0;
	end
	else if (count == 10) begin
		out_MNM[1] = 0; 
		out_MNP[4] = 0;
	end
	else if (count == 11) begin
		out_MNM[1] = 0; 
		out_MNP[4] = 0;
	end
	else if (count == 12) begin
		out_MNM[1] = 0; 
		out_MNP[4] = 0;
	end
	else if (count == 13) begin
		out_MNM[1] = 0; 
		out_MNP[4] = 0;
		count = -1;
	end

	count += 1;



	if (count==0) begin
		out_MNM[1] = 0; 
		out_MNP[4] = 0;
	end
	else if (count == 1) begin
		out_MNM[1] = 0; 
		out_MNP[4] = 0;	
	end
	else if (count == 2) begin
		out_MNM[1] = 0; 
		out_MNP[4] = 0;	
	end	
	else if (count == 3) begin
		out_MNM[1] = 0; 
		out_MNP[4] = 1;	
		count = -1;
	end	
	count += 1;
*/
end


endmodule : smc
