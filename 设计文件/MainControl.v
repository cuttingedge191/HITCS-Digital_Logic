`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/01 20:20:15
// Design Name: 
// Module Name: MainControl
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


module MainControl(
    input Clk,             //开发板时钟
    input [7:0] pw_8,      //密码输入
    input confirm,         //密码输入确认
    input pw_set,          //密码设置信号
    input lock,            //关锁按键
    input reset,           //锁死复位按键
    output reg green,      //绿灯指示
    output reg red,        //红灯指示
    output reg alarm,      //报警指示
    output [6:0] Dis_h,    //高位数码管显示
    output [6:0] Dis_l,    //低位数码管显示
    output [7:0] Select,   //数码管片选信号
    output [4:0] test_op   //调试
    );
    wire CP;               //分频后时钟信号
    wire En_CD;            //倒计时使能信号
    wire En_PC;            //密码输入使能信号
    wire timeup;           //倒计时结束信号
    wire [6:0] t_display;  //倒计时数码管显示信号
    wire [5:0] key;        //正确密码
    wire [2:0] status_CD;  //倒计时状态
    wire [1:0] status_PC;  //密码检测状态
    wire status_PS;        //密码设置状态
    wire conf;             //密码输入确认（终止）信号
    wire [1:0] err;        //密码错误次数信号
//当且仅当处于密码输入状态时进行倒计时
assign En_CD = (status_PC[0]) & (!status_PC[1]);
//当且仅当密码未输错三次、未开锁且未处于设置密码模式时可输入密码开锁
assign En_PC = (!status_PS) & (!status_PC[1]);
//密码输入状态下当手动按下确认键或倒计时结束时进行密码输入确认
assign conf = (confirm | timeup) & En_PC;
CPGenerator CP_Generator(Clk, CP);
Countdown Count_Down (CP, En_CD, status_CD, timeup);
PasswordCheck PW_Check (Clk, pw_8, En_PC, conf, lock, reset, key, status_PC, err, test_op);
PasswordSet PW_Set({pw_8[5], pw_8[4], pw_8[3], pw_8[2], pw_8[1], pw_8[0]}, pw_set, key, status_PS);
Display Dis(status_PC, status_CD, status_PS, err, Clk, Dis_h, Dis_l, Select);
initial
begin
    green = 1'b0;
    red = 1'b0;
    alarm = 1'b0;
end
//红绿灯及警报
always @(posedge Clk)
begin
    if(status_PC[1] == 0)
    begin
        green = 1'b0;
        red = 1'b1;
        alarm = 1'b0;
    end
    else if(status_PC == 2'b10)
    begin
        green = 1'b0;
        red = 1'b1;
        alarm = 1'b1;
    end
    else if(status_PC == 2'b11)
    begin
        green = 1'b1;
        red = 1'b0;
        alarm = 1'b0;
    end
end
endmodule
