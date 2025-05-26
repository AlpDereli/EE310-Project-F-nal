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



How to Use This Project
------------------------

1. *Download & Import*:
   - Clone or download this repository.
   - Open Vivado and create a new project.
   - Add all provided .sv and .xdc files to the Vivado project.

2. *Synthesis and Implementation*:
   - Set top_module.sv as the top module.
   - Synthesize and implement the design.
   - Generate the bitstream.

3. *Programming FPGA*:
   - Connect your FPGA development board.
   - Use Vivado Hardware Manager to program the bitstream.

4. *Running the Design*:
   - Once programmed, the output of the convolution will appear on the 7-segment display.
   - Use the provided button controls to navigate through the result stream.

5. *Simulation*:
   - You can simulate individual modules using Vivado’s simulation tools.
   - For example, instantiate process_engine_array.sv in a testbench to verify convolution behavior.

6. *Hexadecimal Input for Testing*:
   - Inputs and weights can be manually defined in hexadecimal format (e.g., 16'h000A) in the testbenches.
   - Refer to the syntax used in process_engine_array.sv for population.

Module Descriptions
-------------------

- *bram.sv*:
  - Block RAM storage for input data and intermediate results.

- *decompressor.sv*:
  - Decompresses encoded data into usable input format for convolution.

- *adder.sv*:
  - Performs element-wise 16-bit addition.

- *multiplier.sv*:
  - Performs 16-bit multiplication for convolution kernel computations.

- *process_engine.sv*:
  - Takes a window of inputs and weights, computes a single convolution result (dot product).

- *process_engine_array.sv*:
  - Arranges multiple process_engine units in a pipelined array structure.
  - Adds support for multiple depth layers and enables chaining of outputs.

- *relu.sv*:
  - Applies Rectified Linear Unit (ReLU) function (outputs 0 if input < 0).

- *seven_segment_display.sv*:
  - Displays output results on a 7-segment display.
  - Controlled via buttons to view each output sequentially.

- *compressor.sv*:
  - Reduces output bit-width or combines results for I/O optimization.

- *top_module.sv*:
  - Integrates all submodules and serves as the main entry point for synthesis and FPGA execution.
