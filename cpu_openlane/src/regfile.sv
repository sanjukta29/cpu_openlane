// 16 bit  regfile- 2 read ports, 1 write port 
// 13 entries - 12 regs and SP
`timescale 1ps/1ps 

module regfile (
        input clk,rst, we,
		input logic [15:0] wd, // write data
		input logic [3:0] ra1,ra2,wa, // addresses
		output logic [15:0] rd1, rd2 // read data 1 and 2
		); 
		
    reg [15:0]  regFile [0:13]; 
	  // word width    // no of words = 0 to 13 with SP
	
	always_ff @(posedge clk) begin
	if(rst)
	begin
	 for(int i=0;i<13;i=i+1)
	 begin
	  regFile[i] <= '0;
	  end
	  regFile[13] <=16'hFFFF; // for SP
   end
	else if(we) // write 
	 regFile[wa] <= wd;
	end 
			
			// read
	assign rd1 = regFile[ra1];
	assign rd2 = regFile[ra2];
	
endmodule	

