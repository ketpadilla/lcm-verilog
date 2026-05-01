// src/mux.v
//
// 16-bit 2-to-1 Multiplexer Module
//
// Function:
//   Selects one of two 16-bit inputs based on a 1-bit select signal.
//
// Used in LCM Datapath For:
//   - Selecting initial load values
//   - Selecting feedback values from the adder


/**
 * @file mux.v
 * @brief 16-bit 2-to-1 multiplexer for LCM datapath input selection.
 *
 * This module selects between two 16-bit input values based on the select signal.
 *
 * Selection Logic:
 *   sel = 0 -> out = in0
 *   sel = 1 -> out = in1
 *
 * Notes:
 *   - Pure combinational logic
 *   - No clock or sequential elements
 *   - Synthesizable to multiplexer circuitry
 */

`timescale 1ns / 1ps

module mux (
    input  [15:0] in0,
    input  [15:0] in1,
    input         sel,
    output [15:0] out
);

    assign out = sel ? in1 : in0;

endmodule