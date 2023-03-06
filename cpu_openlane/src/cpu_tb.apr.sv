//TESTBENCH FOR  CPU

`timescale 1ns/10ps
module cpu_tb();
parameter delay= 8;

  logic clk, rst;
    int output_file;
    int i;

  cpu dut(.clk(clk), .rst(rst));

  initial begin // Set up the clock
    clk <= 0;
    rst = 1;
    #18//
    rst = 0;
  end
  initial begin
   forever #(delay/2) clk <= ~clk;
  end
  initial begin
  $sdf_annotate("../../apr/results/cpu.apr.sdf", dut);
   $vcdpluson;
     output_file = $fopen({"vcs_output.txt"}, "w");


   $vcdplusmemon; 
	 #1000000; // do not change this time, required for Ackermann benchmark
   
   $fdisplay(output_file, "%d", dut.rf.regFile );
     

   $finish;
   $fclose(output_file);


	 end

endmodule
