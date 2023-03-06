//shifter with 4 different types

`timescale 1ps/1ps 
// add carry here 
module shifter (
        
		input logic signed  [15:0] in, // input data
		input logic [3:0] amount, //shift amount - should be only bottom 4 bits - compared with orignal ISA
		input logic [1:0] s_type, // shift type 
		output logic [15:0] out,// read data 1 and 2
		output logic c
		); 
		
	enum {LSLS,LSRS,ASRS,RORS} stypes;
	logic out_t;
    	
	always_comb begin
	case(s_type)
	LSLS: {c,out} = in<<amount; //  pad z 
	LSRS: {out,c} = {1'b0,in>>(amount-1)};
	ASRS: {out,c} = in>>>(amount-1); // pad s
	RORS: 
	begin 
	//out_t = data_in>>amount;        // pad circle 
	//out = {data_in[amount -1 :0],out_t[15-amount:0]};
	 case (amount)
      15: out = {in[14:0],in[15]};	 
	  14 : out = {in[13:0], in[15:14]};
      13: out = {in[12:0], in[15:13]};
      12 : out = {in[11:0], in[15:12]};
      11 : out = {in[10:0], in[15:11]};
      10 : out = {in[9:0], in[15:10]};
      9 : out = {in[8:0], in[15:9]};
      8 : out = {in[7:0], in[15:8]};
      7 : out = {in[6:0], in[15:7]};
      6 : out = {in[5:0], in[15:6]};
      5 : out = {in[4:0], in[15:5]};
      4 : out = {in[3:0], in[15:4]};
      3 : out = {in[2:0], in[15:3]};
      2 : out = {in[1:0], in[15:2]};
      1 : out = {in[0], in[15:1]};
      0 : out =        in[15:0];
	  default: out = in;
    endcase
	c= out[15];
	end
	default: out=0;
	endcase 
	end
	
endmodule	

