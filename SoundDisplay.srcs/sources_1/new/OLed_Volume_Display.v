`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/24/2020 04:29:32 PM
// Design Name: 
// Module Name: OLed_Volume_Display
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


module OLed_Volume_Display(
    input en,
    input rst,
    input CLK100MHZ,
    input [3:0] num,
    output [7:0] JB
    );

    reg clk6p25m;
    integer counter_2 = 'd15;
    always @ (posedge CLK100MHZ) begin
        counter_2 <= ( counter_2 == 0 )     ? 'd15     : counter_2 - 1;
        clk6p25m  <= ( counter_2 <  8   )   ? 'd1      : 'd0;
    end
    
    reg [15:0] oled_data = 'd0;
    integer ttt = 'd0;
    always @ (posedge clk6p25m) begin
        ttt = ttt==95 ? 0 : ttt + 1;
        oled_data = ttt==0 ? oled_data + 1 : oled_data;
    end
    
    wire ha1, ha2, ha3, ha4, ha5;
    Oled_Display  od ( .clk(clk6p25m),
                       .reset(rst),
                       .frame_begin(ha1),
                       .sending_pixels(ha2),
                       .sample_pixel(ha3),
                       .pixel_index(ha4),
                       .pixel_data(oled_data),
                       .cs(JB[0]),
                       .sdin(JB[1]),
                       .sclk(JB[3]),
                       .d_cn(JB[4]),
                       .resn(JB[5]),
                       .vccen(JB[6]),
                       .pmoden(JB[7]),
                       .teststate(ha5) );
    
endmodule
