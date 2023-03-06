`timescale 1ps/1ps 

module shifter_tb; //test bench
parameter delay=10;
	
	 logic [15:0] in;// input data
	 logic [3:0] amount; //shift amount - should be only bottom 4 bits 
	 logic [1:0] s_type; // shift type 
	 logic [15:0] out; // out
	 logic c;
	
	
	integer i;
	
	
	shifter dut(in,amount,s_type,out,c); 
	
	
	initial begin
		
		in <= 16'b1111000011001000;
		amount <= 4'd3;
		for (i=0; i<4; i=i+1) begin
		s_type <=i;
		#delay;
		end 
		end
	

	//initial 
	//$monitor($time, ,"ra1",ra1, " rd1 ",rd1," ra2 ",ra2," rd2 ", rd2, " wa ",wa," wd ",wd);
	
endmodule
