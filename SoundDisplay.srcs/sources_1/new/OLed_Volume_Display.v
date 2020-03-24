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
    integer counter_screen = 'd6143;
    always @ (posedge clk6p25m) begin
        counter_screen = (counter_screen==6143) ? 0 : counter_screen + 1;
        if ((counter_screen % 96 < 30) || (65 < counter_screen % 96)) begin
            oled_data = {5'd0, 6'd0, 5'd0};
        end else if (30 <= counter_screen % 96 && counter_screen % 96 <= 65) begin
            oled_data = {5'd0, 6'd0, 5'd0};
            if (num >= 0)
                oled_data = (counter_screen / 96 >  0 && counter_screen / 96 <  4) ? { 5'd0, ~6'd0, 5'd0}  : {5'd0, 6'd0, 5'd0};
            if (num >= 1)
                oled_data = (counter_screen / 96 >  4 && counter_screen / 96 <  8) ? { 5'd0, ~6'd0, 5'd0}  : {5'd0, 6'd0, 5'd0};
            if (num >= 2)
                oled_data = (counter_screen / 96 >  8 && counter_screen / 96 < 12) ? { 5'd0, ~6'd0, 5'd0}  : {5'd0, 6'd0, 5'd0};
            if (num >= 3)
                oled_data = (counter_screen / 96 > 12 && counter_screen / 96 < 16) ? { 5'd0, ~6'd0, 5'd0}  : {5'd0, 6'd0, 5'd0};
            if (num >= 4)
                oled_data = (counter_screen / 96 > 16 && counter_screen / 96 < 20) ? { 5'd0, ~6'd0, 5'd0}  : {5'd0, 6'd0, 5'd0};
            if (num >= 5)
                oled_data = (counter_screen / 96 > 20 && counter_screen / 96 < 24) ? { 5'd0, ~6'd0, 5'd0}  : {5'd0, 6'd0, 5'd0};
            if (num >= 6)
                oled_data = (counter_screen / 96 > 24 && counter_screen / 96 < 28) ? {~5'd0, ~6'd0, 5'd0}  : {5'd0, 6'd0, 5'd0};
            if (num >= 7)
                oled_data = (counter_screen / 96 > 28 && counter_screen / 96 < 32) ? {~5'd0, ~6'd0, 5'd0}  : {5'd0, 6'd0, 5'd0};
            if (num >= 8)
                oled_data = (counter_screen / 96 > 32 && counter_screen / 96 < 36) ? {~5'd0, ~6'd0, 5'd0}  : {5'd0, 6'd0, 5'd0};
            if (num >= 9)
                oled_data = (counter_screen / 96 > 36 && counter_screen / 96 < 40) ? {~5'd0, ~6'd0, 5'd0}  : {5'd0, 6'd0, 5'd0};
            if (num >= 10)
                oled_data = (counter_screen / 96 > 40 && counter_screen / 96 < 44) ? {~5'd0, ~6'd0, 5'd0}  : {5'd0, 6'd0, 5'd0};
            if (num >= 11)
                oled_data = (counter_screen / 96 > 44 && counter_screen / 96 < 48) ? {~5'd0,  6'd0, 5'd0}  : {5'd0, 6'd0, 5'd0};
            if (num >= 12)
                oled_data = (counter_screen / 96 > 48 && counter_screen / 96 < 52) ? {~5'd0,  6'd0, 5'd0}  : {5'd0, 6'd0, 5'd0};
            if (num >= 13)
                oled_data = (counter_screen / 96 > 52 && counter_screen / 96 < 56) ? {~5'd0,  6'd0, 5'd0}  : {5'd0, 6'd0, 5'd0};
            if (num >= 14)
                oled_data = (counter_screen / 96 > 56 && counter_screen / 96 < 60) ? {~5'd0,  6'd0, 5'd0}  : {5'd0, 6'd0, 5'd0};
            if (num >= 15)
                oled_data = (counter_screen / 96 > 60 && counter_screen / 96 < 64) ? {~5'd0,  6'd0, 5'd0}  : {5'd0, 6'd0, 5'd0};
        /*
            case (num)
                'd0 : oled_data = {5'd0, 6'd0, 5'd0};
                'd1 : oled_data = (0 < counter_screen / 96 < 4 ) ? {5'd0, 6'd1, 5'd0}  : {5'd0, 6'd0, 5'd0};
                'd2 : oled_data = (0 < counter_screen / 96 < 8 ) ? {5'd0, 6'd1, 5'd0}  : {5'd0, 6'd0, 5'd0};
                'd3 : oled_data = (0 < counter_screen / 96 < 12) ? {5'd0, 6'd1, 5'd0}  : {5'd0, 6'd0, 5'd0};
                'd4 : oled_data = (0 < counter_screen / 96 < 16) ? {5'd0, 6'd1, 5'd0}  : {5'd0, 6'd0, 5'd0};
                'd5 : oled_data = (0 < counter_screen / 96 < 20) ? {5'd0, 6'd1, 5'd0}  : {5'd0, 6'd0, 5'd0};
                'd6 : oled_data = (0 < counter_screen / 96 < 20) ? {5'd0, 6'd1, 5'd0}  : ((20 < counter_screen / 96 && counter_screen / 96 < 24) ? {5'd0, 6'd0, 5'd1}:{5'd0, 6'd0, 5'd0});
                'd7 : oled_data = (0 < counter_screen / 96 < 20) ? {5'd0, 6'd1, 5'd0}  : ((20 < counter_screen / 96 && counter_screen / 96 < 28) ? {5'd0, 6'd0, 5'd1}:{5'd0, 6'd0, 5'd0});
                'd8 : oled_data = (0 < counter_screen / 96 < 20) ? {5'd0, 6'd1, 5'd0}  : ((20 < counter_screen / 96 && counter_screen / 96 < 32) ? {5'd0, 6'd0, 5'd1}:{5'd0, 6'd0, 5'd0});
                'd9 : oled_data = (0 < counter_screen / 96 < 20) ? {5'd0, 6'd1, 5'd0}  : ((20 < counter_screen / 96 && counter_screen / 96 < 36) ? {5'd0, 6'd0, 5'd1}:{5'd0, 6'd0, 5'd0});
                'd10: oled_data = (0 < counter_screen / 96 < 20) ? {5'd0, 6'd1, 5'd0}  : ((20 < counter_screen / 96 && counter_screen / 96 < 40) ? {5'd0, 6'd0, 5'd1}:{5'd0, 6'd0, 5'd0});
                'd11: oled_data = (0 < counter_screen / 96 < 20) ? {5'd0, 6'd1, 5'd0}  : ((20 < counter_screen / 96 && counter_screen / 96 < 40) ? {5'd0, 6'd0, 5'd1}:(40 < counter_screen / 96 && counter_screen / 96 < 44) ? {5'd1, 6'd0, 5'd0} : {5'd0, 6'd0, 5'd0});
                'd12: oled_data = (0 < counter_screen / 96 < 20) ? {5'd0, 6'd1, 5'd0}  : ((20 < counter_screen / 96 && counter_screen / 96 < 40) ? {5'd0, 6'd0, 5'd1}:(40 < counter_screen / 96 && counter_screen / 96 < 48) ? {5'd1, 6'd0, 5'd0} : {5'd0, 6'd0, 5'd0});
                'd13: oled_data = (0 < counter_screen / 96 < 20) ? {5'd0, 6'd1, 5'd0}  : ((20 < counter_screen / 96 && counter_screen / 96 < 40) ? {5'd0, 6'd0, 5'd1}:(40 < counter_screen / 96 && counter_screen / 96 < 52) ? {5'd1, 6'd0, 5'd0} : {5'd0, 6'd0, 5'd0});
                'd14: oled_data = (0 < counter_screen / 96 < 20) ? {5'd0, 6'd1, 5'd0}  : ((20 < counter_screen / 96 && counter_screen / 96 < 40) ? {5'd0, 6'd0, 5'd1}:(40 < counter_screen / 96 && counter_screen / 96 < 56) ? {5'd1, 6'd0, 5'd0} : {5'd0, 6'd0, 5'd0});
                'd15: oled_data = (0 < counter_screen / 96 < 20) ? {5'd0, 6'd1, 5'd0}  : ((20 < counter_screen / 96 && counter_screen / 96 < 40) ? {5'd0, 6'd0, 5'd1}:(40 < counter_screen / 96 && counter_screen / 96 < 60) ? {5'd1, 6'd0, 5'd0} : {5'd0, 6'd0, 5'd0});
                default: oled_data = 16'b1; 
            endcase
        */
        end
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