`timescale 1ns / 1ps
/*
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: 尘世
//
// Create Date: 2021年11月27日17:24:55
// Design Name: FIFO
// Module Name: FIFO_w
// Project Name: FIFO
// Target Devices:
// Tool Versions:
// Description:
// FIFO的写部分的有限状态机
// Dependencies:
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 状态：
   1. 空闲
   2. 等待FIFO
   3. 压入数据
// 
//////////////////////////////////////////////////////////////////////////////////
*/

module FIFO_w #(
        parameter DEEP=8//memory的深度
    )(
        input clk,
        input Full,
        input en,
        input arst,
        
        output push,
        output reg [DEEP:0] address
    );
    localparam WAIT = 0;
    localparam FULL = 1;
    localparam PUSH = 2;

    reg [1:0] state;
    reg [1:0] next_state;

    always @(*) begin
        case (state)
            WAIT:
                if (Full)
                    next_state = FULL;
                else if (!en)
                    next_state = WAIT;
                else
                    next_state = PUSH;

            FULL:
                if (Full)
                    next_state =FULL;
                else if (en)
                    next_state = PUSH;
                else
                    next_state = WAIT;

            PUSH:
                if (Full)
                    next_state = FULL;
                else if(en)
                    next_state = PUSH;
                else
                    next_state = WAIT;
            default:
                next_state=WAIT;
        endcase
    end

    always @(posedge clk or posedge arst) begin
        if (arst) begin
            state=WAIT;
            address=0;
        end
        else begin
            state=next_state;
            if (state!=Full)
                address=address+1;
        end
    end

    assign push=state==PUSH;
endmodule
