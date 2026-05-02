// tests/datapath_tb.v
//
// Testbench for the datapath module
//
// To run this test:
// 1. Compile: iverilog -o out/datapath_tb.vvp src/adder.v src/compare.v src/mux.v src/pipo.v src/datapath.v tests/datapath_tb.v
// 2. Simulate: vvp out/datapath_tb.vvp
// 3. View Waveform: gtkwave out/datapath_tb.vcd


/**
 * @file datapath_tb.v
 * @brief Testbench for the LCM datapath module.
 *
 * This testbench verifies:
 *  - Loading of original operands A and B
 *  - Initialization of running multiples X and Y
 *  - Updating X through X = X + A
 *  - Updating Y through Y = Y + B
 *  - Comparator flag behavior during LCM iteration
 *
 * Test Example:
 *  A = 4, B = 6
 *
 * Expected Iteration:
 *  X = 4,  Y = 6   -> lt = 1
 *  X = 8,  Y = 6   -> gt = 1
 *  X = 8,  Y = 12  -> lt = 1
 *  X = 12, Y = 12  -> eq = 1, result = 12
 */

`timescale 1ns / 1ps

module datapath_tb;

    reg         clk;
    reg  [15:0] data_in;

    reg         ldA;
    reg         ldB;
    reg         ldX;
    reg         ldY;

    reg         selX;
    reg         selY;

    wire        lt;
    wire        gt;
    wire        eq;

    wire [15:0] result;

    wire [15:0] Aout;
    wire [15:0] Bout;
    wire [15:0] Xout;
    wire [15:0] Yout;

    datapath uut (
        .clk(clk),
        .data_in(data_in),

        .ldA(ldA),
        .ldB(ldB),
        .ldX(ldX),
        .ldY(ldY),

        .selX(selX),
        .selY(selY),

        .lt(lt),
        .gt(gt),
        .eq(eq),

        .result(result),

        .Aout(Aout),
        .Bout(Bout),
        .Xout(Xout),
        .Yout(Yout)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("out/datapath_tb.vcd");
        $dumpvars(0, datapath_tb);

        clk = 0;
        data_in = 16'd0;

        ldA = 0;
        ldB = 0;
        ldX = 0;
        ldY = 0;

        selX = 0;
        selY = 0;

        // Test Case 1: Load A = 4 and initialize X = 4
        data_in = 16'd4;
        ldA = 1;
        ldX = 1;
        selX = 0;
        #10;

        ldA = 0;
        ldX = 0;

        if (Aout == 16'd4 && Xout == 16'd4)
            $display("[PASS] Test 1: Loaded A=4 and initialized X=4");
        else
            $display("[FAIL] Test 1: Expected A=4 X=4, Got A=%d X=%d", Aout, Xout);

        // Test Case 2: Load B = 6 and initialize Y = 6
        data_in = 16'd6;
        ldB = 1;
        ldY = 1;
        selY = 0;
        #10;

        ldB = 0;
        ldY = 0;

        if (Bout == 16'd6 && Yout == 16'd6)
            $display("[PASS] Test 2: Loaded B=6 and initialized Y=6");
        else
            $display("[FAIL] Test 2: Expected B=6 Y=6, Got B=%d Y=%d", Bout, Yout);

        // Current state: X=4, Y=6, so lt should be 1
        #1;
        if (lt && !gt && !eq)
            $display("[PASS] Test 3: X=4 < Y=6");
        else
            $display("[FAIL] Test 3: Expected lt=1, Got lt=%b gt=%b eq=%b", lt, gt, eq);

        // Test Case 4: Update X = X + A = 4 + 4 = 8
        selX = 1;
        ldX = 1;
        #10;

        ldX = 0;

        if (Xout == 16'd8)
            $display("[PASS] Test 4: Updated X = X + A = 8");
        else
            $display("[FAIL] Test 4: Expected X=8, Got X=%d", Xout);

        // Current state: X=8, Y=6, so gt should be 1
        #1;
        if (!lt && gt && !eq)
            $display("[PASS] Test 5: X=8 > Y=6");
        else
            $display("[FAIL] Test 5: Expected gt=1, Got lt=%b gt=%b eq=%b", lt, gt, eq);

        // Test Case 6: Update Y = Y + B = 6 + 6 = 12
        selY = 1;
        ldY = 1;
        #10;

        ldY = 0;

        if (Yout == 16'd12)
            $display("[PASS] Test 6: Updated Y = Y + B = 12");
        else
            $display("[FAIL] Test 6: Expected Y=12, Got Y=%d", Yout);

        // Current state: X=8, Y=12, so lt should be 1
        #1;
        if (lt && !gt && !eq)
            $display("[PASS] Test 7: X=8 < Y=12");
        else
            $display("[FAIL] Test 7: Expected lt=1, Got lt=%b gt=%b eq=%b", lt, gt, eq);

        // Test Case 8: Update X = X + A = 8 + 4 = 12
        selX = 1;
        ldX = 1;
        #10;

        ldX = 0;

        if (Xout == 16'd12)
            $display("[PASS] Test 8: Updated X = X + A = 12");
        else
            $display("[FAIL] Test 8: Expected X=12, Got X=%d", Xout);

        // Current state: X=12, Y=12, so eq should be 1
        #1;
        if (!lt && !gt && eq && result == 16'd12)
            $display("[PASS] Test 9: X=Y=12, LCM result=12");
        else
            $display("[FAIL] Test 9: Expected eq=1 result=12, Got lt=%b gt=%b eq=%b result=%d",
                     lt, gt, eq, result);

        $display("Datapath testbench completed.");
        $finish;
    end

endmodule