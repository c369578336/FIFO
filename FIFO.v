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
// Revision 1.00 - 完成基本框架
// Revision 2.00 - 根据书上的说法，建立了FIFO_R和FIFO_W两个有限向量机用于处理地址
// 目前的问题：
// 目前用的二进制码读写数据，等处理结束，可以引入格雷码
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
    wire [DEEP:0] head=0;
    wire [DEEP:0] tail=0;
    wire pop;
    wire push;

    FIFO_r#
    (
        .DEEP(DEEP)
    )
    u_FIFO_r(
        .clk(clk_o),
        .Empty(Empty),
        .en(r_en),
        .arst(arst),
        .pop(pop),
        .address(head)
    );

    FIFO_w#
    (
        .DEEP(DEEP)
    )
    u_FIFO_w(
        .clk(clk_in),
        .Full(Full),
        .en(w_en),
        .arst(arst),
        .push(push),
        .address(tail)
    );

    Memory #(
        .N(N),//数据为8位
        .DEEP(DEEP)//memory的深度
    ) 
    u_MEM(
    .data_in(data_in),
    .address_w(tail),
    .address_w(head),
    .w_en(push),
    .r_en(pop),
    .clk_in(clk_in),
    .clk_o(clk_o),

    .data_o(data_o)
);
    assign  Full= (head[N-1:0]==tail[N-1:0]) && (head[N]==tail[N]);//full是head和tail的首位相反,其他的都相同（恰好是deep的长度）
    assign  Empty= (head==tail);
endmodule