`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/30 20:59:44
// Design Name: 
// Module Name: PasswordCheck
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

//密码输入与检查模块
//输入：时钟、8位代码（6位有效）、使能信号、确认信号、关锁信号、锁死复位信号、正确密码
//输出：锁状态（闲置00、正在输入密码01、输入三次错误10、输入正确11）、错误次数计数（op是调试输出）
module PasswordCheck(
    input Clk,
    input [7:0] in_8,
    input En,
    input Confirm,  //确认键
    input Lock,     //关锁键
    input Res,      //锁死复位键
    input [5:0] pw_6,
    output reg [1:0] status,     //记录锁状态
    output reg [1:0] ErrCounter, //记录密码输错次数
    output reg [4:0] op          //记录应在下一有效边沿进行的操作
    );
    reg [7:0] tmp;  //保存开始输入密码前代码序列，用于检测是否开始输入
    //reg [4:0] op;   //记录应在下一有效边沿进行的操作
    reg [4:0] pre;  //记录上一有效边沿进行时的记录状态
initial
begin
    op = 5'b00000;
    status = 2'b00;
    ErrCounter = 0;
    tmp = 0;
    pre = 0;
end
//复位操作记录
always @(posedge Res)
begin
    if(status == 2'b10)
        op[0] <= !op[0];
end
//检测是否超时或按下确认，并记录 & 在完成一次输入修改后保存修改后的输入值
always @(posedge Confirm or posedge En)
begin
    tmp <= in_8;   //更新开关输入值记录
    if(Confirm)
    begin
        if(status == 2'b01)
            op[1] <= !op[1];
    end
end
//检测是否按下关锁键，并记录
always @(posedge Lock)
begin
    if(status == 2'b11)
        op[2] <= !op[2];
end
//检测是否开始输入密码或密码错误次数是否达到三次，并记录
always @(posedge Clk)
begin
    if(En && !status[0] && (in_8 != tmp))
        op[3] <= !op[3];
    else if(ErrCounter == 2'b11)
        op[4] <= !op[4];
end
//锁状态修改及功能执行部分
always @(negedge Clk)
begin
    if(op != pre)  //检测是否需要进行操作
    begin
        if(op[1] != pre[1])
        begin  //密码检测
            if(in_8[5:0] == pw_6)
            begin
                ErrCounter <= 2'b00;
                status <= 2'b11;  //密码正确
            end
            else
            begin
                if(ErrCounter == 2'b00)
                    ErrCounter <= 2'b01;
                else if(ErrCounter == 2'b01)
                    ErrCounter <= 2'b10;
                else if(ErrCounter == 2'b10)
                    ErrCounter <= 2'b11;
                else ErrCounter = ErrCounter + 1;
		status <= 2'b00;               //进入闲置状态
            end
        end
        else if(op[0] != pre[0])  //复位
        begin
            ErrCounter <= 2'b00;
            status <= 2'b00;
        end
        else if(op[2] != pre[2])  //关锁
        begin
            ErrCounter <= 2'b00;
            status <= 2'b00;
        end
        else if(op[3] != pre[3])  //进入密码输入状态
        begin
            status <= 2'b01;
        end
        else if(op[4] != pre[4])  //进入锁死状态
        begin
            status <= 2'b10;
        end
        pre = op;
    end
end
endmodule
