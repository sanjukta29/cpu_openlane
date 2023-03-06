`timescale 1ps/1ps 

module regfile_tb; //test bench
parameter delay=10;
	
	logic clk,rst, we;
	logic [15:0] wd; // write data
    logic [3:0] ra1,ra2,wa; // addresses
    logic [15:0] rd1, rd2 ; // read data 1 and 2
	
	
	integer i;
	
	
	regfile dut(clk,rst, we, wd,ra1,ra2,wa, rd1, rd2); 
	
	initial begin
	clk<=0;
	//rst<=0;
	end
	initial begin forever #(delay/2) clk=~clk; end
	initial begin
		rst<=1;
		#35 rst<=0;
		we<=1;
		for (i=0; i<16; i=i+1) begin
		wa <= i; wd<= i*10;
		#delay;
		end 
		we<=0;
		for (i=0; i<16; i=i+1) begin
		ra1 <= i; ra2<= 15-i;
		#delay;
		end
	#1000 $stop;
	end

	initial 
	$monitor($time, ,"ra1",ra1, " rd1 ",rd1," ra2 ",ra2," rd2 ", rd2, " wa ",wa," wd ",wd);
	
endmodule
