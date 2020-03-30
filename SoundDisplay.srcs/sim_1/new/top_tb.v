`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2020 10:50:26 PM
// Design Name: 
// Module Name: top_tb
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


module top_tb(
    );
    reg CLK100MHZ;
    reg [15:0] sw;
    reg btnC, btnU, btnL, btnR, btnD;
    reg J_MIC3_Pin3;
    wire J_MIC3_Pin1,J_MIC3_Pin4;
    wire [15:0] led;
    wire [6:0] seg;
    wire dp;
    wire [3:0] an;
    wire [7:0] JB;
    
    initial begin
        CLK100MHZ = 0;
        sw[15]    = 0;
        btnC      = 1;
        #2 btnC   = 0;
    end
    
    always begin
        #1 CLK100MHZ = ~ CLK100MHZ;
    end
    
    Top_Student top (
        CLK100MHZ,
        sw,
        btnC,
        btnU,
        btnL,
        btnR,
        btnD,
        J_MIC3_Pin3,   // Connect from this signal to Audio_Capture.v
        J_MIC3_Pin1,   // Connect to this signal from Audio_Capture.v
        J_MIC3_Pin4,   // Connect to this signal from Audio_Capture.v
        led,
        seg,
        dp,
        an,
        JB
        );
    
endmodule
