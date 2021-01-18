`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/07 19:55:48
// Design Name: 
// Module Name: Display
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

//数码管显示模块
//输入系统的状态信息，输出数码管显示所需的信号
module Display(
    input [1:0] st_lock,  //锁状态
    input [2:0] st_cd,    //倒计时状态
    input st_set,         //密码设置状态
    input [1:0] st_err,   //密码错误次数输入
    input Clk,            //时钟输入
    output reg [6:0] dis_h,  //较高四位数码管显示信号
    output reg [6:0] dis_l,  //较低四位数码管显示信号
    output reg [7:0] select  //片选信号
    );
    reg [6:0] Lock_ST1;  //锁状态显示暂存1
    reg [6:0] Lock_ST2;  //锁状态显示暂存2
    reg [6:0] Lock_ST3;  //锁状态显示暂存3
    reg [6:0] Err_ST1;   //错误次数显示暂存1
    reg [6:0] Err_ST2;   //错误次数显示暂存2
    reg [15:0] Clk1;      //简易分频
initial
begin
    dis_h = 0;
    dis_l = 0;
    select = 8'b00100001;
    Lock_ST1 = 0;
    Lock_ST2 = 0;
    Lock_ST3 = 0;
    Err_ST1 = 0;
    Err_ST2 = 0;
    Clk1 = 0;
end
//简单分频生成
always@(posedge Clk)
begin
    Clk1 = Clk1 + 16'b0000000000000001;
end
//修改片选信号，实现各位数码管循环显示
always@ (posedge Clk1[15])
begin
    case(select)
    8'b00100001:select = 8'b01000100;
    8'b01000100:select = 8'b10001000;
    8'b10001000:select = 8'b00100001;
    default:select = 8'b00100001;
    endcase
end
//更新锁状态显示内容
always@ (posedge Clk1[7])
begin
    if(st_set)  //PSE（设置密码）
    begin
        Lock_ST1 = 7'b1100111;
        Lock_ST2 = 7'b1011011;
        Lock_ST3 = 7'b1001111;
    end
    else if(st_lock == 2'b00)  //LOC（闭锁）
    begin
        Lock_ST1 = 7'b0001110;
        Lock_ST2 = 7'b1111110;
        Lock_ST3 = 7'b1001110;
    end
    else if(st_lock == 2'b01)  //INP（输入密码）
    begin
        Lock_ST1 = 7'b0110000;
        Lock_ST2 = 7'b1110110;
        Lock_ST3 = 7'b1100111;
    end
    else if(st_lock == 2'b10)  //EEE（锁死）
    begin
        Lock_ST1 = 7'b1001111;
        Lock_ST2 = 7'b1001111;
        Lock_ST3 = 7'b1001111;
    end
    else if(st_lock == 2'b11)  //UNL（开锁）
    begin
        Lock_ST1 = 7'b0111110;
        Lock_ST2 = 7'b1110110;
        Lock_ST3 = 7'b0001110;
    end
end
//更新失败次数
always@ (posedge Clk1[7])
begin
    if(st_err == 2'b00)  //不显示
    begin
        Err_ST1 = 0;
        Err_ST2 = 0;
    end
    else if(st_err == 2'b01)  //E1
    begin
        Err_ST1 = 7'b1001111;
        Err_ST2 = 7'b0110000;
    end
    else if(st_err == 2'b10)  //E2
    begin
        Err_ST1 = 7'b1001111;
        Err_ST2 = 7'b1101101;
    end
    else if(st_err == 2'b11)  //E3
    begin
        Err_ST1 = 7'b1001111;
        Err_ST2 = 7'b1111001;
    end
end
//显示信号处理
always@ (negedge Clk1[7])
begin
    if(select == 8'b00100001)
    begin
        dis_h = Lock_ST3;
        case(st_cd)
        //倒计时显示
        3'b000:dis_l = 7'b0000000;  //不显示倒计时情况
        3'b001:dis_l = 7'b1011011;  //显示5
        3'b010:dis_l = 7'b0110011;  //显示4
        3'b011:dis_l = 7'b1111001;  //显示3
        3'b100:dis_l = 7'b1101101;  //显示2
        3'b101:dis_l = 7'b0110000;  //显示1
        3'b110:dis_l = 7'b1111110;  //显示0
        default:dis_l = 7'b0000000;
        endcase
    end
    else if(select == 8'b01000100)
    begin
        dis_h = Lock_ST2;
        dis_l = Err_ST2;
    end
    else if(select == 8'b10001000)
    begin
        dis_h = Lock_ST1;
        dis_l = Err_ST1;
    end
end
endmodule