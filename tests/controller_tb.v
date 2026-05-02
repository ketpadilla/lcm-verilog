// tests/controller_tb.v
//
// Testbench for the controller module
//
// To run this test:
// 1. Compile: iverilog -o out/controller_tb.vvp src/controller.v tests/controller_tb.v
// 2. Simulate: vvp out/controller_tb.vvp
// 3. View Waveform: gtkwave out/controller_tb.vcd


/**
 * @file controller_tb.v
 * @brief Testbench for the LCM controller FSM.
 *
 * This testbench verifies:
 *  - Reset and idle behavior
 *  - Start-triggered loading sequence
 *  - X update when lt=1
 *  - Y update when gt=1
 *  - Done assertion when eq=1
 */

`timescale 1ns / 1ps

module controller_tb;

    reg clk;
    reg rst;
    reg start;

    reg lt;
    reg gt;
    reg eq;

    wire ldA;
    wire ldB;
    wire ldX;
    wire ldY;

    wire selX;
    wire selY;

    wire done;

    controller uut (
        .clk(clk),
        .rst(rst),
        .start(start),

        .lt(lt),
        .gt(gt),
        .eq(eq),

        .ldA(ldA),
        .ldB(ldB),
        .ldX(ldX),
        .ldY(ldY),

        .selX(selX),
        .selY(selY),

        .done(done)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("out/controller_tb.vcd");
        $dumpvars(0, controller_tb);

        clk = 0;
        rst = 1;
        start = 0;
        lt = 0;
        gt = 0;
        eq = 0;

        #10;
        rst = 0;

        #10;
        if (!ldA && !ldB && !ldX && !ldY && !done)
            $display("[PASS] Test 1: Controller remains idle after reset");
        else
            $display("[FAIL] Test 1: Controller idle outputs incorrect");

        // Start computation
        start = 1;

        #10;
        if (ldA && ldX && !selX)
            $display("[PASS] Test 2: LOAD_A asserts ldA and ldX");
        else
            $display("[FAIL] Test 2: LOAD_A outputs incorrect");

        #10;
        if (ldB && ldY && !selY)
            $display("[PASS] Test 3: LOAD_B asserts ldB and ldY");
        else
            $display("[FAIL] Test 3: LOAD_B outputs incorrect");

        // COMPARE sees lt=1, so next state should update X
        lt = 1; gt = 0; eq = 0;
        #10;

        #10;
        if (ldX && selX)
            $display("[PASS] Test 4: UPDATE_X asserts ldX with selX=1");
        else
            $display("[FAIL] Test 4: UPDATE_X outputs incorrect");

        // Back to COMPARE, now gt=1, so update Y
        lt = 0; gt = 1; eq = 0;
        #10;

        #10;
        if (ldY && selY)
            $display("[PASS] Test 5: UPDATE_Y asserts ldY with selY=1");
        else
            $display("[FAIL] Test 5: UPDATE_Y outputs incorrect");

        // Back to COMPARE, now eq=1, so done
        lt = 0; gt = 0; eq = 1;
        #10;

        #10;
        if (done)
            $display("[PASS] Test 6: DONE state asserts done");
        else
            $display("[FAIL] Test 6: DONE output incorrect");

        start = 0;
        #10;
        if (!done)
            $display("[PASS] Test 7: Controller returns to IDLE when start=0");
        else
            $display("[FAIL] Test 7: Controller did not return to IDLE");

        $display("Controller testbench completed.");
        $finish;
    end

endmodule