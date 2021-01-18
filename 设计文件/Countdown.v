`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/30 19:54:36
// Design Name: 
// Module Name: Countdown
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

//����ʱ����ģ�飨5s)
//����Ϊ��Ƶ��ʱ���źż�ʹ�ܿ����źţ����Ϊ7������ܶ�Ӧ��λ�źż���ʱ�ź�
module Countdown(
    input CP,
    input En,
    output reg [2:0] state,  //��ǰ״̬
    output reg t_up
    );
//��ʼ��
initial
begin
    t_up = 1'b0;
    state = 3'b000;
end
always @(posedge CP)
begin
    if(En)  //����ʵ��
    begin
        if(state == 3'b110)
        begin
            t_up = 1'b1;
            state = 3'b000;
        end
        else
            state = state + 3'b001;
    end
    else if(!En)  //��λ
    begin
        t_up = 1'b0;
        state = 3'b000;
    end
end
endmodule
