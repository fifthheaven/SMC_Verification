// Collect all the parameters for PWM on 24 pins 
class control_col extends uvm_scoreboard;

	`uvm_component_utils(control_col)
	uvm_tlm_analysis_fifo #(bit) ccclkfifo;
	uvm_tlm_analysis_fifo #(command_msg) cccfifo;
	uvm_analysis_port #(control_msg) cc_port;

	command_msg c_msg;
	control_msg ct_msg[24:0];

	bit clk;
	pin pp;

	function new(string name="control_col", uvm_component par=null);
		super.new(name, par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		ccclkfifo = new("ccclkfifo", this);
		cccfifo = new("cccfifo", this);
		cc_port = new("cc_port", this);
		for (int i=1; i<25; i+=1) begin
			pp = pp.first();
			pp = pp.next(i);
			ct_msg[i] = new(pp);
		end
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		forever begin
			cccfifo.get(c_msg);
			case (c_msg.r)
				mcctl1: begin
					for (int i=1; i<25; i+=1) begin
						ct_msg[i].recirc = c_msg.data[7];
						ct_msg[i].timestamp = c_msg.timestamp;
					end
				end
				mccc0: begin
					ct_msg[1].mo = mcom'(c_msg.data[7:6]);
					ct_msg[1].ma = mcam'(c_msg.data[5:4]);
					ct_msg[1].cd = c_msg.data[1:0];
					ct_msg[1].timestamp = c_msg.timestamp;
					ct_msg[13].mo = mcom'(c_msg.data[7:6]);
					ct_msg[13].ma = mcam'(c_msg.data[5:4]);
					ct_msg[13].cd = c_msg.data[1:0];
					ct_msg[13].timestamp = c_msg.timestamp;
			       	end
				mccc1: begin
					ct_msg[2].mo = mcom'(c_msg.data[7:6]);
					ct_msg[2].ma = mcam'(c_msg.data[5:4]);
					ct_msg[2].cd = c_msg.data[1:0];
					ct_msg[2].timestamp = c_msg.timestamp;
					ct_msg[14].mo = mcom'(c_msg.data[7:6]);
					ct_msg[14].ma = mcam'(c_msg.data[5:4]);
					ct_msg[14].cd = c_msg.data[1:0];
					ct_msg[14].timestamp = c_msg.timestamp;
				end
				mccc2: begin
					ct_msg[3].mo = mcom'(c_msg.data[7:6]);
					ct_msg[3].ma = mcam'(c_msg.data[5:4]);
					ct_msg[3].cd = c_msg.data[1:0];
					ct_msg[3].timestamp = c_msg.timestamp;
					ct_msg[15].mo = mcom'(c_msg.data[7:6]);
					ct_msg[15].ma = mcam'(c_msg.data[5:4]);
					ct_msg[15].cd = c_msg.data[1:0];
					ct_msg[15].timestamp = c_msg.timestamp;
				end
				mccc3: begin
					ct_msg[4].mo = mcom'(c_msg.data[7:6]);
					ct_msg[4].ma = mcam'(c_msg.data[5:4]);
					ct_msg[4].cd = c_msg.data[1:0];
					ct_msg[4].timestamp = c_msg.timestamp;
					ct_msg[16].mo = mcom'(c_msg.data[7:6]);
					ct_msg[16].ma = mcam'(c_msg.data[5:4]);
					ct_msg[16].cd = c_msg.data[1:0];
					ct_msg[16].timestamp = c_msg.timestamp;
				end
				mccc4: begin
					ct_msg[5].mo = mcom'(c_msg.data[7:6]);
					ct_msg[5].ma = mcam'(c_msg.data[5:4]);
					ct_msg[5].cd = c_msg.data[1:0];
					ct_msg[5].timestamp = c_msg.timestamp;
					ct_msg[17].mo = mcom'(c_msg.data[7:6]);
					ct_msg[17].ma = mcam'(c_msg.data[5:4]);
					ct_msg[17].cd = c_msg.data[1:0];
					ct_msg[17].timestamp = c_msg.timestamp;
				end
				mccc5: begin
					ct_msg[6].mo = mcom'(c_msg.data[7:6]);
					ct_msg[6].ma = mcam'(c_msg.data[5:4]);
					ct_msg[6].cd = c_msg.data[1:0];
					ct_msg[6].timestamp = c_msg.timestamp;
					ct_msg[18].mo = mcom'(c_msg.data[7:6]);
					ct_msg[18].ma = mcam'(c_msg.data[5:4]);
					ct_msg[18].cd = c_msg.data[1:0];
					ct_msg[18].timestamp = c_msg.timestamp;
				end
				mccc6: begin
					ct_msg[7].mo = mcom'(c_msg.data[7:6]);
					ct_msg[7].ma = mcam'(c_msg.data[5:4]);
					ct_msg[7].cd = c_msg.data[1:0];
					ct_msg[7].timestamp = c_msg.timestamp;
					ct_msg[19].mo = mcom'(c_msg.data[7:6]);
					ct_msg[19].ma = mcam'(c_msg.data[5:4]);
					ct_msg[19].cd = c_msg.data[1:0];
					ct_msg[19].timestamp = c_msg.timestamp;
				end
				mccc7: begin
					ct_msg[8].mo = mcom'(c_msg.data[7:6]);
					ct_msg[8].ma = mcam'(c_msg.data[5:4]);
					ct_msg[8].cd = c_msg.data[1:0];
					ct_msg[8].timestamp = c_msg.timestamp;
					ct_msg[20].mo = mcom'(c_msg.data[7:6]);
					ct_msg[20].ma = mcam'(c_msg.data[5:4]);
					ct_msg[20].cd = c_msg.data[1:0];
					ct_msg[20].timestamp = c_msg.timestamp;
				end
				mccc8: begin
					ct_msg[9].mo = mcom'(c_msg.data[7:6]);
					ct_msg[9].ma = mcam'(c_msg.data[5:4]);
					ct_msg[9].cd = c_msg.data[1:0];
					ct_msg[9].timestamp = c_msg.timestamp;
					ct_msg[21].mo = mcom'(c_msg.data[7:6]);
					ct_msg[21].ma = mcam'(c_msg.data[5:4]);
					ct_msg[21].cd = c_msg.data[1:0];
					ct_msg[21].timestamp = c_msg.timestamp;
				end
				mccc9: begin
					ct_msg[10].mo = mcom'(c_msg.data[7:6]);
					ct_msg[10].ma = mcam'(c_msg.data[5:4]);
					ct_msg[10].cd = c_msg.data[1:0];
					ct_msg[10].timestamp = c_msg.timestamp;
					ct_msg[22].mo = mcom'(c_msg.data[7:6]);
					ct_msg[22].ma = mcam'(c_msg.data[5:4]);
					ct_msg[22].cd = c_msg.data[1:0];
					ct_msg[22].timestamp = c_msg.timestamp;
				end
				mccc10: begin
					ct_msg[11].mo = mcom'(c_msg.data[7:6]);
					ct_msg[11].ma = mcam'(c_msg.data[5:4]);
					ct_msg[11].cd = c_msg.data[1:0];
					ct_msg[11].timestamp = c_msg.timestamp;
					ct_msg[23].mo = mcom'(c_msg.data[7:6]);
					ct_msg[23].ma = mcam'(c_msg.data[5:4]);
					ct_msg[23].cd = c_msg.data[1:0];
					ct_msg[23].timestamp = c_msg.timestamp;
				end
				mccc11: begin
					ct_msg[12].mo = mcom'(c_msg.data[7:6]);
					ct_msg[12].ma = mcam'(c_msg.data[5:4]);
					ct_msg[12].cd = c_msg.data[1:0];
					ct_msg[12].timestamp = c_msg.timestamp;
					ct_msg[24].mo = mcom'(c_msg.data[7:6]);
					ct_msg[24].ma = mcam'(c_msg.data[5:4]);
					ct_msg[24].cd = c_msg.data[1:0];
					ct_msg[24].timestamp = c_msg.timestamp;
				end
				mcdc0: begin
					ct_msg[1].sign = c_msg.data[15];
					ct_msg[1].duty = c_msg.data[10:0];
					ct_msg[1].timestamp = c_msg.timestamp;
					ct_msg[13].sign = c_msg.data[15];
					ct_msg[13].duty = c_msg.data[10:0];
					ct_msg[13].timestamp = c_msg.timestamp;
			       	end
				mcdc1: begin
					ct_msg[2].sign = c_msg.data[15];
					ct_msg[2].duty = c_msg.data[10:0];
					ct_msg[2].timestamp = c_msg.timestamp;
					ct_msg[14].sign = c_msg.data[15];
					ct_msg[14].duty = c_msg.data[10:0];
					ct_msg[14].timestamp = c_msg.timestamp;
				end
				mcdc2: begin
					ct_msg[3].sign = c_msg.data[15];
					ct_msg[3].duty = c_msg.data[10:0];
					ct_msg[3].timestamp = c_msg.timestamp;
					ct_msg[15].sign = c_msg.data[15];
					ct_msg[15].duty = c_msg.data[10:0];
					ct_msg[15].timestamp = c_msg.timestamp;
				end
				mcdc3: begin
					ct_msg[4].sign = c_msg.data[15];
					ct_msg[4].duty = c_msg.data[10:0];
					ct_msg[4].timestamp = c_msg.timestamp;
					ct_msg[16].sign = c_msg.data[15];
					ct_msg[16].duty = c_msg.data[10:0];
					ct_msg[16].timestamp = c_msg.timestamp;
				end
				mcdc4: begin
					ct_msg[5].sign = c_msg.data[15];
					ct_msg[5].duty = c_msg.data[10:0];
					ct_msg[5].timestamp = c_msg.timestamp;
					ct_msg[17].sign = c_msg.data[15];
					ct_msg[17].duty = c_msg.data[10:0];
					ct_msg[17].timestamp = c_msg.timestamp;
				end
				mcdc5: begin
					ct_msg[6].sign = c_msg.data[15];
					ct_msg[6].duty = c_msg.data[10:0];
					ct_msg[6].timestamp = c_msg.timestamp;
					ct_msg[18].sign = c_msg.data[15];
					ct_msg[18].duty = c_msg.data[10:0];
					ct_msg[18].timestamp = c_msg.timestamp;
				end
				mcdc6: begin
					ct_msg[7].sign = c_msg.data[15];
					ct_msg[7].duty = c_msg.data[10:0];
					ct_msg[7].timestamp = c_msg.timestamp;
					ct_msg[19].sign = c_msg.data[15];
					ct_msg[19].duty = c_msg.data[10:0];
					ct_msg[19].timestamp = c_msg.timestamp;
				end
				mcdc7: begin
					ct_msg[8].sign = c_msg.data[15];
					ct_msg[8].duty = c_msg.data[10:0];
					ct_msg[8].timestamp = c_msg.timestamp;
					ct_msg[20].sign = c_msg.data[15];
					ct_msg[20].duty = c_msg.data[10:0];
					ct_msg[20].timestamp = c_msg.timestamp;
				end
				mcdc8: begin
					ct_msg[9].sign = c_msg.data[15];
					ct_msg[9].duty = c_msg.data[10:0];
					ct_msg[9].timestamp = c_msg.timestamp;
					ct_msg[21].sign = c_msg.data[15];
					ct_msg[21].duty = c_msg.data[10:0];
					ct_msg[21].timestamp = c_msg.timestamp;
				end
				mcdc9: begin
					ct_msg[10].sign = c_msg.data[15];
					ct_msg[10].duty = c_msg.data[10:0];
					ct_msg[10].timestamp = c_msg.timestamp;
					ct_msg[22].sign = c_msg.data[15];
					ct_msg[22].duty = c_msg.data[10:0];
					ct_msg[22].timestamp = c_msg.timestamp;
				end
				mcdc10: begin
					ct_msg[11].sign = c_msg.data[15];
					ct_msg[11].duty = c_msg.data[10:0];
					ct_msg[11].timestamp = c_msg.timestamp;
					ct_msg[23].sign = c_msg.data[15];
					ct_msg[23].duty = c_msg.data[10:0];
					ct_msg[23].timestamp = c_msg.timestamp;
				end
				mcdc11: begin
					ct_msg[12].sign = c_msg.data[15];
					ct_msg[12].duty = c_msg.data[10:0];
					ct_msg[12].timestamp = c_msg.timestamp;
					ct_msg[24].sign = c_msg.data[15];
					ct_msg[24].duty = c_msg.data[10:0];
					ct_msg[24].timestamp = c_msg.timestamp;
				end
			endcase
			for (int i=1; i</*5*/25; i+=1) begin
				cc_port.write(ct_msg[i]);
				//`uvm_info("CC", $sformatf("%s r%b mo:%s ma:%s s%b cd%b  %0t", ct_msg[i].p, ct_msg[i].recirc, ct_msg[i].mo, ct_msg[i].ma, ct_msg[i].sign, ct_msg[i].cd, ct_msg[i].timestamp), UVM_LOW)
			end
		end
	endtask : run_phase

endclass : control_col 
