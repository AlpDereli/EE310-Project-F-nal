`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.04.2025 20:54:24
// Design Name: 
// Module Name: pe_insallah
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


module pe_insallah#(parameter weightRow = 3, parameter inputRow = 5)(
    input [15:0] psum [inputRow-weightRow+1],
    input [15:0] weight [weightRow],
    input [15:0] inputs[inputRow],
    output [15:0] out_psum[inputRow-weightRow+1]
    );
    
    genvar i,j;
    generate
        for (i = 0; i <= inputRow - weightRow; i = i + 1) begin : conv_loop
            wire [15:0] mul_results [0:weightRow-1];
            wire [15:0] add_results [0:weightRow];
            
            assign add_results[0] = psum[i];
            
            for (j = 0; j < weightRow; j = j + 1) begin : mac_loop
                mult mul (
                    .a(inputs[i + j]),
                    .b(weight[j]),
                    .p(mul_results[j])
                );
                
                float_adder add (
                    .num1(add_results[j]),
                    .num2(mul_results[j]),
                    .result(add_results[j + 1])
                );
            end
            
            assign out_psum[i] = add_results[weightRow];
        end
    endgenerate
    
    
endmodule
