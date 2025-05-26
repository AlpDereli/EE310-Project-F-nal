`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.04.2025 20:22:37
// Design Name:a 
// Module Name: bram
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

module bram#(parameter mem_num=16)(
    input clk,
    input write,
    input read,
    input [$clog2(mem_num)-1:0] addr,
    input [15:0] din,
    output reg [15:0] dout
    );
    reg [15:0] memory [mem_num-1:0];
    
    always @(posedge clk)begin
        if (write)begin
            memory[addr] <= din; 
        end if (read) begin
              dout<=memory[addr];
        end
    end
    
endmodule
