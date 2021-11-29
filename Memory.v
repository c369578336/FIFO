`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: 尘世
//
// Create Date: 2021年11月27日16:59:05
// Design Name: FIFO
// Module Name: Memory
// Project Name: FIFO
// Target Devices:
// Tool Versions:
// Description:
// 读写RAM
// Dependencies:
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
// 
//////////////////////////////////////////////////////////////////////////////////

module Memory #(
    parameter N=8,//数据为8位
    parameter DEEP=8//memory的深度
) (
    input [N-1:0] data_in,
    input [DEEP-1:0] address_w,
    input [DEEP-1:0] address_r,
    input w_en,
    input r_en,
    input clk_in,
    input clk_o,

    output reg [N-1:0] data_o
);
    localparam M = 2**DEEP;
    reg [N-1:0] ROM [M-1:0];//一个8位，深度为8的ROM

    always @(negedge clk_in) begin
        if (w_en)
            ROM[address_w]=data_in;
    end

    always @(negedge clk_o) begin
        if (r_en)
            data_o=ROM[address_r];
    end

endmodule