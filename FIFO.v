`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: 尘世
//
// Create Date: 2021/11/24  19�??30�??
// Design Name: FIFO
// Module Name: FIFO
// Project Name: FIFO
// Target Devices:
// Tool Versions:
// Description:
// 利用格雷码编写地�??的先进先出模�??
// Dependencies:
// Revision:
// Revision 0.01 - File Created
// Revision 1.00 - 完成基本框架
// Revision 2.00 - 根据书上的说法，建立了FIFO_R和FIFO_W两个有限向量机用于处理
// Revision 3.00 - 完成了初步的FIFO。
// Revision 4.00 - 根据资料内容对FIFO进行完善。
// Revision 5.00 - 完成FIFO
// Revision 5.30 - 加入双寄存器
// Revision 5.50 - 加入格雷码
// Additional Comments:
// 目前还有一点小问题：
// full下读取数据，会等一拍full才会消失
// 可能是由于写入的数据传过来需要经过双寄存器导致的。
// 但是下一次读取的时钟来的时候，full已经消失。
//////////////////////////////////////////////////////////////////////////////////

module FIFO #(
    parameter N=8,//数据�??8�??
    parameter DEEP=8//memory的深�??
) (
    input [N-1:0] data_in,
    input clk_in,
    input clk_out,
    input arst,
    input w_en,
    input r_en,

    output Full,
    output Empty,
    output [N-1:0] data_o
);
    wire [DEEP:0] address_w;
    wire [DEEP:0] address_r;
    wire pop;
    wire push;
    wire [DEEP:0] Q_r;
    wire [DEEP:0] Q_w;
    FIFO_r#
    (
        .DEEP(DEEP)
    )
    u_FIFO_r(
        .clk(clk_out),
        .address_w(Q_w),
        .en(r_en),
        .arst(arst),
        .pop(pop),

        .Empty(Empty),
        .address_r(address_r)
    );

    FIFO_w#
    (
        .DEEP(DEEP)
    )
    u_FIFO_w(
        .clk(clk_in),
        .address_r(Q_r),
        .en(w_en),
        .arst(arst),
        .push(push),

        .Full(Full),
        .address_w(address_w)
    );

    DTigger#
    (
        .N(DEEP+1)
    )
    uDT_r(
        .clk(clk_out),
        .D(address_r),
        .Q(Q_r)
    );

    DTigger#
    (
        .N(DEEP+1)
    )
    uDT_w(
        .clk(clk_in),
        .D(address_w),
        .Q(Q_w)
    );

    Memory #(
        .N(N),//数据�??8�??
        .DEEP(DEEP)//memory的深�??
    ) 
    u_MEM(
    .data_in(data_in),
    .address_w(address_w),
    .address_r(address_r),
    .w_en(push),
    .r_en(pop),
    .clk_in(clk_in),
    .clk_out(clk_out),
    .arst(arst),
    
    .data_o(data_o)
);

endmodule