`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.05.2025 22:39:13
// Design Name: 
// Module Name: CompressorParallelOut
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


module zero_counter (
    input logic clk,
    input logic [15:0] data_in,       
    output logic [15:0] data_out     
);

    reg [15:0] previous;
    logic [15:0] zero_count = 0;
    logic counting_zeros = 0;
    logic output_ready = 0;

    always @(posedge clk) begin
        previous <= data_in;
        
        if (data_in != 16'b0) begin
            // Current input is non-zero
            if (counting_zeros) begin
                // We were counting zeros, now output the count
                data_out <= zero_count;
                output_ready <= 1;
                zero_count <= 0;
                counting_zeros <= 0;
            end else if (output_ready) begin
                // Output the previous non-zero value
                data_out <= previous;
                output_ready <= 0;
            end
        end else begin
            // Current input is zero
            if (!counting_zeros) begin
                // First zero in sequence
                counting_zeros <= 1;
                zero_count <= 1;
                // Output the previous non-zero value
                if (previous != 16'b0) begin
                    data_out <= previous;
                    output_ready <= 1;
                end
            end else begin
                // Continuing zero sequence
                zero_count <= zero_count + 1;
            end
        end
    end

endmodule


