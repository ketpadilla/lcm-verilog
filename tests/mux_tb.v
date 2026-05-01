// tests/mux_tb.v
//
// Testbench for the mux module
//
// To run this test:
// 1. Compile: iverilog -o out/mux_tb.vvp src/mux.v tests/mux_tb.v
// 2. Simulate: vvp out/mux_tb.vvp
// 3. View Waveform: gtkwave out/mux_tb.vcd


/**
 * @file mux_tb.v
 * @brief Testbench for the 16-bit 2-to-1 multiplexer module.
 *
 * This testbench verifies:
 *  - Correct output selection when sel = 0
 *  - Correct output selection when sel = 1
 *  - Input changes propagate correctly based on select state
 *
 * The mux is used in the LCM datapath to select between initial load values
 * and feedback arithmetic results.
 */

`timescale 1ns / 1ps

module mux_tb;

    reg  [15:0] in0;
    reg  [15:0] in1;
    reg         sel;
    wire [15:0] out;

    // Device Under Test (DUT)
    mux uut (
        .in0(in0),
        .in1(in1),
        .sel(sel),
        .out(out)
    );

    initial begin
        $dumpfile("out/mux_tb.vcd");
        $dumpvars(0, mux_tb);

        // Test Case 1: Select in0
        in0 = 16'd4; in1 = 16'd8; sel = 1'b0; #10;
        if (out == 16'd4)
            $display("[PASS] Test 1: sel=0, out=in0=%d", out);
        else
            $display("[FAIL] Test 1: Expected 4, Got %d", out);

        // Test Case 2: Select in1
        in0 = 16'd4; in1 = 16'd8; sel = 1'b1; #10;
        if (out == 16'd8)
            $display("[PASS] Test 2: sel=1, out=in1=%d", out);
        else
            $display("[FAIL] Test 2: Expected 8, Got %d", out);

        // Test Case 3: Change inputs, select in0
        in0 = 16'd12; in1 = 16'd24; sel = 1'b0; #10;
        if (out == 16'd12)
            $display("[PASS] Test 3: sel=0, out=in0=%d", out);
        else
            $display("[FAIL] Test 3: Expected 12, Got %d", out);

        // Test Case 4: Same inputs, select in1
        sel = 1'b1; #10;
        if (out == 16'd24)
            $display("[PASS] Test 4: sel=1, out=in1=%d", out);
        else
            $display("[FAIL] Test 4: Expected 24, Got %d", out);

        // Test Case 5: Zero and max value selection
        in0 = 16'd0; in1 = 16'hFFFF; sel = 1'b1; #10;
        if (out == 16'hFFFF)
            $display("[PASS] Test 5: sel=1, out=in1=FFFF");
        else
            $display("[FAIL] Test 5: Expected FFFF, Got %h", out);

        $display("MUX testbench completed.");
        $finish;
    end

endmodule