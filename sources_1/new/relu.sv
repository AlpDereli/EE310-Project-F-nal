`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.04.2025 19:40:08
// Design Name: 
// Module Name: relu
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


module relu(
    input [15:0] in,
    output reg [15:0] o
    );
    
    always@(*)begin
    if (in[15]==1)begin
         o = 32'b0;
    end else begin
         o = in;
    end
    end  
endmodule
