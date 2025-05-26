`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.05.2025 20:10:38
// Design Name: 
// Module Name: CoffeMachine
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


module bram_2d_weights #(
    parameter ROWS = 3,
    parameter COLS = 3,
    parameter DEPTH = 3,
    parameter DATA_WIDTH = 16
) (
    input  logic clk,
    input logic we,
    input  logic [$clog2(DEPTH)-1:0] depth_addr,
    input  logic [$clog2(ROWS)-1:0] row_addr,
    input  logic [$clog2(COLS)-1:0] col_addr,
    input logic [15:0] data_in,
    output logic [DATA_WIDTH-1:0] data_out
);

    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1][0:ROWS-1][0:COLS-1];

    // Preload weights
//    initial begin
//        for (int d = 0; d < DEPTH; d++) begin
//            mem[d][0][0] = 16'h3C00; // 1.0
//            mem[d][0][1] = 16'h3E00; // 1.5
//            mem[d][0][2] = 16'h4000; // 2.0
//            mem[d][1][0] = 16'h3E00; // 1.5
//            mem[d][1][1] = 16'h4000; // 2.0
//            mem[d][1][2] = 16'h4200; // 2.5
//            mem[d][2][0] = 16'h4000; // 2.0
//            mem[d][2][1] = 16'h4200; // 2.5
//            mem[d][2][2] = 16'h4400; // 3.0
//        end
//    end

    always_ff @(posedge clk) begin
        if (we)begin
            mem[depth_addr][row_addr][col_addr]<=data_in;
        end
        data_out <= mem[depth_addr][row_addr][col_addr];
    end


endmodule


