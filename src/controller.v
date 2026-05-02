// src/controller.v
//
// LCM Controller FSM Module
//
// Function:
//   Controls datapath loading and update operations for LCM computation.


/**
 * @file controller.v
 * @brief FSM controller for iterative LCM computation.
 *
 * FSM Flow:
 *  IDLE    -> wait for start
 *  LOAD_A  -> load A and initialize X
 *  LOAD_B  -> load B and initialize Y
 *  COMPARE -> check X and Y flags
 *  UPDATE_X -> if X < Y, X = X + A
 *  UPDATE_Y -> if X > Y, Y = Y + B
 *  DONE    -> assert done when X == Y
 */

`timescale 1ns / 1ps

module controller (
    input clk,
    input rst,
    input start,

    input lt,
    input gt,
    input eq,

    output reg ldA,
    output reg ldB,
    output reg ldX,
    output reg ldY,

    output reg selX,
    output reg selY,

    output reg done
);

    parameter IDLE     = 3'b000;
    parameter LOAD_A   = 3'b001;
    parameter LOAD_B   = 3'b010;
    parameter COMPARE  = 3'b011;
    parameter UPDATE_X = 3'b100;
    parameter UPDATE_Y = 3'b101;
    parameter DONE     = 3'b110;

    reg [2:0] state;
    reg [2:0] next_state;

    // State register
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        case (state)
            IDLE:
                if (start)
                    next_state = LOAD_A;
                else
                    next_state = IDLE;

            LOAD_A:
                next_state = LOAD_B;

            LOAD_B:
                next_state = COMPARE;

            COMPARE:
                if (eq)
                    next_state = DONE;
                else if (lt)
                    next_state = UPDATE_X;
                else if (gt)
                    next_state = UPDATE_Y;
                else
                    next_state = COMPARE;

            UPDATE_X:
                next_state = COMPARE;

            UPDATE_Y:
                next_state = COMPARE;

            DONE:
                if (!start)
                    next_state = IDLE;
                else
                    next_state = DONE;

            default:
                next_state = IDLE;
        endcase
    end

    // Output logic
    always @(*) begin
        ldA  = 0;
        ldB  = 0;
        ldX  = 0;
        ldY  = 0;
        selX = 0;
        selY = 0;
        done = 0;

        case (state)
            LOAD_A: begin
                ldA  = 1;
                ldX  = 1;
                selX = 0;
            end

            LOAD_B: begin
                ldB  = 1;
                ldY  = 1;
                selY = 0;
            end

            UPDATE_X: begin
                ldX  = 1;
                selX = 1;
            end

            UPDATE_Y: begin
                ldY  = 1;
                selY = 1;
            end

            DONE: begin
                done = 1;
            end
        endcase
    end

endmodule