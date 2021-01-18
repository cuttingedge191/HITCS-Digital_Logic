`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/30 19:54:36
// Design Name: 
// Module Name: Countdown
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//倒计时处理模块（5s)
//输入为分频后时钟信号及使能控制信号，输出为7段数码管对应七位信号及超时信号
module Countdown(
    input CP,
    input En,
    output reg [2:0] state,  //当前状态
    output reg t_up
    );
//初始化
initial
begin
    t_up = 1'b0;
    state = 3'b000;
end
always @(posedge CP)
begin
    if(En)  //功能实现
    begin
        if(state == 3'b110)
        begin
            t_up = 1'b1;
            state = 3'b000;
        end
        else
            state = state + 3'b001;
    end
    else if(!En)  //复位
    begin
        t_up = 1'b0;
        state = 3'b000;
    end
end
endmodule
