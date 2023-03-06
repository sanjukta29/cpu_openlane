// INSTRUCTION DECODE
// takes in instr from IR 
// takes flags for cond br
// outputs control signals
// Also inserts special NOOP for BX to ensure pc increment using current regfile value

module idecode(
    input logic [15:0] instr,
    //input logic N,C,Z,V, // flags
    //input logic n_,c_,z_,v_,
    output logic n_update, z_update, c_update, v_update, Reg1Loc, Reg2Loc, RegWrite, MemWrite, c_sel,
    output logic [2:0] ALU_src, ALU_op,
    output logic [2:0] out_sel,
    output logic [1:0] shift_type,//sp_sel,
    output logic [3:0] Rd, // widths?
    output logic [3:0] Rm,
    output logic [3:0] Rn,
    output logic [15:0] im8,im3,im7,im5,
    output logic [4:0] opcode,
    output logic bx_stall,bx_reg_sel
);

logic [3:0] cond;
//pc_mux, n_update, z_update, c_update, v_update, Reg1Loc, Reg2Loc, RegWrite, MemWrite, shift_type, sp_sel, lr_sel,

// assign values from instr
assign im8 = {8'b0,instr[7:0]};
assign im7 = {9'b0,instr[6:0]};
assign im3 = {13'b0,instr[8:6]};
assign im5 = {11'b0,instr[10:6]};

//assign im6 = {{10{instr[5]}},instr[5:0]};
//assign im8_pc = {{8{instr[7]}},instr[7:0]}; // sign extend
//assign im11 = {{5{instr[10]}},instr[10:0]};
//assign rd_mov
always_comb begin
bx_stall = 1'b0; //
bx_reg_sel = 1'b0;

Rd = 4'd0;
Rn = 4'd0;
Rm = 4'd0;
if (instr[15:11]==5'd4) //MOVS Rd,# imm8 , N,Z
begin 
opcode = 5'd1;
Rd = {1'b0,instr[10:8]};
// control signals 
//pc_mux = 1'b0;
n_update = 1'b1;
z_update = 1'b1;
c_update = 1'b0;
v_update = 1'b0;
Reg1Loc = 1'b0; //x
Reg2Loc = 1'b0; //x
RegWrite = 1'b1;
ALU_src =  3'b0;//x
ALU_op = 3'b0;//x
MemWrite = 1'b0;
out_sel = 3'd2;
shift_type = 2'b0;//x
//sp_sel = 2'b0;
//lr_sel = 1'b0;
c_sel = 1'b0;
end

else if (instr[15:7]==9'd140) //MOV Rd,Rm
begin
opcode = 5'd2;
Rm = instr[6:3];
Rd = {1'b0,instr[2:0]};
if(Rm==4'd14)
out_sel = 3'd5; // for LR
else 
out_sel = 3'd0;
// control signals 
//pc_mux = 1'b0;
n_update = 1'b0;
z_update = 1'b0;
c_update = 1'b0;
v_update = 1'b0;
Reg1Loc = 1'b0; //x
Reg2Loc = 1'b0; 
RegWrite = 1'b1;
ALU_src =  3'b0;//x
ALU_op = 3'b0;//x
MemWrite = 1'b0;

shift_type = 2'b0;//x
//sp_sel = 2'b0;
//lr_sel = 1'b0;
c_sel = 1'b0;
end

else if (instr[15:9]==7'd14) //ADDS Rd,Rn, #im3 NZCV
begin
opcode = 5'd3;
Rn = {1'b0,instr[5:3]};
Rd = {1'b0,instr[2:0]};
// control signals 
//pc_mux = 1'b0;
n_update = 1'b1;
z_update = 1'b1;
c_update = 1'b1;
v_update = 1'b1;
Reg1Loc = 1'b0; 
Reg2Loc = 1'b0; //x
RegWrite = 1'b1;
ALU_src =  3'd1;
ALU_op = 3'b0;
MemWrite = 1'b0;
out_sel = 3'd1;
shift_type = 2'b0;//x
//sp_sel = 2'b0;
//lr_sel = 1'b0;
c_sel = 1'b0;
end

else if (instr[15:9]==7'd12) //ADDS Rd,Rn,Rm NZCV
begin
opcode = 5'd4;
Rn = {1'b0,instr[5:3]};
Rd = {1'b0,instr[2:0]};
Rm = {1'b0,instr[8:6]};
// control signals 
//pc_mux = 1'b0;
n_update = 1'b1;
z_update = 1'b1;
c_update = 1'b1;
v_update = 1'b1;
Reg1Loc = 1'b0; 
Reg2Loc = 1'b0; 
RegWrite = 1'b1;
ALU_src =  3'd0;
ALU_op = 3'b0;
MemWrite = 1'b0;
out_sel = 3'd1;
shift_type = 2'b0;//x
//sp_sel = 2'b0;
//lr_sel = 1'b0;
c_sel = 1'b0;
end

else if (instr[15:7]==9'd352) //ADD SP,SP, #im7
begin
opcode = 5'd5;
Rd = 4'd13;
Rm = 4'd13;
// control signals 
//pc_mux = 1'b0;
n_update = 1'b0;
z_update = 1'b0;
c_update = 1'b0;
v_update = 1'b0;
Reg1Loc = 1'b1;
Reg2Loc = 1'b0; //x
RegWrite = 1'b1;
ALU_src =  3'd3;  //im7
ALU_op = 3'b0; //add
MemWrite = 1'b0;
out_sel = 3'd1; 
shift_type = 2'b0;//x
//sp_sel = 2'b1;
//lr_sel = 1'b0;
c_sel = 1'b0;
end

else if (instr[15:9]==7'd13) //SUBS Rd,Rn,Rm NZCV
begin
opcode = 5'd6;
Rn = {1'b0,instr[5:3]};
Rd = {1'b0,instr[2:0]};
Rm = {1'b0,instr[8:6]};
// control signals 
//pc_mux = 1'b0;
n_update = 1'b1;
z_update = 1'b1;
c_update = 1'b1;
v_update = 1'b1;
Reg1Loc = 1'b0; 
Reg2Loc = 1'b0; //x
RegWrite = 1'b1;
ALU_src =  3'd0;
ALU_op = 3'b1; // sub
MemWrite = 1'b0;
out_sel = 3'd1;
shift_type = 2'b0;//x
//sp_sel = 2'b0; 
//lr_sel = 1'b0;
c_sel = 1'b0;
end

else if (instr[15:9]==7'd15) //SUBS Rd,Rn,im3 NZCV
begin
opcode = 5'd7;
Rn = {1'b0,instr[5:3]};
Rd = {1'b0,instr[2:0]};
Rm = {1'b0,instr[8:6]};
// control signals 
//pc_mux = 1'b0;
n_update = 1'b1;
z_update = 1'b1;
c_update = 1'b1;
v_update = 1'b1;
Reg1Loc = 1'b0; 
Reg2Loc = 1'b0; //x
RegWrite = 1'b1;
ALU_src =  3'd1;
ALU_op = 3'b1;
MemWrite = 1'b0;
out_sel = 3'd1;
shift_type = 2'b0;//x
//sp_sel = 2'b0;
//lr_sel = 1'b0;
c_sel = 1'b0;
end

else if (instr[15:7]==9'd353) //SUB SP,SP, #im7
begin
opcode = 5'd8;
Rd = 4'd13;
Rm = 4'd13;
// control signals 
//pc_mux = 1'b0;
n_update = 1'b0;
z_update = 1'b0;
c_update = 1'b0;
v_update = 1'b0;
Reg1Loc = 1'b1;
Reg2Loc = 1'b0; //x
RegWrite = 1'b1;
ALU_src =  3'd3;  //im7
ALU_op = 3'b1; //sub
MemWrite = 1'b0;
out_sel = 3'd1; 
shift_type = 2'b0;//x
//sp_sel = 2'b1;
//lr_sel = 1'b0;
c_sel = 1'b0;
end

else if (instr[15:6]==10'd266) // CMP Rn,Rm NZCV
begin
opcode = 5'd9;
Rm = {1'b0,instr[5:3]};
Rn = {1'b0,instr[2:0]};
// control signals 
//pc_mux = 1'b0;
n_update = 1'b1;
z_update = 1'b1;
c_update = 1'b1;
v_update = 1'b1;
Reg1Loc = 1'b0; 
Reg2Loc = 1'b0; 
RegWrite = 1'b0;
ALU_src =  3'd0;
ALU_op = 3'b1; // sub
MemWrite = 1'b0;
out_sel = 3'd1;
shift_type = 2'b0;//x
//sp_sel = 2'b0; 
//lr_sel = 1'b0;
c_sel = 1'b0;
end

else if (instr[15:6]==10'd256) //ANDS Rd,Rm NZ
begin
opcode = 5'd10;
Rm = {1'b0,instr[5:3]};
Rd = {1'b0,instr[2:0]};
// control signals 
//pc_mux = 1'b0;
n_update = 1'b1;
z_update = 1'b1;
c_update = 1'b0;
v_update = 1'b0;
Reg1Loc = 1'b1; 
Reg2Loc = 1'b1; 
RegWrite = 1'b1;
ALU_src =  3'd0;
ALU_op = 3'd2; 
MemWrite = 1'b0;
out_sel = 3'd1;
shift_type = 2'b0;//x
//sp_sel = 2'b0; 
//lr_sel = 1'b0;
c_sel = 1'b0;
end

else if (instr[15:6]==10'd257) //EORS Rd,Rm NZ
begin
opcode = 5'd11;
Rm = {1'b0,instr[5:3]};
Rd = {1'b0,instr[2:0]};
// control signals 
//pc_mux = 1'b0;
n_update = 1'b1;
z_update = 1'b1;
c_update = 1'b0;
v_update = 1'b0;
Reg1Loc = 1'b1; 
Reg2Loc = 1'b1; 
RegWrite = 1'b1;
ALU_src =  3'd0;
ALU_op = 3'd4; 
MemWrite = 1'b0;
out_sel = 3'd1;
shift_type = 2'b0;//x
//sp_sel = 2'b0; 
//lr_sel = 1'b0;
c_sel = 1'b0;
end

else if (instr[15:6]==10'd268) //ORRS Rd,Rm NZ
begin
opcode = 5'd12;
Rm = {1'b0,instr[5:3]};
Rd = {1'b0,instr[2:0]};
// control signals 
//pc_mux = 1'b0;
n_update = 1'b1;
z_update = 1'b1;
c_update = 1'b0;
v_update = 1'b0;
Reg1Loc = 1'b1; 
Reg2Loc = 1'b1; 
RegWrite = 1'b1;
ALU_src =  3'd0;
ALU_op = 3'd3; 
MemWrite = 1'b0;
out_sel = 3'd1;
shift_type = 2'b0;//x
//sp_sel = 2'b0; 
//lr_sel = 1'b0;
c_sel = 1'b0;
end

else if (instr[15:6]==10'd271) // MVNS Rd,Rm NZ
begin
opcode = 5'd13;
Rm = {1'b0,instr[5:3]};
Rd = {1'b0,instr[2:0]};
// control signals 
//pc_mux = 1'b0;
n_update = 1'b1;
z_update = 1'b1;
c_update = 1'b0;
v_update = 1'b0;
Reg1Loc = 1'b1; 
Reg2Loc = 1'b0; 
RegWrite = 1'b1;
ALU_src =  3'd0;
ALU_op = 3'd5; 
MemWrite = 1'b0;
out_sel = 3'd1;
shift_type = 2'b0;//x
//sp_sel = 2'b0; 
//lr_sel = 1'b0;
c_sel = 1'b0;
end

else if (instr[15:6]==10'd258) // LSLS Rd, Rd, Rm NZC
begin
opcode = 5'd14;
Rm = {1'b0,instr[5:3]};
Rd = {1'b0,instr[2:0]};
// control signals 
//pc_mux = 1'b0;
n_update = 1'b1;
z_update = 1'b1;
c_update = 1'b1;
v_update = 1'b0;
Reg1Loc = 1'b1; 
Reg2Loc = 1'b1; 
RegWrite = 1'b1;
ALU_src =  3'd0; //x
ALU_op = 3'd0;  //x 
MemWrite = 1'b0; 
out_sel = 3'd3;
shift_type = 2'b0;
//sp_sel = 2'b0; 
//lr_sel = 1'b0;
c_sel = 1'b1;
end

else if (instr[15:6]==10'd259) // LSRS Rd, Rd, Rm NZC
begin
opcode = 5'd15;
Rm = {1'b0,instr[5:3]};
Rd = {1'b0,instr[2:0]};
// control signals 
//pc_mux = 1'b0;
n_update = 1'b1;
z_update = 1'b1;
c_update = 1'b1;
v_update = 1'b0;
Reg1Loc = 1'b1; 
Reg2Loc = 1'b1; 
RegWrite = 1'b1;
ALU_src =  3'd0; //x
ALU_op = 3'd0;  //x 
MemWrite = 1'b0; 
out_sel = 3'd3;
shift_type = 2'b1;
//sp_sel = 2'b0; 
//lr_sel = 1'b0;
c_sel = 1'b1;
end

else if (instr[15:6]==10'd260) // ASRS Rd, Rd, Rm NZC
begin
opcode = 5'd16;
Rm = {1'b0,instr[5:3]};
Rd = {1'b0,instr[2:0]};
// control signals 
//pc_mux = 1'b0;
n_update = 1'b1;
z_update = 1'b1;
c_update = 1'b1;
v_update = 1'b0;
Reg1Loc = 1'b1; 
Reg2Loc = 1'b1; 
RegWrite = 1'b1;
ALU_src =  3'd0; //x
ALU_op = 3'd0;  //x 
MemWrite = 1'b0; 
out_sel = 3'd3;
shift_type = 2'd2;
//sp_sel = 2'b0; 
//lr_sel = 1'b0;
c_sel = 1'b1;
end

else if (instr[15:6]==10'd263) // RORS Rd, Rd, Rm NZC
begin
opcode = 5'd17;
Rm = {1'b0,instr[5:3]};
Rd = {1'b0,instr[2:0]};
// control signals 
//pc_mux = 1'b0;
n_update = 1'b1;
z_update = 1'b1;
c_update = 1'b1;
v_update = 1'b0;
Reg1Loc = 1'b1; 
Reg2Loc = 1'b1; 
RegWrite = 1'b1;
ALU_src =  3'd0; //x
ALU_op = 3'd0;  //x 
MemWrite = 1'b0; 
out_sel = 3'd3;
shift_type = 2'd3;
//sp_sel = 2'b0; 
//lr_sel = 1'b0;
c_sel = 1'b1;
end

else if (instr[15:11]==5'd12) // STR Rd, [Rn, #<im5>]
begin
opcode = 5'd18;
Rn = {1'b0,instr[5:3]};
Rd = {1'b0,instr[2:0]};
// control signals 
//pc_mux = 1'b0;
n_update = 1'b0;
z_update = 1'b0;
c_update = 1'b0;
v_update = 1'b0;
Reg1Loc = 1'b0; 
Reg2Loc = 1'b1; 
RegWrite = 1'b0;
ALU_src =  3'd2; 
ALU_op = 3'd0;   
MemWrite = 1'b1; 
out_sel = 3'd0; //x
shift_type = 2'b0; //x
//sp_sel = 2'b0; 
//lr_sel = 1'b0;
c_sel = 1'b0;
end

else if (instr[15:11]==5'd13) // LDR Rd, [Rn, #<im5>] 
begin
opcode = 5'd19;
Rn = {1'b0,instr[5:3]};
Rd = {1'b0,instr[2:0]};
// control signals 
//pc_mux = 1'b0;
n_update = 1'b0;
z_update = 1'b0;
c_update = 1'b0;
v_update = 1'b0;
Reg1Loc = 1'b0; 
Reg2Loc = 1'b0; //x
RegWrite = 1'b1;
ALU_src =  3'd2; 
ALU_op = 3'd0;   
MemWrite = 1'b0; 
out_sel = 3'd4; 
shift_type = 2'b0; //x
//sp_sel = 2'b0; 
//lr_sel = 1'b0;
c_sel = 1'b0;
end

else if (instr[15:12]==4'd13) // B<cc> <label> CONDITONAL BRANCHES
begin
opcode = 5'd20;
cond = instr[11:8];
// control signals 
//pc_mux = 3'd2; 
n_update = 1'b0;
z_update = 1'b0;
c_update = 1'b0;
v_update = 1'b0;
Reg1Loc = 1'b0; //x
Reg2Loc = 1'b0; //x
RegWrite = 1'b0;
ALU_src =  3'd0; //x 
ALU_op = 3'd0;   //x
MemWrite = 1'b0; 
out_sel = 3'd0; //x
shift_type = 2'b0; //x
//sp_sel = 2'b0; 
//lr_sel = 1'b0;
c_sel = 1'b0;
//conditions
/*case(cond)
4'd0: if(z_==1) pc_mux = 3'd1; else pc_mux = 3'd0; //EQ
4'd1: if(z_==0) pc_mux = 3'd1; else pc_mux = 3'd0; //NE
4'd2: if(c_==1) pc_mux = 3'd1; else pc_mux = 3'd0; //CS
4'd3: if(c_==0) pc_mux = 3'd1; else pc_mux = 3'd0; //CC
4'd4: if(n_==1) pc_mux = 3'd1; else pc_mux = 3'd0; //MI
4'd5: if(n_==0) pc_mux = 3'd1; else pc_mux = 3'd0; //PL
4'd6: if(v_==1) pc_mux = 3'd1; else pc_mux = 3'd0; //VS
4'd7: if(v_==1) pc_mux = 3'd1; else pc_mux = 3'd0; //VC
4'd8: if(c_==1 & z_==1) pc_mux = 3'd1; else pc_mux = 3'd0; //HI
4'd9: if(c_==0 & z_==1) pc_mux = 3'd1; else pc_mux = 3'd0; //LS
4'd10: if(n_==v_) pc_mux = 3'd1; else pc_mux = 3'd0; //GE
4'd11: if(~(n_)==v_) pc_mux = 3'd1; else pc_mux = 3'd0; //LT
4'd12: if(z_==0 & n_==v_) pc_mux = 3'd1; else pc_mux = 3'd0; //GT
4'd13: if(z_==1 | ~(n_)==v_) pc_mux = 3'd1; else pc_mux = 3'd0; //LE
4'd14: pc_mux = 3'd1;  //AL
default : pc_mux = 3'd0;
endcase*/
end

else if (instr[15:11]==5'd28) // B<label>
begin
    opcode = 5'd21;
    // control signals 
    //pc_mux = 3'd2; //im11
    n_update = 1'b0;
    z_update = 1'b0;
    c_update = 1'b0;
    v_update = 1'b0;
    Reg1Loc = 1'b0; //x
    Reg2Loc = 1'b1; //x
    RegWrite = 1'b0;
    ALU_src =  3'd0; //x 
    ALU_op = 3'd0;   //x
    MemWrite = 1'b0; 
    out_sel = 3'd0; //x
    shift_type = 2'b0; //x
    //sp_sel = 2'b0; 
    //lr_sel = 1'b0;
    c_sel = 1'b0;
end

else if (instr[15:6]==10'd276) // BL <label>
begin
    opcode = 5'd22;
    // control signals 
    //pc_mux = 3'd3; //im11
    n_update = 1'b0;
    z_update = 1'b0;
    c_update = 1'b0;
    v_update = 1'b0;
    Reg1Loc = 1'b0; //x
    Reg2Loc = 1'b1; //x
    RegWrite = 1'b0;
    ALU_src =  3'd0; //x 
    ALU_op = 3'd0;   //x
    MemWrite = 1'b0; 
    out_sel = 3'd0; //x
    shift_type = 2'b0; //x
    //sp_sel = 2'b0; 
    //lr_sel = 1'b1; //update lr
    c_sel = 1'b0;
end

else if (instr[15:7]==9'd142) // BX Rm
begin
opcode = 5'd23;
Rm = instr[6:3];
if(instr[6:3]==4'd14) // sending LR or regfile out to pc
bx_reg_sel = 1'b1;
else bx_reg_sel = 1'b0;
//if(instr[6:3]==4'd14) // LR
//pc_mux=3'd5;
//else pc_mux = 3'd4;
// control signals 
//pc_mux = 3'd2; 
n_update = 1'b0;
z_update = 1'b0;
c_update = 1'b0;
v_update = 1'b0;
Reg1Loc = 1'b0; //x
Reg2Loc = 1'b0; 
RegWrite = 1'b0;
ALU_src =  3'd0; //x 
ALU_op = 3'd0;   //x
MemWrite = 1'b0; 
out_sel = 3'd0; //x
shift_type = 2'b0; //x
//sp_sel = 2'b0; 
//lr_sel = 1'b0;
c_sel = 1'b0;
bx_stall = 1'b1;

end

else if (instr==16'd48896) // NOOP
begin
opcode = 5'd24;
// control signals 
//pc_mux = 3'd0;
n_update = 1'b0;
z_update = 1'b0;
c_update = 1'b0;
v_update = 1'b0;
Reg1Loc = 1'b0; //x
Reg2Loc = 1'b0; //x
RegWrite = 1'b0;
ALU_src =  3'd0; //x 
ALU_op = 3'd0;   //x
MemWrite = 1'b0; 
out_sel = 3'd0; //x
shift_type = 2'b0; //x
//sp_sel = 2'b0; 
//lr_sel = 1'b0;
c_sel = 1'b0;
end

else if (instr==16'd48897) // STALL FOR BX
begin
opcode = 5'd26;
// control signals 
//pc_mux = 3'd0;
n_update = 1'b0;
z_update = 1'b0;
c_update = 1'b0;
v_update = 1'b0;
Reg1Loc = 1'b0; //x
Reg2Loc = 1'b0; //x
RegWrite = 1'b0;
ALU_src =  3'd0; //x 
ALU_op = 3'd0;   //x
MemWrite = 1'b0; 
out_sel = 3'd0; //x
shift_type = 2'b0; //x
//sp_sel = 2'b0; 
//lr_sel = 1'b0;
c_sel = 1'b0;
end

else 
begin
opcode = 5'd25;
// control signals 
//pc_mux = 3'd6;
n_update = 1'b0;
z_update = 1'b0;
c_update = 1'b0;
v_update = 1'b0;
Reg1Loc = 1'b0; //x
Reg2Loc = 1'b0; //x
RegWrite = 1'b0;
ALU_src =  3'd0; //x 
ALU_op = 3'd0;   //x
MemWrite = 1'b0; 
out_sel = 3'd0; //x
shift_type = 2'b0; //x
//sp_sel = 2'b0; 
//lr_sel = 1'b0;
c_sel = 1'b0;
end
end

endmodule

// add else all 0
