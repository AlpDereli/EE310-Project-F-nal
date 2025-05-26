`timescale 1ns / 1ps

module tb_process_engine_array_streaming;

    // Parameters (must match DUT)
    parameter weightRow   = 3;
    parameter inputRow    = 5;
    parameter DEPTH       = 2;
    parameter COLS        = inputRow - weightRow + 1;
    parameter ROWS        = 3;
    parameter WORD_WIDTH  = 16;
    parameter TOTAL_WORDS = ROWS * COLS;

    // DUT I/Os
    logic clk;
    logic rst_n;
    logic done;
    logic [WORD_WIDTH-1:0] data_out;
    logic valid_out;

    // Instantiate DUT
    process_engine_array #(
        .weightRow(weightRow),
        .inputRow(inputRow),
        .DEPTH(DEPTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .done(done),
        .data_out(data_out),
        .valid_out(valid_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $display("=== Starting Streaming Convolution Test ===");
        clk   = 0;
        rst_n = 0;

        #20;
        rst_n = 1;

        //wait(done);
        #10000000000;
        $display("=== DONE signal received. Ending simulation. ===");
        #20;
        $finish;
    end

    // Capture streamed 16-bit results
    integer word_counter = 0;
    always_ff @(posedge clk) begin
        if (valid_out) begin
            $display("[TB] Word %0d = %h", word_counter, data_out);
            word_counter++;
        end
    end

endmodule