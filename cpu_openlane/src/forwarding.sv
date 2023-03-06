// forwarding unit 
// checks dest of prev 2 instructions w sources of present inst
// check for X31 cases
module forwarding (forward_a,forward_b,addr_a,addr_b,dest_ex,regwr_ex,dest_mem,regwr_mem);
input logic [3:0] dest_ex; // Dest reg of prev inst - Rd ex
input logic [3:0] dest_mem; // dest reg (Rd) of inst 2 cycles ago - Rd mem 
input logic [3:0] addr_a,addr_b; // sources of present inst
input logic regwr_ex, regwr_mem; // write enables of prev 2 cycles 
output logic [1:0] forward_a, forward_b; // 2 bit control signals to muxes 
// 0 - regfile , 1- ex - 2- mem 

always_comb begin

// for Addr_A (compare source reg a (Rn) - with Rd of prev 2) give priority to dest_ex


// Test this
if((addr_a== dest_ex)&&(regwr_ex==1'b1))
	assign forward_a= 2'd1; // forward ALU value from EX
	
	else if ((addr_a == dest_mem)&&(regwr_mem==1'b1))
	assign forward_a= 2'd2; // forward Mem value 
	
	else 
	assign forward_a=2'd0; // no forwarding

// for Addr_B (compare source reg b (Rm) w Rd of prev 2)

if((addr_b== dest_ex)&&(regwr_ex==1'b1))
	assign forward_b= 2'd1; // forward ALU value from EX
	
	else if ((addr_b == dest_mem)&&(regwr_mem ==1'b1))
	assign forward_b= 2'd2; // forward Mem value 
	
	else 
	assign forward_b=2'd0; // no forwarding

	end 
	
endmodule 

module forwarding_tb();
logic [4:0] dest_ex; // Dest reg of prev inst
logic [4:0] dest_mem; // dest reg (Rd) of inst 2 cycles ago
logic [4:0] addr_a,addr_b; // sources of present inst
logic regwr_ex, regwr_mem; // write enables of prev 2 cycles 
logic [1:0] forward_a, forward_b;

forwarding dut(forward_a,forward_b,addr_a,addr_b,dest_ex,regwr_ex,dest_mem,regwr_mem);
initial 
begin
#10 dest_ex = 5'd31; regwr_ex=1; dest_mem= 5'd20; regwr_mem=1; addr_a= 5'd20; addr_b= 5'd31;
#10 dest_ex = 5'd5; regwr_ex=1; dest_mem= 5'd5; regwr_mem=1; addr_a= 5'd20; addr_b= 5'd5;
#10;

end 

endmodule 
