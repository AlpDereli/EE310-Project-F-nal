module top_module (
    input  logic clk,
    input  logic rst,
    input  logic btn_next,
    input  logic btn_prev,
    output logic [6:0] seg,
    output logic [7:0] an
);

    // Constants
    localparam int MAX_MEM_SIZE = 1024; // Set a reasonable upper limit

    // Interface signals for Process Engine Array (PEA)
    logic [15:0] pea_output;
    logic        pea_valid;
    logic        pea_done;

    // Instantiate process_engine_array (connect inputs as required)
    process_engine_array pea_inst (
        .clk(clk),
        .rst_n(~rst),
        .done(pea_done),
        .data_out(pea_output),
        .valid_out(pea_valid)
    );

    // Memory and index
    logic [15:0] memory [0:MAX_MEM_SIZE-1];
    logic [$clog2(MAX_MEM_SIZE)-1:0] write_index;
    logic                            enable_display;

    // Write results to memory
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            write_index <= 0;
            enable_display <= 0;
        end else begin
            if (pea_valid && write_index < MAX_MEM_SIZE) begin
                memory[write_index] <= pea_output;
                write_index <= write_index + 1;
            end
            if (pea_done) begin
                enable_display <= 1;
            end
        end
    end

    // Instantiate seven_segment_display
    seven_segment_display #(.MEM_SIZE(MAX_MEM_SIZE)) display_inst (
        .clk(clk),
        .rst(rst | ~enable_display),
        .btn_next(btn_next),
        .btn_prev(btn_prev),
        .memory(memory),
        .seg(seg),
        .an(an)
    );

endmodule
