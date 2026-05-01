// tests/adder_tb.v
//
// Testbench for the adder module
//
// To run this test:
// 1. Compile: iverilog -o out/adder_tb.vvp src/adder.v tests/adder_tb.v
// 2. Simulate: vvp out/adder_tb.vvp
// 3. View Waveform: gtkwave out/adder_tb.vcd


/**
 * @file adder_tb.v
 * @brief Testbench for the 16-bit combinational adder module.
 *
 * This testbench verifies:
 *  - Basic addition functionality
 *  - Zero-input handling
 *  - Multiple valid arithmetic cases
 *
 * The adder is used in the LCM datapath to compute:
 *   X_next = X + A
 *   Y_next = Y + B
 */

`timescale 1ns / 1ps

module adder_tb;

    reg  [15:0] in1;
    reg  [15:0] in2;
    wire [15:0] out;

    // Device Under Test (DUT)
    adder uut (
        .in1(in1),
        .in2(in2),
        .out(out)
    );

    initial begin
        $dumpfile("out/adder_tb.vcd");
        $dumpvars(0, adder_tb);

        // Test Case 1
        in1 = 16'd4; in2 = 16'd4; #10;
        if (out == 16'd8)
            $display("[PASS] Test 1: 4 + 4 = %d", out);
        else
            $display("[FAIL] Test 1: Expected 8, Got %d", out);

        // Test Case 2
        in1 = 16'd6; in2 = 16'd6; #10;
        if (out == 16'd12)
            $display("[PASS] Test 2: 6 + 6 = %d", out);
        else
            $display("[FAIL] Test 2: Expected 12, Got %d", out);

        // Test Case 3
        in1 = 16'd8; in2 = 16'd4; #10;
        if (out == 16'd12)
            $display("[PASS] Test 3: 8 + 4 = %d", out);
        else
            $display("[FAIL] Test 3: Expected 12, Got %d", out);

        // Test Case 4
        in1 = 16'd0; in2 = 16'd5; #10;
        if (out == 16'd5)
            $display("[PASS] Test 4: 0 + 5 = %d", out);
        else
            $display("[FAIL] Test 4: Expected 5, Got %d", out);

        // Test Case 5
        in1 = 16'd15; in2 = 16'd10; #10;
        if (out == 16'd25)
            $display("[PASS] Test 5: 15 + 10 = %d", out);
        else
            $display("[FAIL] Test 5: Expected 25, Got %d", out);

        $display("Adder testbench completed.");
        $finish;
    end

endmodule