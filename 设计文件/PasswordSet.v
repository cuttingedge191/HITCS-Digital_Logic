`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/30 20:45:54
// Design Name: 
// Module Name: PasswordSet
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

//密码设置模块
//输入要设置的新密码、设置信号，输出设置后新密码及设置状态信号
module PasswordSet(
    input [5:0] rpw_6,
    input Set,
    output reg [5:0] npw_6,
    output reg status
    );
//初始化
initial
begin
    npw_6 = 6'b000000;
    status = 1'b0;
end
//进入\退出密码设置状态
always @(posedge Set)
begin
    status = !status;
end
//设置密码
always @(negedge status)
begin
    npw_6 = rpw_6;
end
endmodule
