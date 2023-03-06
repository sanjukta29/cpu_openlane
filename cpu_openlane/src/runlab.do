# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.

vlog "./alu.sv"     
vlog "./alu_tb.sv"   
vlog "./regfile.sv"       
vlog "./regfile_tb.sv"     
vlog "./shifter.sv"     
vlog "./shifter_tb.sv"     
vlog "./RAM_16B_512.v"     
vlog "./inst_mem.v" 
vlog "./data_mem.v" 
vlog "./idecode.sv" 
vlog "./flag_calc.sv" 
vlog "./cpu.sv" 
vlog "./cpu_tb.sv" 
vlog "./branch.sv"
vlog "./forwarding.sv" 
vlog "./sky130_sram_16_512.v" 








# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
# There's an argument --timescale 1ps/1ps to set global default timescale; doesn't work here, works in Makefile
vsim -voptargs="+acc" -t 1ps -lib work cpu_tb

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
#do alu_wave.do
do wave.do



# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all
