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
        input [DEEP:0] address_w,
        input [DEEP:0] address_r,
        input w_en,
        input r_en,
        input clk_in,
        input clk_out,
        input arst,

        output reg [N-1:0] data_o
    );
    localparam M = 2**DEEP;
    reg [N-1:0] ROM [M-1:0];//一个8位，深度为8的ROM
    reg [N-1:0] address;
    always @(posedge clk_in) begin
        address={address_w[DEEP]^address_w[DEEP-1],address_w[DEEP-2:0]};
        ROM[address]=w_en?data_in:ROM[address];
    end

    always @(posedge clk_out or posedge arst) begin
        if (arst)
            data_o=0;
        else begin
            address={address_r[DEEP]^address_r[DEEP-1],address_r[DEEP-2:0]};
            data_o=r_en?ROM[address]:data_o;
        end
    end
    ///    assign data_o=r_en?ROM[address_r]:data_o;

endmodule
