#!/bin/bash

# Define the design and testbench files
DESIGN_FILES="WB_master.v"
TB_FILES="tb.v"

# Compile the design and testbench files with Icarus Verilog
iverilog -o design.out $DESIGN_FILES $TB_FILES

# Run the simulation
vvp design.out

