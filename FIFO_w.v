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
        input en,
        input arst,
        input [DEEP:0] address_r,
        
        output push,
        output Full,
        output [DEEP:0] address_w
    );
    reg [DEEP:0] address;

    always @(posedge clk or posedge arst) begin
        if (arst) begin
            address=0;
        end
        else begin
            if (push)
            address=address+1;
        end
    end

    Gray #(
        .N(DEEP+1)
    ) 
    Gray_w
    (
        .Bin(address),
        .GrayBin(address_w)
    );

    assign Full = (address_w[DEEP-2:0]==address_r[DEEP-2:0]) && (address_r[DEEP:DEEP-1]==~(address_w[DEEP:DEEP-1]));
    assign push=en && !Full && !arst;
endmodule
