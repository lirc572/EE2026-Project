`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2020 09:06:19 PM
// Design Name: 
// Module Name: led
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


module Led(
    input en,
    input [3:0] num,
    output [15:0] leds
    );
    assign leds[0]  = en ? num >= 0  : 0;
    assign leds[1]  = en ? num >= 1  : 0;
    assign leds[2]  = en ? num >= 2  : 0;
    assign leds[3]  = en ? num >= 3  : 0;
    assign leds[4]  = en ? num >= 4  : 0;
    assign leds[5]  = en ? num >= 5  : 0;
    assign leds[6]  = en ? num >= 6  : 0;
    assign leds[7]  = en ? num >= 7  : 0;
    assign leds[8]  = en ? num >= 8  : 0;
    assign leds[9]  = en ? num >= 9  : 0;
    assign leds[10] = en ? num >= 10 : 0;
    assign leds[11] = en ? num >= 11 : 0;
    assign leds[12] = en ? num >= 12 : 0;
    assign leds[13] = en ? num >= 13 : 0;
    assign leds[14] = en ? num >= 14 : 0;
    assign leds[15] = en ? num >= 15 : 0;
    /*
    genvar i;
    for (i=0; i<=15; i=i+1) begin
        assign leds[i] = en ? num >= i : 0;
    end*/
endmodule
