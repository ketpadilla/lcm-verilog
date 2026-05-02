// src/datapath.v
//
// LCM Datapath Module
//
// Function:
//   Stores operands A and B, maintains running multiples X and Y,
//   performs addition updates, and generates comparison flags.
//
// Used by Controller For:
//   - Loading initial operands
//   - Updating X when X < Y
//   - Updating Y when X > Y
//   - Detecting completion when X == Y


/**
 * @file datapath.v
 * @brief Datapath for iterative LCM computation using ADD and CMP.
 *
 * This module contains the main arithmetic and storage hardware for the LCM CPU.
 *
 * Internal Registers:
 *  - A: original first operand
 *  - B: original second operand
 *  - X: running multiple of A
 *  - Y: running multiple of B
 *
 * Arithmetic Operations:
 *  - X_next = X + A
 *  - Y_next = Y + B
 *
 * Comparator Flags:
 *  - lt: asserted when X < Y
 *  - gt: asserted when X > Y
 *  - eq: asserted when X == Y
 *
 * Notes:
 *  - Registers are updated on the rising edge of clk
 *  - Pure datapath; no FSM logic is implemented here
 *  - Control signals are provided by the controller module
 */

`timescale 1ns / 1ps

module datapath (
    input         clk,
    input  [15:0] data_in,

    input         ldA,
    input         ldB,
    input         ldX,
    input         ldY,

    input         selX,
    input         selY,

    output        lt,
    output        gt,
    output        eq,

    output [15:0] result,

    output [15:0] Aout,
    output [15:0] Bout,
    output [15:0] Xout,
    output [15:0] Yout
);

    wire [15:0] x_add_out;
    wire [15:0] y_add_out;

    wire [15:0] x_mux_out;
    wire [15:0] y_mux_out;

    // A and B store the original operands.
    pipo A_reg (
        .data_in(data_in),
        .load(ldA),
        .clk(clk),
        .data_out(Aout)
    );

    pipo B_reg (
        .data_in(data_in),
        .load(ldB),
        .clk(clk),
        .data_out(Bout)
    );

    // Adders generate the next running multiples.
    adder X_adder (
        .in1(Xout),
        .in2(Aout),
        .out(x_add_out)
    );

    adder Y_adder (
        .in1(Yout),
        .in2(Bout),
        .out(y_add_out)
    );

    // MUX selection:
    // selX = 0 -> load initial data_in into X
    // selX = 1 -> load X + A into X
    mux X_mux (
        .in0(data_in),
        .in1(x_add_out),
        .sel(selX),
        .out(x_mux_out)
    );

    // selY = 0 -> load initial data_in into Y
    // selY = 1 -> load Y + B into Y
    mux Y_mux (
        .in0(data_in),
        .in1(y_add_out),
        .sel(selY),
        .out(y_mux_out)
    );

    // X and Y store the running multiples.
    pipo X_reg (
        .data_in(x_mux_out),
        .load(ldX),
        .clk(clk),
        .data_out(Xout)
    );

    pipo Y_reg (
        .data_in(y_mux_out),
        .load(ldY),
        .clk(clk),
        .data_out(Yout)
    );

    // Compare current running multiples.
    compare cmp_unit (
        .in1(Xout),
        .in2(Yout),
        .lt(lt),
        .gt(gt),
        .eq(eq)
    );

    // When eq=1, Xout and Yout are equal, so either can be the LCM.
    assign result = Xout;

endmodule