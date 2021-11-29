`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: 尘世
//
// Create Date: 2021/11/25  11：43
// Design Name: Gray
// Module Name: Gray
// Project Name: FIFO
// Target Devices:
// Tool Versions:
// Description:
// 将二进制转化为格雷码
// Dependencies:
// Revision:
// Revision 0.01 - File Created
// 完成基本框架
// Additional Comments:
//
// 
//////////////////////////////////////////////////////////////////////////////////

module Gray #(
    parameter N=8
) (
    input [N-1:0] Bin,
    output [N-1:0] GrayBin
);
    assign GrayBin = Bin^{1'b0,Bin[N-1:1]};
endmodule