`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.05.2025 14:58:37
// Design Name: 
// Module Name: compressorFirst
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


module CompressorFirst #(
    parameter int ROWS = 3,
    parameter int COLS = 3,
    parameter int WORD_WIDTH = 16,
    parameter int TOTAL_WORDS = ROWS * COLS
)(
    input  logic clk,
    input  logic rst_n,
    input  logic start,
    input  logic [WORD_WIDTH-1:0] input_array [0:TOTAL_WORDS-1],
    output logic [WORD_WIDTH-1:0] data_out,
    output logic valid,
    output logic done
);

    logic [$clog2(TOTAL_WORDS):0] index;
    logic active;
    logic started;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            index <= 0;
            active <= 0;
            started <= 0;
            data_out <= 0;
            valid <= 0;
            done <= 0;
        end else begin
            if (start && !started) begin
                started <= 1;
                active <= 1;
                index <= 0;
                done <= 0;
            end else if (active) begin
                data_out <= input_array[index];
                valid <= 1;

                if (index == TOTAL_WORDS) begin //index == TOTAL_WORDS -1
                    active <= 0;
                    done <= 1;
                    valid <= 0;
                end else begin
                    index <= index + 1;
                end
            end else begin
                valid <= 0;
            end
        end
    end
endmodule