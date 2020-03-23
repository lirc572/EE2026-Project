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


module led(
    input en,
    input [3:0] num,
    output [15:0] leds
    );
    genvar i;
    for (i=0; i<=15; i=i+1) begin
        assign leds[i] = en ? num > i : 0;
    end
endmodule
