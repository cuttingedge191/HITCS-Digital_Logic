`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/13 14:42:19
// Design Name: 
// Module Name: sim_pwset
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


module sim_pwset();
reg [5:0] pw_6;
reg set;
wire [5:0] npw;
wire status;
initial
begin
    pw_6 = 0;
    set = 0;
end
PasswordSet test (pw_6, set, npw, status);
always #10
begin
    set = !set;
end
always #5
begin
    pw_6 = pw_6 + 1;
end
endmodule
