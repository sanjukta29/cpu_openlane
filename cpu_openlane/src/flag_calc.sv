//calculate flags at result (outside ALU)
// overflow comes directly from ALU
// control signals to select present flag or registered flag - used in accelerated branch

`timescale 1ps/1ps 

module flag_calc (
        input logic clk,
		input logic signed  [15:0] in, // input data
		input logic alu_c,shift_c,alu_v,
		input logic n_update,c_update,z_update,v_update, // update or not
		input logic c_sel,
		output logic N,C,Z,V, // output to branch
		output reg n_,c_,z_,v_  // registered
		); 
		
	logic n,z,c,v;
	//reg n_,c_,z_,v_;
    
	assign z = (in=='0);
	assign n = in[15];
	assign v = alu_v;
	
	always_comb begin
	
	if(c_sel)  // select carry
	c = shift_c; //1
	else 
	c = alu_c; //0
	
	// flag updates
	if(n_update)
	N = n;
	else
	N = n_;
	
	if(c_update)
	C = c;
	else
	C = c_;
	
	if(z_update)
	Z = z;
	else
	Z = z_;
	
	if(v_update)
	V = v;
	else
	V = v_;
		
	end
	
	always_ff@(posedge clk) begin // saving flags
	// making a chnage here
	n_<=n;
	c_<=c;
	z_<=z;
	v_<=v;

	//n_<=N;
	//c_<=C;
	//z_<=Z;
	//v_<=V;
	end 
	
endmodule	


