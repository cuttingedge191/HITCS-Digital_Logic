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

//�������ʾģ��
//����ϵͳ��״̬��Ϣ������������ʾ������ź�
module Display(
    input [1:0] st_lock,  //��״̬
    input [2:0] st_cd,    //����ʱ״̬
    input st_set,         //��������״̬
    input [1:0] st_err,   //��������������
    input Clk,            //ʱ������
    output reg [6:0] dis_h,  //�ϸ���λ�������ʾ�ź�
    output reg [6:0] dis_l,  //�ϵ���λ�������ʾ�ź�
    output reg [7:0] select  //Ƭѡ�ź�
    );
    reg [6:0] Lock_ST1;  //��״̬��ʾ�ݴ�1
    reg [6:0] Lock_ST2;  //��״̬��ʾ�ݴ�2
    reg [6:0] Lock_ST3;  //��״̬��ʾ�ݴ�3
    reg [6:0] Err_ST1;   //���������ʾ�ݴ�1
    reg [6:0] Err_ST2;   //���������ʾ�ݴ�2
    reg [15:0] Clk1;      //���׷�Ƶ
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
//�򵥷�Ƶ����
always@(posedge Clk)
begin
    Clk1 = Clk1 + 16'b0000000000000001;
end
//�޸�Ƭѡ�źţ�ʵ�ָ�λ�����ѭ����ʾ
always@ (posedge Clk1[15])
begin
    case(select)
    8'b00100001:select = 8'b01000100;
    8'b01000100:select = 8'b10001000;
    8'b10001000:select = 8'b00100001;
    default:select = 8'b00100001;
    endcase
end
//������״̬��ʾ����
always@ (posedge Clk1[7])
begin
    if(st_set)  //PSE���������룩
    begin
        Lock_ST1 = 7'b1100111;
        Lock_ST2 = 7'b1011011;
        Lock_ST3 = 7'b1001111;
    end
    else if(st_lock == 2'b00)  //LOC��������
    begin
        Lock_ST1 = 7'b0001110;
        Lock_ST2 = 7'b1111110;
        Lock_ST3 = 7'b1001110;
    end
    else if(st_lock == 2'b01)  //INP���������룩
    begin
        Lock_ST1 = 7'b0110000;
        Lock_ST2 = 7'b1110110;
        Lock_ST3 = 7'b1100111;
    end
    else if(st_lock == 2'b10)  //EEE��������
    begin
        Lock_ST1 = 7'b1001111;
        Lock_ST2 = 7'b1001111;
        Lock_ST3 = 7'b1001111;
    end
    else if(st_lock == 2'b11)  //UNL��������
    begin
        Lock_ST1 = 7'b0111110;
        Lock_ST2 = 7'b1110110;
        Lock_ST3 = 7'b0001110;
    end
end
//����ʧ�ܴ���
always@ (posedge Clk1[7])
begin
    if(st_err == 2'b00)  //����ʾ
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
//��ʾ�źŴ���
always@ (negedge Clk1[7])
begin
    if(select == 8'b00100001)
    begin
        dis_h = Lock_ST3;
        case(st_cd)
        //����ʱ��ʾ
        3'b000:dis_l = 7'b0000000;  //����ʾ����ʱ���
        3'b001:dis_l = 7'b1011011;  //��ʾ5
        3'b010:dis_l = 7'b0110011;  //��ʾ4
        3'b011:dis_l = 7'b1111001;  //��ʾ3
        3'b100:dis_l = 7'b1101101;  //��ʾ2
        3'b101:dis_l = 7'b0110000;  //��ʾ1
        3'b110:dis_l = 7'b1111110;  //��ʾ0
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