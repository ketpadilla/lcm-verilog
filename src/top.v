// src/top.v
//
// Top-Level LCM CPU Module
//
// Function:
//   Integrates the controller FSM and datapath to compute the Least Common Multiple.
//   Uses a shared data input bus to load operands A and B sequentially.


/**
 * @file top.v
 * @brief Top-level module for the LCM CPU.
 *
 * This module connects:
 *  - controller.v: FSM control unit
 *  - datapath.v: operand storage, arithmetic, and comparison unit
 *
 * Input Loading Sequence:
 *  1. start = 1 with data_in = A
 *  2. Controller loads A and initializes X
 *  3. data_in is changed to B
 *  4. Controller loads B and initializes Y
 *
 * Computation:
 *  - If X < Y, update X = X + A
 *  - If X > Y, update Y = Y + B
 *  - If X == Y, assert done and output result
 */

`timescale 1ns / 1ps

module top (
    input         clk,
    input         rst,
    input         start,
    input  [15:0] data_in,

    output        done,
    output [15:0] result,

    output [15:0] Aout,
    output [15:0] Bout,
    output [15:0] Xout,
    output [15:0] Yout
);

    wire ldA;
    wire ldB;
    wire ldX;
    wire ldY;

    wire selX;
    wire selY;

    wire lt;
    wire gt;
    wire eq;

    controller ctrl (
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

    datapath dp (
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

endmodule