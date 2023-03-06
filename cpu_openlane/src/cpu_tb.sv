//TESTBENCH FOR  CPU

`timescale 1ns/10ps
module cpu_tb();
parameter delay=10;

  logic clk, rst;
 int output_file;
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
  // $vcdpluson;
  output_file = $fopen({"vcs_output.txt"}, "w");

   //$vcdplusmemon; 
	 #1000000; //
   $fdisplay(output_file, "%d", dut.rf.regFile[0] );
   $fdisplay(output_file, "%d", dut.rf.regFile[1] );
   $fdisplay(output_file, "%d", dut.rf.regFile[2] );
   $fdisplay(output_file, "%d", dut.rf.regFile[3] );
   $fdisplay(output_file, "%d", dut.rf.regFile[4] );
   $fdisplay(output_file, "%d", dut.rf.regFile[5] );
   $fdisplay(output_file, "%d", dut.rf.regFile[6] );
   $fdisplay(output_file, "%d", dut.rf.regFile[7] );
   $fdisplay(output_file, "%d", dut.rf.regFile[8] );
   $fdisplay(output_file, "%d", dut.rf.regFile[9] );
   $fdisplay(output_file, "%d", dut.rf.regFile[10] );
   $fdisplay(output_file, "%d", dut.rf.regFile[11] );
   $fdisplay(output_file, "%d", dut.rf.regFile[12] );
   $fdisplay(output_file, "%d", dut.rf.regFile[13] );


   $finish;
   //$fclose(output_file);

	 end

endmodule
