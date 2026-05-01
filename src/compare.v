// src/compare.v
//
// 16-bit Comparator Module
//
// Function:
//   Compares two 16-bit unsigned inputs and generates relational flags.
//
// Used in LCM Datapath For:
//   - Checking if X < Y
//   - Checking if X > Y
//   - Checking if X == Y


/**
 * @file compare.v
 * @brief 16-bit unsigned comparator for LCM datapath control flags.
 *
 * This module compares two 16-bit operands and produces three condition flags:
 *  - lt: asserted when in1 is less than in2
 *  - gt: asserted when in1 is greater than in2
 *  - eq: asserted when in1 is equal to in2
 *
 * These flags are used by the controller FSM to determine whether to update
 * the X register, update the Y register, or finish the LCM computation.
 *
 * Example Decisions:
 *   if X < Y: update X
 *   if X > Y: update Y
 *   if X == Y: done
 *
 * Notes:
 *   - Pure combinational logic
 *   - No clock or sequential elements
 *   - Synthesizable to comparator circuitry
 */

`timescale 1ns / 1ps

module compare (
    input  [15:0] in1,
    input  [15:0] in2,
    output        lt,
    output        gt,
    output        eq
);

    assign lt = (in1 < in2);
    assign gt = (in1 > in2);
    assign eq = (in1 == in2);

endmodule