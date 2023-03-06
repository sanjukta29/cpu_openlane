// 16 bit ALU with ADD, SUB, AND, OR, XOR, NOT, 
// add overflow flag, carry
`timescale 1ps/1ps 

module alu (
		input logic [15:0] A, // first input A
		input logic [15:0] B, // second input B
		input logic [2:0] op, // selects which operation to perform
		output logic [15:0] result, // result of ALU computation
		output logic c, v);
		//output N_flag, output Z_flag, output V_flag, output C_flag); // status flags

	enum {ADD,SUB,AND,OR,XOR,NOT} ops;
	always_comb begin
	
	case (op)
	 ADD: {c,result} = {A[15],A} + {B[15],B}; 
	 SUB: {c,result} = {A[15],A} + ~{B[15],B} +17'd1; 
	 AND: begin result = A & B; c=1'b0; end
	 OR:  begin result = A | B; c=1'b0; end
	 XOR: begin result = A ^ B; c=1'b0; end
	 NOT: begin result = ~B; c=1'b0; end
	 default: begin result = '0; c=1'b0; end
	endcase
	
	if (((op == ADD) && (A[15]==B[15])&&(result[15]!=A[15])) || ((op == SUB) && ((A[15]!=B[15])&&(result[15]==B[15]))))
	v = 1'b1; 
	else v = 1'b0;
	
	end
	
endmodule	

