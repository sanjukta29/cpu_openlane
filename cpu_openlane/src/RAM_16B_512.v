//`define BENCHMARK "../../src/verilog/benchmarks/test01.txt" 
//`define BENCHMARK "../../src/verilog/benchmarks/gcd.v" 
//`define BENCHMARK "benchmarks/fibonacci.v" 
//`define BENCHMARK "benchmarks/ackermann.v" 
//`define BENCHMARK "benchmarks/gcd.v" 
//`define BENCHMARK "benchmarks/test01.txt" 
`define BENCHMARK "../../verilog/benchmarks/test01.txt" 

//`define BENCHMARK "../../src/verilog/benchmarks/b_test1.v" 
//`define BENCHMARK "../../src/verilog/benchmarks/bx_check.v" 
//`define BENCHMARK "../../src/verilog/benchmarks/test.v" 
//`define BENCHMARK "../../src/verilog/benchmarks/bvc_vs.v"


module RAM_16B_512(  
       input         CLK
      ,input         WEN
      ,input         CEN
      ,input   [8:0] A
      ,input  [15:0] D
      ,output [15:0] Q ,
  
      input [2:0] EMA ,
      input [1:0] EMAW ,
     input EMAS, 
      input RET1N

      );
 
  reg [15:0] mem[0:511];
	
  assign Q = mem[A];
  always @(posedge CLK) begin
    if (CEN) begin
    $readmemb(`BENCHMARK,mem);
  //`ifdef TEST1
 //$readmemb("../../src/verilog/benchmarks/fibonacci.v",mem);
 //`endif

// `ifdef  TEST2
  //$readmemb("../../src/verilog/benchmarks/ackermann.v",mem);
  //`endif

//`ifdef TEST3
 //$readmemb("../../src/verilog/benchmarks/gcd.v", mem);
  //`endif
    end else begin
      if (WEN) begin
        mem[A] <= D;
      end else begin
        mem[A] <= mem[A];
      end
    end
  end 

endmodule
