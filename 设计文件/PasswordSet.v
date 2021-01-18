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

//��������ģ��
//����Ҫ���õ������롢�����źţ�������ú������뼰����״̬�ź�
module PasswordSet(
    input [5:0] rpw_6,
    input Set,
    output reg [5:0] npw_6,
    output reg status
    );
//��ʼ��
initial
begin
    npw_6 = 6'b000000;
    status = 1'b0;
end
//����\�˳���������״̬
always @(posedge Set)
begin
    status = !status;
end
//��������
always @(negedge status)
begin
    npw_6 = rpw_6;
end
endmodule
