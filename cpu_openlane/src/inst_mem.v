// INSTRUCTION MEMORY
module inst_mem (
	input  	      Clock,
	input 	      reset,   
	//input         write_en,
	//input  [15:0] data_in,
	input  [15:0] address,
	output [15:0] data_out

);

//RAM_16B_512 INST_MEM (.Q(data_out), .CLK(Clock), .CEN(reset), .WEN('0), .A(address[8:0]), .D('0));

//post apr
//RAM_16B_512 INST_MEM (.Q(data_out), .CLK(Clock), .CEN(reset), .WEN('0), .A(address[8:0]), .D('0), .EMA(3'd2), .EMAW(2'd0), .EMAS(1'd0), .RET1N(1'd1));

// EE 541 

sky130_sram_16_512 INST_MEM(
// Port 0: W - never used in imem
    .clk0(Clock),.csb0(1),.addr0('0),.din0('0),
// Port 1: R
    .clk1(Clock),.csb1(reset),.addr1(address[8:0]),.dout1(data_out)
  );

//RAM_16B_512_AR1_LP INST_MEM(.Q(data_out), .CLK(Clock), .CEN(reset), .WEN('0), .A(address[8:0]), .D(data_in), .EMA(3'd2), .EMAW(2'd0), .EMAS(1'd0), .RET1N(1'd1));

endmodule

// ADD MEMORY FOR SAPR, FIX ENABLES 
//module RAM_16B_512_AR1_LP (Q, CLK, CEN, WEN, A, D, EMA, EMAW, EMAS, RET1N);