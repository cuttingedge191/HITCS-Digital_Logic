`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/07 23:02:12
// Design Name: 
// Module Name: sim_Dis
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


module sim_Dis();
reg [1:0] stl;
reg sts;
reg [1:0] ste;
reg [6:0] cd;
reg Clk;
wire [6:0] dish;
wire [6:0] disl;
wire [7:0] Select;
Display test (stl, sts, ste, cd, Clk, dish, disl, Select);
initial
begin
    stl = 0;
    sts = 0;
    ste = 0;
    cd =  7'b1111111;
    Clk = 0;
end
always #1
begin
    Clk = !Clk;
end
always #10
begin
    stl = stl + 2'b01;
end
always #50
begin
    ste = ste + 2'b01;
end
always #100
begin
    sts = !sts;
end
endmodule
