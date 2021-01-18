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
    input Clk,             //������ʱ��
    input [7:0] pw_8,      //��������
    input confirm,         //��������ȷ��
    input pw_set,          //���������ź�
    input lock,            //��������
    input reset,           //������λ����
    output reg green,      //�̵�ָʾ
    output reg red,        //���ָʾ
    output reg alarm,      //����ָʾ
    output [6:0] Dis_h,    //��λ�������ʾ
    output [6:0] Dis_l,    //��λ�������ʾ
    output [7:0] Select,   //�����Ƭѡ�ź�
    output [4:0] test_op   //����
    );
    wire CP;               //��Ƶ��ʱ���ź�
    wire En_CD;            //����ʱʹ���ź�
    wire En_PC;            //��������ʹ���ź�
    wire timeup;           //����ʱ�����ź�
    wire [6:0] t_display;  //����ʱ�������ʾ�ź�
    wire [5:0] key;        //��ȷ����
    wire [2:0] status_CD;  //����ʱ״̬
    wire [1:0] status_PC;  //������״̬
    wire status_PS;        //��������״̬
    wire conf;             //��������ȷ�ϣ���ֹ���ź�
    wire [1:0] err;        //�����������ź�
//���ҽ���������������״̬ʱ���е���ʱ
assign En_CD = (status_PC[0]) & (!status_PC[1]);
//���ҽ�������δ������Ρ�δ������δ������������ģʽʱ���������뿪��
assign En_PC = (!status_PS) & (!status_PC[1]);
//��������״̬�µ��ֶ�����ȷ�ϼ��򵹼�ʱ����ʱ������������ȷ��
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
//���̵Ƽ�����
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
