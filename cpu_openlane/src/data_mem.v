// DATA MEMORY
module data_mem (
	input  	      Clock,
	input 	      reset,   
	input         write_en,
	input  [15:0] data_in,
	input  [ 15:0] address,
	output [15:0] data_out

);

//RAM_16B_512 DATA_MEM (.Q(data_out), .CLK(Clock), .CEN(reset), .WEN(write_en), .A(address[8:0]), .D(data_in));

//post apr
//RAM_16B_512 DATA_MEM (.Q(data_out), .CLK(Clock), .CEN(reset), .WEN(write_en), .A(address[8:0]), .D(data_in), .EMA(3'd2), .EMAW(2'd0), .EMAS(1'd0), .RET1N(1'd1));



// ee 541 

sky130_sram_16_512 DATA_MEM(
// Port 0: W  
    .clk0(Clock),.csb0(~write_en),.addr0(address[8:0]),.din0(data_in),
// Port 1: R
    .clk1(Clock),.csb1(~write_en),.addr1(address[8:0]),.dout1(data_out)
  );


//RAM_16B_512_AR1_LP DATA_MEM(.Q(data_out), .CLK(Clock), .CEN(reset), .WEN(write_en), .A(address[8:0]), .D(data_in), .EMA(3'd2), .EMAW(2'd0), .EMAS(1'd0), .RET1N(1'd1));

endmodule

// ADD MEMORY FOR SAPR 
//module RAM_16B_512_AR1_LP (Q, CLK, CEN, WEN, A, D, EMA, EMAW, EMAS, RET1N);