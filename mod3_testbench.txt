`timescale 1ns / 1ps
module tb_mod3_counter;
    reg tb_clk;
    reg tb_EN;
    reg tb_AR;
    wire [1:0] tb_q;
    wire [2:0] tb_y;

    // Instantiate the mod3_counter
    mod3_counter uut (
        .clk(tb_clk),
        .EN(tb_EN),
        .AR(tb_AR),
        .q(tb_q),
        .y(tb_y)
    );

    initial begin
        $dumpfile("mod3_counter.vcd"); // Specify VCD file for waveform
        $dumpvars(0, tb_mod3_counter); // Dump variables

        // Initialize inputs
        tb_clk = 0;
        tb_EN = 0;
        tb_AR = 0;

        // Reset and initialize the counter
        #10 tb_AR = 1; // Assert reset
        #10 tb_AR = 0; // Deassert reset
        #5 tb_EN = 1;  // Enable the counter

        // Test each state
        repeat (5) begin
            #10; 
            $display("Time=%0t AR=%b EN=%b q=%b y=%b", $time, tb_AR, tb_EN, tb_q, tb_y);
        end
        #20
        // Deactivate enable to test hold state
        tb_EN = 0;
        #18;
        $display("Time=%0t AR=%b EN=%b q=%b y=%b", $time, tb_AR, tb_EN, tb_q, tb_y);

        $finish; // End simulation
    end

    // Clock generation
    always #5 tb_clk = ~tb_clk ; // Toggle clock every 5 time units

    endmodule
