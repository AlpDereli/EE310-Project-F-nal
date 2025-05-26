`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.05.2025 15:24:13
// Design Name: 
// Module Name: seven_segment_display
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


// seven_segment_display.sv

module seven_segment_display #(
    parameter integer MEM_SIZE = 17
) (
    input logic clk,
    input logic rst,
    input logic btn_next,
    input logic btn_prev,
    input logic [15:0] memory [0:MEM_SIZE-1],
    output logic [6:0] seg,
    output logic [7:0] an
);

    logic [$clog2(MEM_SIZE)-1:0] index = 0;
    logic btn_next_prev, btn_prev_prev;

    // Button edge detection and index control
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            index <= 0;
            btn_next_prev <= 0;
            btn_prev_prev <= 0;
        end else begin
            if (btn_next && !btn_next_prev && index < MEM_SIZE - 1)
                index <= index + 1;
            else if (btn_prev && !btn_prev_prev && index > 0)
                index <= index - 1;
            btn_next_prev <= btn_next;
            btn_prev_prev <= btn_prev;
        end
    end

    // Clock divider for display refresh
    logic [19:0] refresh_counter = 0;
    logic [2:0] digit_sel;
    always_ff @(posedge clk) begin
        refresh_counter <= refresh_counter + 1;
        digit_sel <= refresh_counter[19:17];
    end

    // Convert index to BCD
    logic [3:0] index_bcd[3:0];
    logic [13:0] temp_idx;
    always_comb begin
        temp_idx = index;
        index_bcd[0] = temp_idx % 10; temp_idx /= 10;
        index_bcd[1] = temp_idx % 10; temp_idx /= 10;
        index_bcd[2] = temp_idx % 10; temp_idx /= 10;
        index_bcd[3] = temp_idx % 10;
    end

    // Current memory value limited to MEM_SIZE
    logic [15:0] current_value;
    always_comb begin
        if (index < MEM_SIZE)
            current_value = memory[index];
        else
            current_value = 16'h0000;
    end

    logic [3:0] digit;
    always_comb begin
        case (digit_sel)
            3'd0: begin digit = current_value[3:0];    an = 8'b11111110; end
            3'd1: begin digit = current_value[7:4];    an = 8'b11111101; end
            3'd2: begin digit = current_value[11:8];   an = 8'b11111011; end
            3'd3: begin digit = current_value[15:12];  an = 8'b11110111; end
            3'd4: begin digit = index_bcd[0];          an = 8'b11101111; end
            3'd5: begin digit = index_bcd[1];          an = 8'b11011111; end
            3'd6: begin digit = index_bcd[2];          an = 8'b10111111; end
            3'd7: begin digit = index_bcd[3];          an = 8'b01111111; end
            default: begin digit = 4'd0;               an = 8'b11111111; end
        endcase
    end

    // Hex to 7-segment decoder
    always_comb begin
        case (digit)
            4'h0: seg = 7'b1000000;
            4'h1: seg = 7'b1111001;
            4'h2: seg = 7'b0100100;
            4'h3: seg = 7'b0110000;
            4'h4: seg = 7'b0011001;
            4'h5: seg = 7'b0010010;
            4'h6: seg = 7'b0000010;
            4'h7: seg = 7'b1111000;
            4'h8: seg = 7'b0000000;
            4'h9: seg = 7'b0010000;
            4'hA: seg = 7'b0001000;
            4'hB: seg = 7'b0000011;
            4'hC: seg = 7'b1000110;
            4'hD: seg = 7'b0100001;
            4'hE: seg = 7'b0000110;
            4'hF: seg = 7'b0001110;
            default: seg = 7'b1111111;
        endcase
    end

endmodule
