// tests/top_tb.v
//
// Testbench for the top module
//
// To run this test:
// 1. Compile: iverilog -o out/top_tb.vvp src/adder.v src/compare.v src/mux.v src/pipo.v src/datapath.v src/controller.v src/top.v tests/top_tb.v
// 2. Simulate: vvp out/top_tb.vvp
// 3. View Waveform: gtkwave out/top_tb.vcd


/**
 * @file top_tb.v
 * @brief Testbench for the top-level LCM CPU module.
 *
 * This testbench verifies:
 *  - Full controller and datapath integration
 *  - Sequential loading of operands A and B through data_in
 *  - Automatic LCM computation using ADD and CMP
 *  - Correct done assertion and final result output
 *  - Multiple LCM cases from Test 5 to Test 15
 */

`timescale 1ns / 1ps

module top_tb;

    reg         clk;
    reg         rst;
    reg         start;
    reg  [15:0] data_in;

    wire        done;
    wire [15:0] result;

    wire [15:0] Aout;
    wire [15:0] Bout;
    wire [15:0] Xout;
    wire [15:0] Yout;

    top uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .data_in(data_in),

        .done(done),
        .result(result),

        .Aout(Aout),
        .Bout(Bout),
        .Xout(Xout),
        .Yout(Yout)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("out/top_tb.vcd");
        $dumpvars(0, top_tb);

        clk = 0;
        rst = 1;
        start = 0;
        data_in = 16'd0;

        // -----------------------------
        // Test 1 to Test 4: Detailed Top-Level Integration Check
        // -----------------------------

        #10;
        rst = 0;

        // Begin computation with A = 4
        data_in = 16'd4;
        start = 1;

        // Wait for LOAD_A to capture A = 4
        #20;

        // Provide B = 6 before LOAD_B captures data_in
        data_in = 16'd6;

        // Wait until computation is done
        wait(done == 1);

        #1;
        if (result == 16'd12)
            $display("[PASS] Test 1: LCM(4, 6) = %d", result);
        else
            $display("[FAIL] Test 1: Expected LCM(4, 6) = 12, Got %d", result);

        if (Aout == 16'd4 && Bout == 16'd6)
            $display("[PASS] Test 2: Loaded operands A=4 and B=6 correctly");
        else
            $display("[FAIL] Test 2: Incorrect operands A=%d B=%d", Aout, Bout);

        if (Xout == 16'd12 && Yout == 16'd12)
            $display("[PASS] Test 3: Final running multiples X=12 and Y=12");
        else
            $display("[FAIL] Test 3: Expected X=12 Y=12, Got X=%d Y=%d", Xout, Yout);

        if (done)
            $display("[PASS] Test 4: Done signal asserted");
        else
            $display("[FAIL] Test 4: Done signal not asserted");

        start = 0;
        #20;

        // -----------------------------
        // Test 5 to Test 15: Additional Full LCM Test Cases
        // -----------------------------

        // Test 5: LCM(3,5) = 15
        rst = 1; start = 0; data_in = 16'd0; #10; rst = 0;
        data_in = 16'd3; start = 1; #20; data_in = 16'd5;
        wait(done == 1); #1;
        if (result == 16'd15)
            $display("[PASS] Test 5: LCM(3, 5) = %d", result);
        else
            $display("[FAIL] Test 5: Expected 15, Got %d", result);
        start = 0; #20;

        // Test 6: LCM(6,8) = 24
        rst = 1; start = 0; data_in = 16'd0; #10; rst = 0;
        data_in = 16'd6; start = 1; #20; data_in = 16'd8;
        wait(done == 1); #1;
        if (result == 16'd24)
            $display("[PASS] Test 6: LCM(6, 8) = %d", result);
        else
            $display("[FAIL] Test 6: Expected 24, Got %d", result);
        start = 0; #20;

        // Test 7: LCM(7,7) = 7
        rst = 1; start = 0; data_in = 16'd0; #10; rst = 0;
        data_in = 16'd7; start = 1; #20; data_in = 16'd7;
        wait(done == 1); #1;
        if (result == 16'd7)
            $display("[PASS] Test 7: LCM(7, 7) = %d", result);
        else
            $display("[FAIL] Test 7: Expected 7, Got %d", result);
        start = 0; #20;

        // Test 8: LCM(9,12) = 36
        rst = 1; start = 0; data_in = 16'd0; #10; rst = 0;
        data_in = 16'd9; start = 1; #20; data_in = 16'd12;
        wait(done == 1); #1;
        if (result == 16'd36)
            $display("[PASS] Test 8: LCM(9, 12) = %d", result);
        else
            $display("[FAIL] Test 8: Expected 36, Got %d", result);
        start = 0; #20;

        // Test 9: LCM(10,15) = 30
        rst = 1; start = 0; data_in = 16'd0; #10; rst = 0;
        data_in = 16'd10; start = 1; #20; data_in = 16'd15;
        wait(done == 1); #1;
        if (result == 16'd30)
            $display("[PASS] Test 9: LCM(10, 15) = %d", result);
        else
            $display("[FAIL] Test 9: Expected 30, Got %d", result);
        start = 0; #20;

        // Test 10: LCM(2,9) = 18
        rst = 1; start = 0; data_in = 16'd0; #10; rst = 0;
        data_in = 16'd2; start = 1; #20; data_in = 16'd9;
        wait(done == 1); #1;
        if (result == 16'd18)
            $display("[PASS] Test 10: LCM(2, 9) = %d", result);
        else
            $display("[FAIL] Test 10: Expected 18, Got %d", result);
        start = 0; #20;

        // Test 11: LCM(8,14) = 56
        rst = 1; start = 0; data_in = 16'd0; #10; rst = 0;
        data_in = 16'd8; start = 1; #20; data_in = 16'd14;
        wait(done == 1); #1;
        if (result == 16'd56)
            $display("[PASS] Test 11: LCM(8, 14) = %d", result);
        else
            $display("[FAIL] Test 11: Expected 56, Got %d", result);
        start = 0; #20;

        // Test 12: LCM(11,13) = 143
        rst = 1; start = 0; data_in = 16'd0; #10; rst = 0;
        data_in = 16'd11; start = 1; #20; data_in = 16'd13;
        wait(done == 1); #1;
        if (result == 16'd143)
            $display("[PASS] Test 12: LCM(11, 13) = %d", result);
        else
            $display("[FAIL] Test 12: Expected 143, Got %d", result);
        start = 0; #20;

        // Test 13: LCM(4,10) = 20
        rst = 1; start = 0; data_in = 16'd0; #10; rst = 0;
        data_in = 16'd4; start = 1; #20; data_in = 16'd10;
        wait(done == 1); #1;
        if (result == 16'd20)
            $display("[PASS] Test 13: LCM(4, 10) = %d", result);
        else
            $display("[FAIL] Test 13: Expected 20, Got %d", result);
        start = 0; #20;

        // Test 14: LCM(12,18) = 36
        rst = 1; start = 0; data_in = 16'd0; #10; rst = 0;
        data_in = 16'd12; start = 1; #20; data_in = 16'd18;
        wait(done == 1); #1;
        if (result == 16'd36)
            $display("[PASS] Test 14: LCM(12, 18) = %d", result);
        else
            $display("[FAIL] Test 14: Expected 36, Got %d", result);
        start = 0; #20;

        // Test 15: LCM(16,20) = 80
        rst = 1; start = 0; data_in = 16'd0; #10; rst = 0;
        data_in = 16'd16; start = 1; #20; data_in = 16'd20;
        wait(done == 1); #1;
        if (result == 16'd80)
            $display("[PASS] Test 15: LCM(16, 20) = %d", result);
        else
            $display("[FAIL] Test 15: Expected 80, Got %d", result);
        start = 0; #20;

        $display("Top-level LCM CPU testbench completed.");
        $finish;
    end

endmodule