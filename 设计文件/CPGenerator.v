`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/30 19:38:11
// Design Name: 
// Module Name: CPGenerator
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

//时钟分频模块
//（输入为开发板100MHz时钟，输出为周期为1s的时钟信号）
module CPGenerator(
    input Clk,
    output reg CP
    );
    reg [25:0] counter;
//初始化
initial
begin
    CP = 1'b0;
    counter = 26'b0;
end
//时钟分频功能实现
always @(posedge Clk)
begin
    counter = counter + 26'b1;
    if(counter >= 26'd50_000_000)
    begin
        CP = !CP;
        counter = 26'b0;
    end
end               
endmodule
