// tests/compare_tb.v
//
// Testbench for the compare module
//
// To run this test:
// 1. Compile: iverilog -o out/compare_tb.vvp src/compare.v tests/compare_tb.v
// 2. Simulate: vvp out/compare_tb.vvp
// 3. View Waveform: gtkwave out/compare_tb.vcd


/**
 * @file compare_tb.v
 * @brief Testbench for the 16-bit comparator module.
 *
 * This testbench verifies:
 *  - Less-than flag generation
 *  - Greater-than flag generation
 *  - Equality flag generation
 *  - Mutual exclusivity of comparator outputs
 *
 * The comparator is used in the LCM datapath/controller interface to determine:
 *   - Whether X should be incremented
 *   - Whether Y should be incremented
 *   - Whether the LCM has been reached
 */

`timescale 1ns / 1ps

module compare_tb;

    reg  [15:0] in1;
    reg  [15:0] in2;

    wire lt;
    wire gt;
    wire eq;

    // Device Under Test (DUT)
    compare uut (
        .in1(in1),
        .in2(in2),
        .lt(lt),
        .gt(gt),
        .eq(eq)
    );

    initial begin
        $dumpfile("out/compare_tb.vcd");
        $dumpvars(0, compare_tb);

        // Test Case 1: Less Than
        in1 = 16'd4; in2 = 16'd6; #10;
        if (lt && !gt && !eq)
            $display("[PASS] Test 1: 4 < 6");
        else
            $display("[FAIL] Test 1: Comparator output incorrect");

        // Test Case 2: Greater Than
        in1 = 16'd10; in2 = 16'd3; #10;
        if (!lt && gt && !eq)
            $display("[PASS] Test 2: 10 > 3");
        else
            $display("[FAIL] Test 2: Comparator output incorrect");

        // Test Case 3: Equal
        in1 = 16'd8; in2 = 16'd8; #10;
        if (!lt && !gt && eq)
            $display("[PASS] Test 3: 8 == 8");
        else
            $display("[FAIL] Test 3: Comparator output incorrect");

        // Test Case 4: Zero Comparison
        in1 = 16'd0; in2 = 16'd5; #10;
        if (lt && !gt && !eq)
            $display("[PASS] Test 4: 0 < 5");
        else
            $display("[FAIL] Test 4: Comparator output incorrect");

        // Test Case 5: Max Value Equality
        in1 = 16'hFFFF; in2 = 16'hFFFF; #10;
        if (!lt && !gt && eq)
            $display("[PASS] Test 5: FFFF == FFFF");
        else
            $display("[FAIL] Test 5: Comparator output incorrect");

        $display("Comparator testbench completed.");
        $finish;
    end

endmodule