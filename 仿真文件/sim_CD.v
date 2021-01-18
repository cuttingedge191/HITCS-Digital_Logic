`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/08 21:49:31
// Design Name: 
// Module Name: sim_CD
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


module sim_CD();
    reg CP, En;
    wire [2:0] st_cd;
    wire t_up;
Countdown test(CP, En, st_cd, t_up);
initial
begin
    CP = 0;
    En = 1;
end
always #10
begin
    CP = !CP;
end
always #1000
begin
    En = !En;
end
endmodule
