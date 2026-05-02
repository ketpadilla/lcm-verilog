// tests/pipo_tb.v
//
// Testbench for the pipo module
//
// To run this test:
// 1. Compile: iverilog -o out/pipo_tb.vvp src/pipo.v tests/pipo_tb.v
// 2. Simulate: vvp out/pipo_tb.vvp
// 3. View Waveform: gtkwave out/pipo_tb.vcd


/**
 * @file pipo_tb.v
 * @brief Testbench for the 16-bit PIPO register module.
 *
 * This testbench verifies:
 *  - Register loads data on rising clock edge when load=1
 *  - Register retains value when load=0
 *  - Multiple sequential loads function correctly
 *
 * The PIPO register is used in the LCM datapath for operand and state storage.
 */

`timescale 1ns / 1ps

module pipo_tb;

    reg  [15:0] data_in;
    reg         load;
    reg         clk;
    wire [15:0] data_out;

    // Device Under Test (DUT)
    pipo uut (
        .data_in(data_in),
        .load(load),
        .clk(clk),
        .data_out(data_out)
    );

    // Clock Generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("out/pipo_tb.vcd");
        $dumpvars(0, pipo_tb);

        clk = 0;

        // Test Case 1: Load Initial Value
        data_in = 16'd10; load = 1; #10;
        if (data_out == 16'd10)
            $display("[PASS] Test 1: Loaded 10");
        else
            $display("[FAIL] Test 1: Expected 10, Got %d", data_out);

        // Test Case 2: Hold Value When Load=0
        data_in = 16'd20; load = 0; #10;
        if (data_out == 16'd10)
            $display("[PASS] Test 2: Held Previous Value");
        else
            $display("[FAIL] Test 2: Expected Hold at 10, Got %d", data_out);

        // Test Case 3: Load New Value
        data_in = 16'd25; load = 1; #10;
        if (data_out == 16'd25)
            $display("[PASS] Test 3: Loaded 25");
        else
            $display("[FAIL] Test 3: Expected 25, Got %d", data_out);

        // Test Case 4: Load Zero
        data_in = 16'd0; load = 1; #10;
        if (data_out == 16'd0)
            $display("[PASS] Test 4: Loaded 0");
        else
            $display("[FAIL] Test 4: Expected 0, Got %d", data_out);

        $display("PIPO testbench completed.");
        $finish;
    end

endmodule