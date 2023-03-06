`timescale 1ps/1ps 

module alu_tb; //test bench
parameter delay=10;
	logic [15:0] A, B, result;
	logic [2:0] op;
	logic c,v;
	integer i;
	
	parameter ALU_ADD=3'd0, ALU_SUBTRACT=3'd1, ALU_AND=3'd2, ALU_OR=3'd3, ALU_XOR=3'd4, ALU_NOT=3'd5;
	
	alu dut (A, B, op, result,c,v);
	
	initial begin
		A = 0;
		B = 0;
		op = 0;
	end
	
	initial begin
		
	op = ALU_ADD;
		for (i=0; i<100; i++) begin
			//A = $random; B = $random;
			A = ($random%2) ? {2{$random}} : '0; //randomized inputs
		   B = ($random%2) ? {2{$random}} : '0;
			#(delay);
			assert(result == (A + B));
			
		end 

		//sub operation checks
		$display("%t testing subtraction", $time);
		op = ALU_SUBTRACT;
		for (i=0; i<100; i++) begin
			//A = $random; B = $random;
			A = ($random%2) ? {2{$random}} : '0; //randomized inputs
		   B = ($random%2) ? {2{$random}} : '0;
			#(delay);
			assert(result == (A - B));
		end
	
		//and operation checks
		$display("%t testing AND", $time);
		op = ALU_AND;
		for (i=0; i<100; i++) begin
			//A = $random; B = $random;
			A = ($random%2) ? {2{$random}} : '0; //randomized inputs
		   B = ($random%2) ? {2{$random}} : '0;
			#(delay);
			assert(result == (A & B));
		end

		//or operation checks
		$display("%t testing OR", $time);
		op = ALU_OR;
		for (i=0; i<100; i++) begin
			//A = $random; B = $random;
			A = ($random%2) ? {2{$random}} : '0; //randomized inputs
		   B = ($random%2) ? {2{$random}} : '0;
			#(delay);
			assert(result == (A | B));
		end
		//xor operation checks
		$display("%t testing XOR", $time);
		op = ALU_XOR;
		for (i=0; i<100; i++) begin
			//A = $random; B = $random;
			A = ($random%2) ? {2{$random}} : '0; //randomized inputs
		   B = ($random%2) ? {2{$random}} : '0;
			#(delay);
			assert(result == (A ^ B));
		end
		
		//not operation checks
		$display("%t testing XOR", $time);
		op = ALU_NOT;
		for (i=0; i<100; i++) begin
			//A = $random; B = $random;
			A = ($random%2) ? {2{$random}} : '0; //randomized inputs
		   B = ($random%2) ? {2{$random}} : '0;
			#(delay);
			assert(result == (~B));
		end
	end
	initial 
	$monitor($time, , op , , A , , B, , result);
	
endmodule
