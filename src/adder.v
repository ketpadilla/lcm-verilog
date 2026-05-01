// src/adder.v
//
// 16-bit Combinational Adder Module
//
// Function:
//   Computes the sum of two 16-bit inputs.
//
// Used in LCM Datapath For:
//   - Updating X register: X = X + A
//   - Updating Y register: Y = Y + B


/**
 * @file adder.v
 * @brief 16-bit combinational adder for LCM datapath arithmetic.
 *
 * This module performs unsigned combinational addition of two 16-bit operands.
 * It is used by the datapath to generate the next multiple of each operand
 * during iterative LCM computation.
 *
 * Example Operations:
 *   X_next = X + A
 *   Y_next = Y + B
 *
 * Notes:
 *   - Pure combinational logic
 *   - No clock or sequential elements
 *   - Synthesizable to hardware adder circuitry
 */

`timescale 1ns / 1ps

module adder (
    input  [15:0] in1,
    input  [15:0] in2,
    output [15:0] out
);

    assign out = in1 + in2;

endmodule