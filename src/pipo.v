// src/pipo.v
//
// 16-bit Parallel-In Parallel-Out Register Module
//
// Function:
//   Stores 16-bit input data on the rising edge of the clock
//   when load is asserted.
//
// Used in LCM Datapath For:
//   - Register A storage
//   - Register B storage
//   - Running multiple X storage
//   - Running multiple Y storage


/**
 * @file pipo.v
 * @brief 16-bit load-enabled register for LCM datapath storage.
 *
 * This module stores a 16-bit input value into an internal register
 * on the rising edge of the clock when load is asserted.
 *
 * Register Behavior:
 *   load = 1 -> data_out <= data_in on posedge clk
 *   load = 0 -> retain previous value
 *
 * Notes:
 *   - Sequential logic
 *   - Positive-edge triggered
 *   - Synthesizable to flip-flop/register hardware
 */

`timescale 1ns / 1ps

module pipo (
    input  [15:0] data_in,
    input         load,
    input         clk,
    output reg [15:0] data_out
);

    always @(posedge clk) begin
        if (load)
            data_out <= data_in;
    end

endmodule