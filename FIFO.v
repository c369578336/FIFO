`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: 尘世
//
// Create Date: 2021/11/24  19点30分
// Design Name: FIFO
// Module Name: FIFO
// Project Name: FIFO
// Target Devices:
// Tool Versions:
// Description:
// 利用格雷码编写地址的先进先出模块
// Dependencies:
// Revision:
// Revision 0.01 - File Created
// 完成基本框架
// 目前的问题：
// 1. 是否用状态机？
// 2. 如何保证head和tail的改变不会导致需要输出的数据出错？
// Additional Comments:
//
// 
//////////////////////////////////////////////////////////////////////////////////

module FIFO #(
    parameter N=8,//数据为8位
    parameter DEEP=8//memory的深度
) (
    input [N-1:0] data_in,
    input clk_in,
    input clk_out,
    input arst,
    input w_en,
    input r_en,

    output Full,
    output Empty,
    output reg [N-1:0] data_o
);
/*
    localparam EMPTY = 0;
    localparam FULL = 1;
    localparam NORMAL = 2;
*/
    localparam M = 2**DEEP;
    reg [N-1:0] ROM [M-1:0];//一个8位，深度为8的ROM
    reg [DEEP:0] head=0;
    reg [DEEP:0] tail=0;
    reg [N-1:0] data_head;
    reg [N-1:0] data_tail;

    always @(posedge arst or posedge clk_out) begin
        if (arst)
            head=0;
        else if (w_en && Empty==0)
        begin
            data_o=ROM[head];
            head=head-1;
        end
    end

    always @(posedge arst or posedge clk_in) begin
        if (arst)
            tail=0;
        else if (r_en && Full==0)
        begin
            ROM[tail]=data_in;
            tail=tail+1;
        end
    end


    assign  Full= (head[N-1:0]==tail[N-1:0]) && (head[N]==tail[N]);//full是head和tail的首位相反,其他的都相同（恰好是deep的长度）
    assign  Empty= (head==tail);
endmodule