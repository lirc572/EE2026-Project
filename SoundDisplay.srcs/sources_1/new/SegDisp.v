`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2020 09:01:47 PM
// Design Name: 
// Module Name: SegDisp
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

`ifndef SEGMENTDEEF
`define SEGMENTDEF
`define SegOff          ~(7'b0000000)
`define SegZero         ~(7'b0111111)
`define SegOne          ~(7'b0000110)
`define SegTwo          ~(7'b1011011)
`define SegThree        ~(7'b1001111)
`define SegFour         ~(7'b1100110)
`define SegFive         ~(7'b1101101)
`define SegSix          ~(7'b1111101)
`define SegSeven        ~(7'b0000111)
`define SegEight        ~(7'b1111111)
`define SegNine         ~(7'b1101111)
`define SegA            ~(7'b1110111)
`define SegC            ~(7'b0111001)
`define SegE            ~(7'b1111001)
`define SegH            ~(7'b1110110)
`define SegI            ~(7'b0110000)
`define SegL            ~(7'b0111000)
`define SegN            ~(7'b1010100)
`define SegO            ~(7'b0111111)
`define SegR            ~(7'b1010000)
`define SegT            ~(7'b1111000)
`define SegU            ~(7'b0111110)
`define SegY            ~(7'b1101110)
`define Activation      ~(7'b0001001)
`define QUAR            ~(7'b1001001)
`define DpOn            ~(1'b1)
`define DpOff           ~(1'b0)
`define AnOff           ~(4'b0000)
`define AnAll           ~(4'b1111)
`define AnThree         ~(4'b1000)
`define AnTwo           ~(4'b0100)
`define AnOne           ~(4'b0010)
`define AnZero          ~(4'b0001)
`endif
//Note that `SegZero == `SegO

//500.00Hz
module Clk200p00hz(
    input cin,
    output reg cout
    );
    reg [19:0] counter = 19'b0;
    always @ (posedge cin) begin
        counter <= (counter==19'b1111010000100100000) ? 19'b0 : counter + 1;
    end
    always @ (posedge cin) begin
        cout <= counter == 19'b0;
    end
endmodule

module NumToSeg (
    input [3:0] num,
    output [6:0] seg
    );
    assign seg = num==0  ? `SegZero  :
                 num==1  ? `SegOne   :
                 num==2  ? `SegTwo   :
                 num==3  ? `SegThree :
                 num==4  ? `SegFour  :
                 num==5  ? `SegFive  :
                 num==6  ? `SegSix   :
                 num==7  ? `SegSeven :
                 num==8  ? `SegEight :
                 num==9  ? `SegNine  :
                           `SegOff   ;

endmodule

module SegDisp(
    input en,
    input CLK100MHZ,
    input [3:0] num,
    output [6:0] seg,
    output dp,
    output [3:0] an
    );
    
    reg [3:0] n_reg;
    reg dp_reg = `DpOff;
    reg an_reg = `AnOff;
    wire [6:0] n2ss;
    assign seg = en ? n2ss : `SegOff;
    assign dp  = en ? dp_reg : `DpOff;
    assign an  = en ? an_reg : `AnOff;
    
    wire clk;
    //Clk200p00hz c200 (CLK100MHZ, clk);
    Clk2p00hz     c2   (CLK100MHZ, clk); //temporary slow clock
    NumToSeg n2s (n_reg, n2ss);
    reg [1:0] dig_curr = 0;
    
    always @ (posedge clk) begin
        if (dig_curr==0) begin
            n_reg <= num > 'd9 ? num - 'd10 : num;
        end else if (dig_curr==1) begin
            n_reg <= num > 'd9 ? 'd1 : 'd10;
        end else begin
            n_reg <= 'd10;
        end
    end
    
    always @ (posedge clk)
        an_reg <= dig_curr==0 ? `AnZero :
                  dig_curr==1 ? `AnOne  :
                  dig_curr==2 ? `AnTwo  :
                                `AnThree;
    
    always @ (posedge clk)
        dig_curr <= dig_curr + 1;
    
endmodule
