module tb_top_module;

    // Parameters
    logic clk;
    logic rst;
    logic btn_next;
    logic btn_prev;
    logic [6:0] seg;
    logic [7:0] an;

    // Instantiate DUT
    top_module dut (
        .clk(clk),
        .rst(rst),
        .btn_next(btn_next),
        .btn_prev(btn_prev),
        .seg(seg),
        .an(an)
    );

    // Clock generation
    initial clk = 0;
    always #10 clk = ~clk; // 100MHz

    // Stimulus
    initial begin
        $display("Starting simulation...");
        $dumpfile("wave.vcd");  // For GTKWave
        $dumpvars(0, tb_top_module);

        rst = 1;
        btn_next = 0;
        btn_prev = 0;
        #20;
        rst = 0;

        // Wait long enough for FSM to complete all states
        repeat (5000) @(posedge clk); // Increase as needed

        // Try to move through memory with button presses
        btn_next = 1; #10; btn_next = 0; #100;
        btn_next = 1; #10; btn_next = 0; #100;
        btn_prev = 1; #10; btn_prev = 0; #100;

        repeat (100) @(posedge clk);
        $display("Simulation done.");
        $finish;
    end

endmodule
