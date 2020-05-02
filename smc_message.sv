// Input sequence
class in_msg extends uvm_sequence_item;

	`uvm_object_utils(in_msg)

	rand bit QRESET;
	rand bit QWRITE;
	rand bit QSEL;
	rand bit [6:0] QADDR;
	rand bit [15:0] QDATAIN;
	realtime timestamp;

	function new(string name="in_msg");
		super.new(name);
	endfunction : new

endclass : in_msg


// Output from DUT
class out_msg extends uvm_sequence_item;

	`uvm_object_utils(out_msg)

	logic [15:0] QDATAOUT;
	logic [11:0] MNM;
	logic [11:0] MNP;
	realtime timestamp;

	function new(string name="out_msg");
		super.new(name);
	endfunction : new

endclass : out_msg


// Edge detector message
typedef enum {x_z, Stay, Rising, Falling} rf;
class rf_msg;

	// Rising/Falling status of each port
	rf rf_mnm[11:0];
	rf rf_mnp[11:0];
	realtime timestamp;

	function new(rf r);
		for (int i=0; i<12; i+=1) begin
			this.rf_mnm[i] = r;
			this.rf_mnp[i] = r;
		end
		this.timestamp = $realtime;
	endfunction : new

endclass : rf_msg

// Input detector message
typedef enum {empty, mcper, mcctl1, mcctl0, mccc3, mccc2, mccc1, mccc0, mccc7, mccc6, mccc5, mccc4, mccc11, mccc10, mccc9, mccc8, mcdc1, mcdc0, mcdc3, mcdc2, mcdc5, mcdc4, mcdc7, mcdc6, mcdc9, mcdc8, mcdc11, mcdc10} regsss;
class command_msg;

	// r: control register; data: data stored in the address
	regsss r;
	logic [15:0] data;
	realtime timestamp;

	function new(regsss R, logic D);
		r = R;
		data = D;
		this.timestamp = $realtime;
	endfunction : new

endclass : command_msg;


class period_msg;

	// count: couter for period; per: difference between previous "rising"
	// edges
	int mnm_count[11:0];
	int mnp_count[11:0];
	int mnm_per[11:0];
	int mnp_per[11:0];
	realtime timestamp;

	function new();
		for (int i=0; i<12; i+=1) begin
			this.mnm_count[i] = 0;
			this.mnp_count[i] = 0;
			this.mnm_per[i] = 0;
			this.mnp_per[i] = 0;
		end
		this.timestamp = $realtime;
	endfunction : new

endclass : period_msg

typedef enum {none,left,right,center} align_mode;
class align_msg;
	align_mode mnm_a_m[11:0];
	align_mode mnp_a_m[11:0];
	function new(align_mode a);
		for(int i=0;i<12;i+=1) begin
			this.mnm_a_m[i]=a;
			this.mnp_a_m[i]=a;
		end
	endfunction : new
endclass:align_msg

class duty_msg;

	// count: couter for period; per: difference between previous "rising"
	// edges
	int mnm_count[11:0];
	int mnp_count[11:0];
	int mnm_duty[11:0];
	int mnp_duty[11:0];
	realtime timestamp;

	function new();
		for (int i=0; i<12; i+=1) begin
			this.mnm_count[i] = 0;
			this.mnp_count[i] = 0;
			this.mnm_duty[i] = 0;
			this.mnp_duty[i] = 0;
		end
		this.timestamp = $realtime;
	endfunction : new

endclass : duty_msg

typedef enum {high,low} active_mode;
class active_msg;
	active_mode mnm_ac_m[11:0];
	active_mode mnp_ac_m[11:0];
	function new(active_mode a);
		for(int i=0;i<12;i+=1) begin
			this.mnm_a_m[i]=a;
			this.mnp_a_m[i]=a;
		end
	endfunction : new
endclass:active_mode


typedef enum {zero, counting, halt} per_status;
class period_counter_msg;
	per_status per_s;
	int counter;
	int period;
	int next_period;
	realtime timestamp;
	realtime start_time;
	realtime end_time;

	function new();
		this.per_s = zero;
		this.counter = 0;
		this.period = 0;
		this.next_period = 0;
		this.timestamp = $realtime;
	endfunction : new
endclass : period_counter_msg


typedef enum {none, fail, success} verif;
class recirc_sign_msg;
	verif mnm[11:0];
	verif mnp[11:0];
	realtime timestamp;

	function new();
		for (int i=0; i<12; i+=1) begin
			mnm[i] = none;
			mnp[i] = none;
		end
		this.timestamp = $realtime;
	endfunction : new
endclass : recirc_sign_msg
