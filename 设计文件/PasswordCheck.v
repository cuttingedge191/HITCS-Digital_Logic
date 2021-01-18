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

//������������ģ��
//���룺ʱ�ӡ�8λ���루6λ��Ч����ʹ���źš�ȷ���źš������źš�������λ�źš���ȷ����
//�������״̬������00��������������01���������δ���10��������ȷ11�����������������op�ǵ��������
module PasswordCheck(
    input Clk,
    input [7:0] in_8,
    input En,
    input Confirm,  //ȷ�ϼ�
    input Lock,     //������
    input Res,      //������λ��
    input [5:0] pw_6,
    output reg [1:0] status,     //��¼��״̬
    output reg [1:0] ErrCounter, //��¼����������
    output reg [4:0] op          //��¼Ӧ����һ��Ч���ؽ��еĲ���
    );
    reg [7:0] tmp;  //���濪ʼ��������ǰ�������У����ڼ���Ƿ�ʼ����
    //reg [4:0] op;   //��¼Ӧ����һ��Ч���ؽ��еĲ���
    reg [4:0] pre;  //��¼��һ��Ч���ؽ���ʱ�ļ�¼״̬
initial
begin
    op = 5'b00000;
    status = 2'b00;
    ErrCounter = 0;
    tmp = 0;
    pre = 0;
end
//��λ������¼
always @(posedge Res)
begin
    if(status == 2'b10)
        op[0] <= !op[0];
end
//����Ƿ�ʱ����ȷ�ϣ�����¼ & �����һ�������޸ĺ󱣴��޸ĺ������ֵ
always @(posedge Confirm or posedge En)
begin
    tmp <= in_8;   //���¿�������ֵ��¼
    if(Confirm)
    begin
        if(status == 2'b01)
            op[1] <= !op[1];
    end
end
//����Ƿ��¹�����������¼
always @(posedge Lock)
begin
    if(status == 2'b11)
        op[2] <= !op[2];
end
//����Ƿ�ʼ��������������������Ƿ�ﵽ���Σ�����¼
always @(posedge Clk)
begin
    if(En && !status[0] && (in_8 != tmp))
        op[3] <= !op[3];
    else if(ErrCounter == 2'b11)
        op[4] <= !op[4];
end
//��״̬�޸ļ�����ִ�в���
always @(negedge Clk)
begin
    if(op != pre)  //����Ƿ���Ҫ���в���
    begin
        if(op[1] != pre[1])
        begin  //������
            if(in_8[5:0] == pw_6)
            begin
                ErrCounter <= 2'b00;
                status <= 2'b11;  //������ȷ
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
		status <= 2'b00;               //��������״̬
            end
        end
        else if(op[0] != pre[0])  //��λ
        begin
            ErrCounter <= 2'b00;
            status <= 2'b00;
        end
        else if(op[2] != pre[2])  //����
        begin
            ErrCounter <= 2'b00;
            status <= 2'b00;
        end
        else if(op[3] != pre[3])  //������������״̬
        begin
            status <= 2'b01;
        end
        else if(op[4] != pre[4])  //��������״̬
        begin
            status <= 2'b10;
        end
        pre = op;
    end
end
endmodule
