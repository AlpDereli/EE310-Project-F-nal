# EE310-Project-F-nal
Convolution Accelerator – Final Project

Overview
--------

This project implements a convolution accelerator using hardware modules designed in SystemVerilog. It supports pipelined depthwise computation, data decompression, and seven-segment display output. The architecture is modular and suitable for embedded implementations requiring efficient I/O and processing.

Module Components
-----------------

- BRAM: Used to store input data and intermediate results.
- Decompressor: Converts compressed data into raw input for processing.
- Adder: Performs element-wise additions.
- Multiplier: Used in convolution calculations.
- Process Engine: Core processing unit for computing dot products.
- Process Engine Array: Implements a pipelined array of PEs with configurable depth.
- ReLU: Applies rectified linear unit activation.
- Seven Segment Display Module: Displays final results and allows user interaction through control buttons.
- Top Module: Integrates all modules and coordinates the operation.


Display System
--------------

The results are displayed through a seven-segment interface. Button controls allow navigation through the output stream for real-time monitoring.
Button U will display next output
Button D will displaye previous output
BUtton C will reset the process.

LEFT 4 seven segment display shows the index number of output
Right 4 seven segment display shows the result in hexadecimal

Clock Frequency Configuration
-----------------------------

The default clock period is set in the XDC file:

    create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {clk}];

To change the frequency, modify the -period value accordingly.

Populating Inputs and Weights
-----------------------------

You can populate the inputs and weights manually using hexadecimal values. This is particularly useful for custom test cases or when simulating specific convolution patterns.

Refer to the syntax used in the process_engine_array module. For instance:

                            0: bram_input_data <= 16'h4100;
                            1: bram_input_data <= 16'h4200;
                            2: bram_input_data <= 16'h4300;
                            3: bram_input_data <= 16'h4400;
                            4: bram_input_data <= 16'h4500;


You can replace the values in 16'hXXXX format to simulate different input matrices or kernel configurations.

!!!!!IMPORTANT!!!!!: When populating one of the BRAMs, write the first value to the last place. And then write other values from 0th index to last_index-1 sequentally. So, at the end values must be look like this:                       
                            ```verilog
0: bram_input_data <= 16'h2nd;
1: bram_input_data <= 16'h3rd;
2: bram_input_data <= 16'h4th;
3: bram_input_data <= 16'h5th;
4: bram_input_data <= 16'h6th;

0: bram_input_data <= 16'h7th;
1: bram_input_data <= 16'h8th;
2: bram_input_data <= 16'h9th;
3: bram_input_data <= 16'h10th;
4: bram_input_data <= 16'h1st;

                          
