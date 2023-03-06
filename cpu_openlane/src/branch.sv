// accelerated branches 
// takes in instr from IMem
// takes flags from execution for conditional  branches
// outputs control signals for PC ONLY

module branch(
    input logic [15:0] instr,
    //input logic N,C,Z,V, // flags
    input logic n_,c_,z_,v_,
    input logic [4:0] opcode_prev, //not used
    //output logic n_update, z_update, c_update, v_update, Reg1Loc, Reg2Loc, RegWrite, MemWrite, lr_sel, c_sel,
    output logic [2:0] pc_mux,
    output logic [15:0] im6,im11,im8_pc,
    output logic lr_sel,
    output logic flush
);

logic [3:0] cond;
logic [4:0] opcode;
//logic n_,c_,z_,v_;
logic bx_stall,bx_reg_sel;

//pc_mux, n_update, z_update, c_update, v_update, Reg1Loc, Reg2Loc, RegWrite, MemWrite, shift_type, sp_sel, lr_sel,

/// assign values from instr
assign im6 = {{10{instr[5]}},instr[5:0]};
assign im8_pc = {{8{instr[7]}},instr[7:0]}; // sign extend
assign im11 = {{5{instr[10]}},instr[10:0]};

//assign rd_mov
always_comb begin

    //forwarding? // 
    /*if (opcode_prev==5'd9) // use current flags if ongoing instr in exec is CMP, else use registered flag
    begin
    n_ = N;
    c_ = C;
    z_ = Z;
    v_ = V;
    end
    else
    n_ = n__;
    c_ = c__;
    z_ = z__;
    v_ = v__;*/
    
    
    if (instr[15:11]==5'd4) //MOVS Rd,# imm8 , N,Z
    begin 
    opcode = 5'd1;
    
    // control signals 
    pc_mux = 3'b0;
    flush = 1'b0;
    lr_sel = 1'b0;
    bx_stall = 1'b0;
    bx_reg_sel = 1'b0;
    end
    
    else if (instr[15:7]==9'd140) //MOV Rd,Rm
    begin
    opcode = 5'd2;
    
    // control signals 
    pc_mux = 3'b0;
    flush = 1'b0;    
    lr_sel = 1'b0;
    bx_stall = 1'b0;
    bx_reg_sel = 1'b0;
    end
    
    else if (instr[15:9]==7'd14) //ADDS Rd,Rn, #im3 NZCV
    begin
    opcode = 5'd3;
    
    // control signals 
    pc_mux = 3'b0;
    flush = 1'b0;
    lr_sel = 1'b0;
    bx_stall = 1'b0;
    bx_reg_sel = 1'b0;
    end
    
    else if (instr[15:9]==7'd12) //ADDS Rd,Rn,Rm NZCV
    begin
    opcode = 5'd4;
    
    // control signals 
    flush = 1'b0;
    pc_mux = 3'b0;
    lr_sel = 1'b0;
    bx_stall = 1'b0;
    bx_reg_sel = 1'b0;
    end
    
    else if (instr[15:7]==9'd352) //ADD SP,SP, #im7
    begin
    opcode = 5'd5;
    flush = 1'b0;
    // control signals 
    pc_mux = 3'b0;
    lr_sel = 1'b0;
    bx_stall = 1'b0;
    bx_reg_sel = 1'b0;
    end
    
    else if (instr[15:9]==7'd13) //SUBS Rd,Rn,Rm NZCV
    begin
    opcode = 5'd6;
    flush = 1'b0;
    // control signals 
    pc_mux = 3'b0;
    lr_sel = 1'b0;
    bx_stall = 1'b0;
    bx_reg_sel = 1'b0;
    end
    
    else if (instr[15:9]==7'd15) //SUBS Rd,Rn,im3 NZCV
    begin
    opcode = 5'd7;
    flush = 1'b0;
    // control signals 
    pc_mux = 3'b0;
    lr_sel = 1'b0;
    bx_stall = 1'b0;
    bx_reg_sel = 1'b0;
    end
    
    else if (instr[15:7]==9'd353) //SUB SP,SP, #im7
    begin
    opcode = 5'd8;
    flush = 1'b0;
    // control signals 
    pc_mux = 3'b0;
    lr_sel = 1'b0;
    bx_stall = 1'b0;
    bx_reg_sel = 1'b0;
    end
    
    else if (instr[15:6]==10'd266) // CMP Rn,Rm NZCV
    begin
    opcode = 5'd9;
    flush = 1'b0;
    // control signals 
    pc_mux = 3'b0;
    lr_sel = 1'b0;
    bx_stall = 1'b0;
    bx_reg_sel = 1'b0;
    end
    
    else if (instr[15:6]==10'd256) //ANDS Rd,Rm NZ
    begin
    opcode = 5'd10;
    flush = 1'b0;
    // control signals 
    pc_mux = 3'b0;
    lr_sel = 1'b0;
    bx_stall = 1'b0;
    bx_reg_sel = 1'b0;
    end
    
    else if (instr[15:6]==10'd257) //EORS Rd,Rm NZ
    begin
    opcode = 5'd11;
    flush = 1'b0;
    // control signals 
    pc_mux = 3'b0;
    lr_sel = 1'b0;
    bx_stall = 1'b0;
    bx_reg_sel = 1'b0;
    end
    
    else if (instr[15:6]==10'd268) //ORRS Rd,Rm NZ
    begin
    opcode = 5'd12;
    flush = 1'b0;
    // control signals 
    pc_mux = 3'b0;
    lr_sel = 1'b0;
    bx_stall = 1'b0;
    bx_reg_sel = 1'b0;
    end
    
    else if (instr[15:6]==10'd271) // MVNS Rd,Rm NZ
    begin
    opcode = 5'd13;
    flush = 1'b0;
    // control signals 
    pc_mux = 3'b0;
    lr_sel = 1'b0;
    bx_stall = 1'b0;
    bx_reg_sel = 1'b0;
    end
    
    else if (instr[15:6]==10'd258) // LSLS Rd, Rd, Rm NZC
    begin
    opcode = 5'd14;
    flush = 1'b0;
    // control signals 
    pc_mux = 3'b0;
    lr_sel = 1'b0;
    bx_stall = 1'b0;
    bx_reg_sel = 1'b0;
    end
    
    else if (instr[15:6]==10'd259) // LSRS Rd, Rd, Rm NZC
    begin
    opcode = 5'd15;
    flush = 1'b0;
    // control signals 
    pc_mux = 3'b0;
    lr_sel = 1'b0;
    bx_stall = 1'b0;
    bx_reg_sel = 1'b0;
    end
    
    else if (instr[15:6]==10'd260) // ASRS Rd, Rd, Rm NZC
    begin
    opcode = 5'd16;
    flush = 1'b0;
    // control signals 
    pc_mux = 3'b0;
    lr_sel = 1'b0;
    bx_stall = 1'b0;
    bx_reg_sel = 1'b0;
    end
    
    else if (instr[15:6]==10'd263) // RORS Rd, Rd, Rm NZC
    begin
    opcode = 5'd17;
    flush = 1'b0;
    // control signals 
    pc_mux = 3'b0;
    lr_sel = 1'b0;
    bx_stall = 1'b0;
    bx_reg_sel = 1'b0;
    end
    
    else if (instr[15:11]==5'd12) // STR Rd, [Rn, #<im5>]
    begin
    opcode = 5'd18;
    flush = 1'b0;
    // control signals 
    pc_mux = 3'b0;
    lr_sel = 1'b0;
    bx_stall = 1'b0;
    bx_reg_sel = 1'b0;
    end
    
    else if (instr[15:11]==5'd13) // LDR Rd, [Rn, #<im5>] 
    begin
    opcode = 5'd19;
    flush = 1'b0;
    // control signals 
    pc_mux = 3'b0;
    lr_sel = 1'b0;
    bx_stall = 1'b0;
    bx_reg_sel = 1'b0;
    end
    
    else if (instr[15:12]==4'd13) // B<cc> <label> CONDITONAL BRANCHES
    begin
        opcode = 5'd20;
        cond = instr[11:8];
        lr_sel = 1'b0;
        bx_stall = 1'b0;
        bx_reg_sel = 1'b0;
        //conditions
        case(cond)
            4'd0: if(z_==1) pc_mux = 3'd1; else pc_mux = 3'd0; //EQ
            4'd1: if(z_==0) pc_mux = 3'd1; else pc_mux = 3'd0; //NE
            4'd2: if(c_==1) pc_mux = 3'd1; else pc_mux = 3'd0; //CS
            4'd3: if(c_==0) pc_mux = 3'd1; else pc_mux = 3'd0; //CC
            4'd4: if(n_==1) pc_mux = 3'd1; else pc_mux = 3'd0; //MI
            4'd5: if(n_==0) pc_mux = 3'd1; else pc_mux = 3'd0; //PL
            4'd6: if(v_==1) pc_mux = 3'd1; else pc_mux = 3'd0; //VS
            4'd7: if(v_==0) pc_mux = 3'd1; else pc_mux = 3'd0; //VC
            4'd8: if(c_==1 & z_==0) pc_mux = 3'd1; else pc_mux = 3'd0; //HI
            4'd9: if(c_==0 | z_==1) pc_mux = 3'd1; else pc_mux = 3'd0; //LS
            4'd10: if(n_==v_) pc_mux = 3'd1; else pc_mux = 3'd0; //GE
            4'd11: if(~(n_)==v_) pc_mux = 3'd1; else pc_mux = 3'd0; //LT
            4'd12: if(z_==0 & n_==v_) pc_mux = 3'd1; else pc_mux = 3'd0; //GT
            4'd13: if(z_==1 | ~(n_)==v_) pc_mux = 3'd1; else pc_mux = 3'd0; //LE
            4'd14: pc_mux = 3'd1;  //AL
        default : pc_mux = 3'd0;
        endcase
        flush = pc_mux[0];
    end
    
    else if (instr[15:11]==5'd28) // B<label>
    begin
    opcode = 5'd21;
    // control signals 
    pc_mux = 3'd2; //im11
    lr_sel = 1'b0;
    bx_stall = 1'b0;
    bx_reg_sel = 1'b0;
    flush = 1'b1;
    end
    
    else if (instr[15:6]==10'd276) // BL <label>
    begin
        opcode = 5'd22;
        // control signals 
        pc_mux = 3'd3; //im11
        lr_sel = 1'b1; //update lr
        bx_stall = 1'b0;
        bx_reg_sel = 1'b0;
        flush = 1'b1;
    end
    
    else if (instr[15:7]==9'd142) // BX Rm
    begin
    opcode = 5'd23;
    //change here
    pc_mux = 3'd6;//6
    flush = 1'b1;
    
    //if(instr[6:3]==4'd14) // sending LR or regfile out to pc
    //bx_reg_sel = 1'b1;
    //else bx_reg_sel = 1'b0;
    
    lr_sel = 1'b0;
    bx_stall = 1'b0; //insert special NOOP
    //if(instr[6:3]==4'd14) // LR
    //pc_mux=3'd5;
    //else pc_mux = 3'd4;
    //lr_sel = 1'b0;
    
    end
    
    else if (instr==16'd48896) // NOOP
    begin
    opcode = 5'd24;
    // control signals 
    pc_mux = 3'd0;
    lr_sel = 1'b0;
    bx_stall = 1'b0;
    bx_reg_sel = 1'b0;
    
    end
    
    else if (instr==16'd48897) // STALL FOR BX
    begin
        opcode = 5'd26;
        // control signals 
        pc_mux = 3'd4;
        lr_sel = 1'b0;
        //bx_stall = 1'b0;
        bx_reg_sel = 1'b0;
        flush = 1'b1;
    end
    
    else begin
        opcode = 5'd25;
        // control signals 
        pc_mux = 3'd0;
        lr_sel = 1'b0;
        bx_stall = 1'b0;
        bx_reg_sel = 1'b0;
        flush = 1'b0;
    end
end

endmodule

// add else all 0

// if (opcode=bx) bx_stall = 1 else bx_stall=0
