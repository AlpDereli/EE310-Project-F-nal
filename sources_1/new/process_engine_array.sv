`timescale 1ns / 1ps

module process_engine_array #(
    parameter weightRow = 3,
    parameter inputRow = 5,
    parameter DEPTH = 2
)(
    input logic clk,
    input logic rst_n,
    output logic done,
    output logic [15:0] data_out,
    output logic valid_out
);

    // Constants
    localparam COLS = inputRow - weightRow + 1;
    localparam TOTAL_WORDS = 3 * COLS;

    typedef enum logic [2:0] {
        IDLE,
        POPULATE,    /////////
        POP_weights,
        LOAD,
        COMPUTE,
        DONE
    } state_t;

    state_t state, next_state;
    logic [2:0] prev_state;
    logic start_pulse;

    logic [15:0] weight_val;
    logic [15:0] input_val;

    logic [1:0] weight_row, weight_col;
    logic [2:0] input_row, input_col;
    logic [2:0] weight_depth, input_depth;

    logic [15:0] weights [0:DEPTH-1][0:weightRow-1][0:weightRow-1];
    logic [15:0] inputs [0:DEPTH-1][0:inputRow-1][0:inputRow-1];

    logic [weightRow*weightRow*DEPTH:0] weight_count;
    logic [5:0] input_count;
    logic [inputRow*inputRow*DEPTH-1:0] populate_count;   ///////////

    logic [15:0] final_outputs [0:2][0:COLS-1];
    logic we_weights;
    logic [15:0] bram_weight_data;
    bram_2d_weights #(.DEPTH(DEPTH),.ROWS(weightRow), .COLS(weightRow)) w_bram (
        .clk(clk),
        .we(we_weights),
        .depth_addr(weight_depth),
        .row_addr(weight_row),
        .col_addr(weight_col),
        .data_in(bram_weight_data),
        .data_out(weight_val)
    );


    logic we_inputs;                  ////////////
    logic [15:0] bram_input_data;
    //assign we_inputs = (state==POPULATE);
    bram_2d_inputs #(.DEPTH(DEPTH),.ROWS(inputRow), .COLS(inputRow)) i_bram (
        .clk(clk),
        .we(we_inputs),
        .depth_addr(input_depth),
        .row_addr(input_row),
        .col_addr(input_col),
        .data_in(bram_input_data),
        .data_out(input_val)
    );

    // FSM
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    always_comb begin
        unique case (state)
            IDLE:    next_state = POPULATE;
            POPULATE:   next_state =    (populate_count == inputRow*inputRow*DEPTH )? POP_weights:POPULATE;   ////////
            POP_weights: next_state = (weight_count == weightRow * weightRow * DEPTH)  ? LOAD  : POP_weights;
            LOAD:    next_state = ((weight_count >= weightRow * weightRow * DEPTH + inputRow*inputRow-1) && (input_count >= inputRow * inputRow * DEPTH + weightRow*weightRow+1)) ? COMPUTE : LOAD;
            COMPUTE: next_state = DONE;
            DONE:    next_state = DONE;
            default: next_state = IDLE;
        endcase
    end
    // State tracking
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            prev_state <= IDLE;
        else
            prev_state <= state;
    end

    assign start_pulse = (prev_state != DONE) && (state == DONE);
    

        // Populate BRAM with initial values
    always_ff @(posedge clk or negedge rst_n) begin //POP yaparken sonuncuyu ilk sıraya yazıyo diğerlerini bir kaydırıyo bütününün(ilkini sona yaz, diğerlerini baştan sırala değer girmek için)!!!!!!
        if (!rst_n) begin
            populate_count <= 0;
            input_depth <= 0;
            input_row <= 0;
            input_col <= 0;
            bram_input_data <= 0;
            we_inputs <=0;
        end else if (state == POPULATE) begin
            we_inputs<=0;
            if (populate_count < inputRow * inputRow * DEPTH) begin
            case (input_depth)
                0: begin
                    case (input_row)
                        0: case (input_col)
                            0: bram_input_data <= 16'h4100;
                            1: bram_input_data <= 16'h4200;
                            2: bram_input_data <= 16'h4300;
                            3: bram_input_data <= 16'h4400;
                            4: bram_input_data <= 16'h4500;
                            default: bram_input_data <= 0;
                        endcase
                        1: case (input_col)
                            0: bram_input_data <= 16'h4600;
                            1: bram_input_data <= 16'h4700;
                            2: bram_input_data <= 16'h4800;
                            3: bram_input_data <= 16'h4900;
                            4: bram_input_data <= 16'h4a00;
                            default: bram_input_data <= 0;
                        endcase
                        2: case (input_col)
                            0: bram_input_data <= 16'h4b00;
                            1: bram_input_data <= 16'h4c00;
                            2: bram_input_data <= 16'h4d00;
                            3: bram_input_data <= 16'h4e00;
                            4: bram_input_data <= 16'h4f00;
                            default: bram_input_data <= 0;
                        endcase
                        3: case (input_col)
                            0: bram_input_data <= 16'h5000;
                            1: bram_input_data <= 16'h5100;
                            2: bram_input_data <= 16'h5200;
                            3: bram_input_data <= 16'h5300;
                            4: bram_input_data <= 16'h5400;
                            default: bram_input_data <= 0;
                        endcase
                        4: case (input_col)
                            0: bram_input_data <= 16'h5500;
                            1: bram_input_data <= 16'h5600;
                            2: bram_input_data <= 16'h5700;
                            3: bram_input_data <= 16'h5800;
                            4: bram_input_data <= 16'h4000;
                            default: bram_input_data <= 0;
                        endcase
                        default: bram_input_data <= 0;
                    endcase
                end

                1: begin
                    case (input_row)
                        0: case (input_col)
                            0: bram_input_data <= 16'h5400;
                            1: bram_input_data <= 16'h4f00;
                            2: bram_input_data <= 16'h4400;
                            3: bram_input_data <= 16'h5200;
                            4: bram_input_data <= 16'h4000;
                            default: bram_input_data <= 0;
                        endcase
                        1: case (input_col)
                            0: bram_input_data <= 16'h3c00;
                            1: bram_input_data <= 16'h4100;
                            2: bram_input_data <= 16'h4000;
                            3: bram_input_data <= 16'h3c00;
                            4: bram_input_data <= 16'h4000;
                            default: bram_input_data <= 0;
                        endcase
                        2: case (input_col)
                            0: bram_input_data <= 16'h5500;
                            1: bram_input_data <= 16'h5600;
                            2: bram_input_data <= 16'h5700;
                            3: bram_input_data <= 16'h5800;
                            4: bram_input_data <= 16'h4000;
                            default: bram_input_data <= 0;
                        endcase
                        3: case (input_col)
                            0: bram_input_data <= 16'h4100;
                            1: bram_input_data <= 16'h4200;
                            2: bram_input_data <= 16'h4300;
                            3: bram_input_data <= 16'h4400;
                            4: bram_input_data <= 16'h4500;
                            default: bram_input_data <= 0;
                        endcase
                        4: case (input_col)
                            0: bram_input_data <= 16'h5000;
                            1: bram_input_data <= 16'h5100;
                            2: bram_input_data <= 16'h5200;
                            3: bram_input_data <= 16'h5300;
                            4: bram_input_data <= 16'h5400;
                            default: bram_input_data <= 0;
                        endcase
                        default: bram_input_data <= 0;
                    endcase
                end

                default: bram_input_data <= 0;
            endcase
                
                // Update address counters
                populate_count <= populate_count+1;
                if (input_col == inputRow-1) begin
                    input_col <= 0;
                    if (input_row == inputRow-1) begin
                        input_row <= 0;
                        //if (input_depth<DEPTH-1)begin
                            input_depth <= input_depth + 1;
                        //end
                        
                    end else begin
                        input_row <= input_row + 1;
                    end
                end else begin
                    input_col <= input_col + 1;
                end
                we_inputs<=1;
            end
            
        end
        
    //end
    
    //always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        weight_count <= 0;
        weight_depth <= 0;
        weight_row <= 0;
        weight_col <= 0;
        bram_weight_data <= 0;
        we_weights <= 0;
    end else if (state == POP_weights) begin
        we_weights <= 0;

        if (weight_count < DEPTH * weightRow * weightRow) begin
        case (weight_depth)
            0: begin
                case (weight_row)
                    0: begin
                        case (weight_col)
                            0: bram_weight_data <= 16'h3e00;
                            1: bram_weight_data <= 16'h4000;
                            2: bram_weight_data <= 16'h3e00;
                            default: bram_weight_data <= 16'h0000;
                        endcase
                    end
                    1: begin
                        case (weight_col)
                            0: bram_weight_data <= 16'h4000;
                            1: bram_weight_data <= 16'h4200;
                            2: bram_weight_data <= 16'h4000;
                            default: bram_weight_data <= 16'h0000;
                        endcase
                    end
                    2: begin
                        case (weight_col)
                            0: bram_weight_data <= 16'h4200;
                            1: bram_weight_data <= 16'h4400;
                            2: bram_weight_data <= 16'h3c00;
                            default: bram_weight_data <= 16'h0000;
                        endcase
                    end
                    default: bram_weight_data <= 16'h0000;
                endcase
            end

            1: begin
                case (weight_row)
                    0: begin
                        case (weight_col)
                            0: bram_weight_data <= 16'h4000;
                            1: bram_weight_data <= 16'h4200;
                            2: bram_weight_data <= 16'h4000;
                            default: bram_weight_data <= 16'h0000;
                        endcase
                    end
                    1: begin
                        case (weight_col)
                            0: bram_weight_data <= 16'h4200;
                            1: bram_weight_data <= 16'h4400;
                            2: bram_weight_data <= 16'h3c00;
                            default: bram_weight_data <= 16'h0000;
                        endcase
                    end
                    2: begin
                        case (weight_col)
                            0: bram_weight_data <= 16'h3e00;
                            1: bram_weight_data <= 16'h4000;
                            2: bram_weight_data <= 16'h3e00;
                            default: bram_weight_data <= 16'h0000;
                        endcase
                    end
                    default: bram_weight_data <= 16'h0000;
                endcase
            end

            default: bram_weight_data <= 16'h0000;
        endcase

            we_weights <= 1;
            weight_count <= weight_count + 1;

            if (weight_col == weightRow-1) begin
                weight_col <= 0;
                if (weight_row == weightRow-1) begin
                    weight_row <= 0;
                    weight_depth <= weight_depth + 1;
                end else begin
                    weight_row <= weight_row + 1;
                end
            end else begin
                weight_col <= weight_col + 1;
            end
        end
    end
//end
    
    // Load logic
    //always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n ) begin
            weight_row <= 0; weight_col <= 0;  
            input_row <= 0; input_col <= 0;    
            weight_count <= 0; input_count <= 0;
            weight_depth <= 0; input_depth <= 0;
        end else if (state == LOAD) begin
            if (weight_count < weightRow * weightRow * DEPTH+inputRow*inputRow-1) begin //+24 //Parametize olmamış olabilir!!!!
                weights[weight_depth-DEPTH][weight_row][weight_col-1] <= weight_val; //col-1
                weight_count <= weight_count + 1;

                if (weight_col == weightRow) begin //+1
                    weight_col <= 0;
                    if (weight_row == weightRow-1) begin
                        weight_row <= 0;
                        weight_depth <= weight_depth + 1;
                    end else begin
                        weight_row <= weight_row + 1;
                    end
                end else begin
                    weight_col <= weight_col + 1;
                end
            end else if (input_count < inputRow * inputRow * DEPTH + weightRow*weightRow+1) begin //+10 // Burası da !!!!!!
                inputs[input_depth-DEPTH][input_row][input_col-1] <= input_val;
                input_count <= input_count + 1;

                if (input_col == inputRow) begin  //+1 offset
                    input_col <= 0;
                    if (input_row == inputRow-1) begin
                        input_row <= 0;
                        //if (input_depth< DEPTH-1)begin
                            input_depth <= input_depth + 1;
                        //end
                        
                    end else begin
                        input_row <= input_row + 1;
                    end
                end else begin
                    input_col <= input_col + 1;
                end
            end
        end
    end

    // PE Pipeline
    genvar col;
    generate
        for (col = 0; col < COLS; col = col + 1) begin : col_loop
            wire [15:0] psum_stage0 [0:DEPTH][0:COLS-1];
            wire [15:0] psum_stage1 [0:DEPTH][0:COLS-1];
            wire [15:0] psum_stage2 [0:DEPTH][0:COLS-1];

            for (genvar i = 0; i < COLS; i++) begin
                assign psum_stage0[0][i] = 16'b0;
            end

            for (genvar d = 0; d < DEPTH; d++) begin : stage0
                pe_insallah #(.weightRow(weightRow), .inputRow(inputRow)) pe0 (
                    .psum(psum_stage0[d]),
                    .weight(weights[d][0]),
                    .inputs(inputs[d][0 + col]),
                    .out_psum(psum_stage0[d+1])
                );
            end

            for (genvar d = 0; d < DEPTH; d++) begin : stage1
                pe_insallah #(.weightRow(weightRow), .inputRow(inputRow)) pe1 (
                    .psum(psum_stage1[d]),
                    .weight(weights[d][1]),
                    .inputs(inputs[d][1 + col]),
                    .out_psum(psum_stage1[d+1])
                );
            end

            for (genvar d = 0; d < DEPTH; d++) begin : stage2
                pe_insallah #(.weightRow(weightRow), .inputRow(inputRow)) pe2 (
                    .psum(psum_stage2[d]),
                    .weight(weights[d][2]),
                    .inputs(inputs[d][2 + col]),
                    .out_psum(psum_stage2[d+1])
                );
            end

            for (genvar i = 0; i < COLS; i++) begin
                assign psum_stage1[0][i] = psum_stage0[DEPTH][i];
                assign psum_stage2[0][i] = psum_stage1[DEPTH][i];
                assign final_outputs[col][i] = psum_stage2[DEPTH][i];
            end
        end
    endgenerate

    // Flatten output array
    logic [15:0] flat_array [0:TOTAL_WORDS-1];
    generate
        genvar fi, fj;
        for (fi = 0; fi < 3; fi++) begin
            for (fj = 0; fj < COLS; fj++) begin
                assign flat_array[fi * COLS + fj] = final_outputs[fi][fj];
            end
        end
    endgenerate

    // Compressor
    wire [15:0]compoutfirst;
    CompressorFirst #(
        .ROWS(COLS),
        .COLS(COLS),
        .WORD_WIDTH(16)
    ) compressor_inst (
        .clk(clk),
        .rst_n(rst_n),
        .start(start_pulse),
        .input_array(flat_array),
        .data_out(compoutfirst),
        .valid(valid_out),
        .done(done)
    );
    
    wire [15:0]relu_out; //bunu daha sonra relu outputu olarak ver, son compresora birleştir
    
    relu relulinear(
    .in(compoutfirst),
    .o(data_out)
    );
    
//    zero_counter comp(
//    .clk(clk),
//    .data_in(relu_out),
//    .data_out(data_out)
//    );
endmodule