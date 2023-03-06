// 16 bit ARM M0 CPU
`timescale 1ps/1ps 

module cpu (
		input logic clk,rst
        //output logic N,Z,C,V
        );
		

// from idecode 
 //logic [15:0] instr;
logic N,C,Z,V; // flags
logic n_update, z_update, c_update, v_update, Reg1Loc, Reg2Loc, RegWrite, MemWrite, lr_sel,c_sel;
logic [2:0] ALU_src, ALU_op;
logic [2:0] pc_mux,out_sel;
logic [1:0] shift_type;
logic [3:0] Rd; // widths?
logic [3:0] Rm;
logic [3:0] Rn;
logic [15:0] im8,im3,im7,im5,im6,im11,im8_pc;
logic [4:0] opcode;

//flush decode and fetch
logic flush;

 // regfile
logic [3:0] ra1_in,ra2_in;
logic [15:0] rd1,rd2,rd1_rf,rd2_rf,rd_pc;
 //alu 
logic [15:0] alu_out, alu_b_in;
logic alu_c,alu_v;
//shifter
logic [15:0] shift_out;

 // data mem
logic [15:0] dm_out;

// IR, SP, LR
logic [15:0] IR, SP, LR,IR_;
    logic [15:0] PC, PC_EX;

// output of mux 
logic[15:0] out,out_EX;

//for bx
logic bx_reg_sel,bx_stall;

logic [1:0] forward_a, forward_b;

logic [15:0] PC_reg, IR_reg, LR_reg;

// DECODE pipe regs
reg [15:0] IR_DEC, LR_DEC, PC_DEC;

// EX pipe regs
logic  RegWrite_EX, MemWrite_EX;
logic [15:0] rd1_EX,rd2_EX;
logic [3:0] Rd_EX;
logic [2:0] ALU_op_EX, ALU_src_EX,out_sel_EX;
logic [15:0]im3_EX, im5_EX, im7_EX, im8_EX;
logic[1:0] shift_type_EX;
logic [4:0] opcode_EX;
logic [15:0] IR_EX;
logic n_update_EX, z_update_EX, c_update_EX, v_update_EX, c_sel_EX;
logic [15:0] LR_EX;
//logic [15:0] alu_out_EX, shift_out_EX;

// MEM pipe regs
logic  RegWrite_MEM, MemWrite_MEM;
logic [15:0] rd1_MEM,rd2_MEM;
logic [3:0] Rd_MEM;
logic [2:0] out_sel_MEM;
logic [15:0] im8_MEM;
logic [4:0] opcode_MEM;
logic [15:0] IR_MEM;
logic [15:0] alu_out_MEM, shift_out_MEM, out_MEM;

// WB pipe regs
logic  RegWrite_WB;
logic [15:0] rd1_WB,rd2_WB;
logic [3:0] Rd_WB;
logic [2:0] out_sel_WB;
logic [15:0] im8_WB;
logic [4:0] opcode_WB;
logic [15:0] IR_WB;
logic [15:0] alu_out_WB, shift_out_WB,dm_out_WB;

//INSTRUCTION MEMORY???
//addr = PC_reg, out = IR

inst_mem im(clk, rst, PC_reg, IR_);//IR ->out


idecode id (
    IR_DEC, //instr,
    //N,C,Z,V,
   // n_,c_,z_,v_,
    n_update, z_update, c_update, v_update, Reg1Loc, Reg2Loc, RegWrite, MemWrite,  c_sel,
    ALU_src, ALU_op,
    out_sel,
    shift_type,//sp_sel,
    Rd,
    Rm,
    Rn,
    im8,im3,im7,im5,opcode,bx_stall,bx_reg_sel
);

branch br(
    IR_EX,
    N,C,Z,V, // flags
   // n_,c_,z_,v_,
    opcode,
    //output logic n_update, z_update, c_update, v_update, Reg1Loc, Reg2Loc, RegWrite, MemWrite, lr_sel, c_sel,
    pc_mux,
    im6,im11,im8_pc,
    lr_sel,//,bx_reg_sel//,bx_stall
    flush
);


regfile rf(~clk,rst, RegWrite_WB, out, ra1_in, ra2_in, Rd_WB, rd1_rf, rd2_rf);

alu alu(rd1_EX, alu_b_in, ALU_op_EX, alu_out, alu_c, alu_v);

shifter shift(rd2_EX, rd1_EX[3:0], shift_type_EX, shift_out, shift_c); 

// change out here - only alu/shift/mov 
flag_calc fc(clk, out_EX, alu_c,shift_c,alu_v,n_update_EX,c_update_EX,z_update_EX,v_update_EX, c_sel_EX,N,C,Z,V,n_,c_,z_,v_); 

// DATA MEMORY ???
// Din = rd2  ,   addr = alu_out,  we = MemWrite,,  dm_out 

data_mem dm(clk, rst, MemWrite_MEM, rd2_MEM, alu_out_MEM, dm_out);

//forwarding (forward_a,forward_b,addr_a,addr_b,dest_ex,regwr_ex,dest_mem,regwr_mem);
forwarding f(forward_a,forward_b,ra1_in,ra2_in,Rd_EX,RegWrite_EX,Rd_MEM,RegWrite_MEM);

 always_comb begin

  //lr mux
 if(lr_sel)
    LR = PC_reg + 16'd1;
 else LR = LR_reg;

// regfile muxes

if(Reg1Loc)
ra1_in = Rm;
else ra1_in = Rn;

if(Reg2Loc)
ra2_in = Rd;
else ra2_in = Rm;

//ALU mux
case (ALU_src_EX)
	2'd0: alu_b_in = rd2_EX;
	2'd1: alu_b_in = im3_EX;
	2'd2: alu_b_in = im5_EX;
	2'd3: alu_b_in = im7_EX;
	default: alu_b_in = rd2_EX;
endcase

// output mux WB
case(out_sel_WB)
	3'd0: out = rd2_WB; 
	3'd1: out = alu_out_WB; 
	3'd2: out = im8_WB;
	3'd3: out = shift_out_WB; 
	3'd4: out = dm_out_WB; 
	3'd5: out =LR_reg; // LR
	default: out = alu_out_WB;   
endcase

case(out_sel_EX)
	3'd0:  out_EX = rd2_EX; 
	3'd1:  out_EX = alu_out; 
	3'd2: out_EX = im8_EX;
	3'd3: out_EX = shift_out;
	//3'd4: out = dm_out; // fix 
	//3'd5: out =LR_reg; // LR
	default: out_EX = alu_out; 
endcase

//forwarding mux A before regs in Decode stage
case (forward_a)
	2'd0: rd1 = rd1_rf;
	2'd1: rd1 = out_EX; //alu/rd2/shift
	2'd2: rd1 = out_MEM;
	default: rd1 = rd1_rf;
endcase

//forwarding mux B before regs in Decode stage
case (forward_b)
	2'd0: rd2 = rd2_rf;
	2'd1: rd2 = out_EX; //alu/rd2/shift
	2'd2: rd2 = out_MEM;
	default: rd2 = rd2_rf;
endcase

//instruction 
// insert mux for IR -bx_stall
if(bx_stall)
	IR = 16'b1011111100000001; //noop
else 
	IR = IR_; //from imem // not sure abt reg*/

if(bx_reg_sel)
	rd_pc = LR_reg;
else
	rd_pc=rd2;

//PC_reg -> current, PC -> next
 // pc mux
  case (pc_mux)
 	3'd0: PC = PC_reg + 16'd1;
 	3'd1: PC = PC_EX + im8_pc;
 	3'd2: PC = PC_EX + im11; //pc_reg
 	3'd3: PC = PC_EX + im6;
 	3'd4: PC = rd_pc; // coming from regfile
 	3'd5: PC = LR_EX;
 	3'd6: PC = PC_reg;
 	default : PC = PC_EX;
 endcase

 end

//PC
always_ff@(posedge clk or posedge rst)  
 begin   
      if(rst)   
      begin
           PC_reg <= 16'd0; 
           LR_reg <= 16'd0;
           IR_reg <= 16'd0;

           IR_DEC <= 16'b0;
           PC_DEC <= 16'b0;

           PC_EX <= 16'd0;
           LR_EX <= 16'd0;

           RegWrite_EX <='0;
           MemWrite_EX <='0;
           rd1_EX <='0;
           rd2_EX <='0;
           Rd_EX <='0;
           ALU_op_EX <='0;
           ALU_src_EX <='0;
           out_sel_EX <='0;
           im3_EX<='0;
           im5_EX <='0;
           im7_EX <='0;
           im8_EX <='0;
           shift_type_EX <='0;
           opcode_EX <='0;
           IR_EX <='0;
           
           
           RegWrite_MEM <='0;
           MemWrite_MEM <='0;
           rd1_MEM <='0;
           rd2_MEM <='0;
           Rd_MEM <='0;
           out_sel_MEM <='0;
           im8_MEM <='0;
           opcode_MEM<='0;
           IR_MEM <='0;
           alu_out_MEM <='0;
           shift_out_MEM <='0;

           RegWrite_WB <='0;
           rd1_WB <='0;
           rd2_WB <='0;
           Rd_WB <='0;
           out_sel_WB <='0;
           im8_WB <='0;
           opcode_WB<='0;
           IR_WB <='0;
           alu_out_WB <='0;
           shift_out_WB <='0;

           end
      else if(flush) begin
           PC_reg <= PC; 
           IR_reg <= 16'd0;

           PC_DEC <= PC_reg;
           IR_DEC <= 16'b0;

           PC_EX <= PC_DEC;

           IR_EX <= 16'b0;

           //LR_reg <= 16'd0;
    
           LR_EX <= IR_reg;

           RegWrite_EX <='0;
           MemWrite_EX <='0;
           rd1_EX <='0;
           rd2_EX <='0;
           Rd_EX <='0;
           ALU_op_EX <='0;
           ALU_src_EX <='0;
           out_sel_EX <='0;
           im3_EX<='0;
           im5_EX <='0;
           im7_EX <='0;
           im8_EX <='0;
           shift_type_EX <='0;
           opcode_EX <='0;
      end
      else  
      begin
           PC_reg <= PC;
           LR_reg <= LR;
           //IR_reg <= IR;

           PC_DEC<= PC_reg;
           IR_DEC <= IR; 

           PC_EX <=PC_DEC;
           RegWrite_EX <= RegWrite;
           MemWrite_EX <= MemWrite;
           rd1_EX <= rd1;
           rd2_EX <= rd2;
           Rd_EX <= Rd;
           ALU_op_EX <= ALU_op;
           ALU_src_EX <= ALU_src;
           out_sel_EX <= out_sel;
           im3_EX <= im3;
           im5_EX <= im5;
           im7_EX <= im7;
           im8_EX <= im8;
           shift_type_EX <=shift_type;
           opcode_EX <= opcode;
           IR_EX <= IR_DEC;
           n_update_EX <= n_update;
           z_update_EX <= z_update;
           c_update_EX <= c_update;
           v_update_EX <= v_update;
           c_sel_EX <= c_sel;
          
           RegWrite_MEM <= RegWrite_EX;
           MemWrite_MEM <= MemWrite_EX;
           rd1_MEM <= rd1_EX;
           rd2_MEM <= rd2_EX;
           Rd_MEM <= Rd_EX;
           out_sel_MEM <= out_sel_EX;
           im8_MEM <= im8_EX;
           opcode_MEM<= opcode_EX;
           IR_MEM <= IR_EX;
           alu_out_MEM <= alu_out;
           shift_out_MEM <= shift_out;
           out_MEM <= out_EX;

           RegWrite_WB <= RegWrite_MEM;
           rd1_WB <= rd1_MEM;
           rd2_WB <= rd2_MEM;
           Rd_WB <= Rd_MEM;
           out_sel_WB <= out_sel_MEM;
           im8_WB <= im8_MEM;
           opcode_WB <= opcode_MEM;
           IR_WB <= IR_MEM;
           alu_out_WB <= alu_out_MEM;
           shift_out_WB <= shift_out_MEM;
           dm_out_WB <= dm_out;
           end
 end  


// make registers for all control statements
// option to insert noop
// branch logic? - accelerated branch 
// forwarding

// IF - read inst mem
// ID - Decode and register read
// EX - Execute ALU
// MEM - Memory read/write
// WB - Register write 


endmodule	

