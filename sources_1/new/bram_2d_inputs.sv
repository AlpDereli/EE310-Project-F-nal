`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.05.2025 20:17:35
// Design Name: 
// Module Name: CoffeMachine2
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module bram_2d_inputs #(
    parameter ROWS = 5,
    parameter COLS = 5,
    parameter DEPTH = 3,
    parameter DATA_WIDTH = 16
) (
    input  logic clk,
    input logic we,
    input logic [$clog2(DEPTH)-1:0] depth_addr,
    input  logic [$clog2(ROWS)-1:0] row_addr,
    input  logic [$clog2(COLS)-1:0] col_addr,
    input logic [15:0] data_in,
    output logic [DATA_WIDTH-1:0] data_out
);

    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1][0:ROWS-1][0:COLS-1];

//    initial begin
//     for (int d = 0; d < DEPTH; d++) begin
//        // Row 0
//        mem[d][0][0] = 16'h4000;
//        mem[d][0][1] = 16'h4100;
//        mem[d][0][2] = 16'h4200;
//        mem[d][0][3] = 16'h4300;
//        mem[d][0][4] = 16'h4400;

//        // Row 1
//        mem[d][1][0] = 16'h4500;
//        mem[d][1][1] = 16'h4600;
//        mem[d][1][2] = 16'h4700;
//        mem[d][1][3] = 16'h4800;
//        mem[d][1][4] = 16'h4900;

//        // Row 2
//        mem[d][2][0] = 16'h4A00;
//        mem[d][2][1] = 16'h4B00;
//        mem[d][2][2] = 16'h4C00;
//        mem[d][2][3] = 16'h4D00;
//        mem[d][2][4] = 16'h4E00;

//        // Row 3
//        mem[d][3][0] = 16'h4F00;
//        mem[d][3][1] = 16'h5000;
//        mem[d][3][2] = 16'h5100;
//        mem[d][3][3] = 16'h5200;
//        mem[d][3][4] = 16'h5300;

//        // Row 4
//        mem[d][4][0] = 16'h5400;
//        mem[d][4][1] = 16'h5500;
//        mem[d][4][2] = 16'h5600;
//        mem[d][4][3] = 16'h5700;
//        mem[d][4][4] = 16'h5800;
//    end
//    end
    always_ff @(posedge clk) begin
        if (we)begin
            mem[depth_addr][row_addr][col_addr]<=data_in;
        end
        data_out <= mem[depth_addr][row_addr][col_addr];
    end

endmodule

