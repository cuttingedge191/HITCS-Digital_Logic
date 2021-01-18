`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/10 00:01:06
// Design Name: 
// Module Name: sim_PC
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


module sim_PC();
reg Clk;
reg [7:0] in_8;
reg En;
reg Confirm;
reg Lock;
reg Res;
reg [5:0] pw_6;
wire [4:0] op;
wire [1:0] status;
wire [1:0] ECounter;
initial
begin
    Clk = 0;
    in_8 = 0;
    En = 0;
    Confirm = 0;
    Lock = 0;
    Res = 0;
    pw_6 = 6'b010101;
end
PasswordCheck test(Clk, in_8, En, Confirm, Lock, Res, pw_6, status, ECounter, op);
always #1
    Clk = ! Clk;
always #1000
    En = !En;
always #5
begin
    in_8 = in_8 + 1;
    Confirm = !Confirm;
end
endmodule
