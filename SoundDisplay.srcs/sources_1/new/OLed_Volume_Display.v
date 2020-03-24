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

`define CTDefaultVolumeBarL { 5'd0, ~6'd0, 5'd0}
`define CTDefaultVolumeBarM {~5'd0, ~6'd0, 5'd0}
`define CTDefaultVolumeBarH {~5'd0,  6'd0, 5'd0}
`define CTDefaultBackground 16'd0
`define CTDefaultBorder     ~16'd0

`define CTLugeVolumeBarL    { 5'd5, 6'd50, 5'd0 }
`define CTLugeVolumeBarM    {5'd28, 6'd31, 5'd0 }
`define CTLugeVolumeBarH    {5'd30, 6'd0 , 5'd6 }
`define CTLugeBackground    { 5'd1, 6'd5 , 5'd14}
`define CTLugeBorder        { 5'd0, 6'd63, 5'd22}

`define CTRochorVolumeBarL  {5'd11, 6'd24, 5'd13} //(89,97,110)
`define CTRochorVolumeBarM  {5'd12, 6'd22, 5'd14} //(103,89,117)
`define CTRochorVolumeBarH  {5'd10, 6'd27, 5'd13} //(84,111,110)
`define CTRochorBackground  16'd103               //103
`define CTRochorBorder      16'd9825              //\u9825

module OLed_Volume_Display(
    input en,
    input rst,
    input CLK100MHZ,
    input [3:0] num,
    input border_on,       //done
    input volume_bar_on,   //done
    input other_on,                            //todo.....................
    input [1:0] theme_sel, //done
    output [7:0] JB
    );
    
    reg [15:0] color_volumebar_l;
    reg [15:0] color_volumebar_m;
    reg [15:0] color_volumebar_h;
    reg [15:0] color_bg;
    reg [15:0] color_bd;
    
    always @ (theme_sel) begin
        case ( theme_sel )
            'd0 : begin
                      color_volumebar_l <= volume_bar_on ? `CTDefaultVolumeBarL : `CTDefaultBackground;
                      color_volumebar_m <= volume_bar_on ? `CTDefaultVolumeBarM : `CTDefaultBackground;
                      color_volumebar_h <= volume_bar_on ? `CTDefaultVolumeBarH : `CTDefaultBackground;
                      color_bg          <= `CTDefaultBackground;
                      color_bd          <= border_on     ? `CTDefaultBorder : `CTDefaultBackground;
                  end
            'd1 : begin
                      color_volumebar_l <= volume_bar_on ? `CTDefaultVolumeBarL : `CTDefaultBackground;
                      color_volumebar_m <= volume_bar_on ? `CTDefaultVolumeBarM : `CTDefaultBackground;
                      color_volumebar_h <= volume_bar_on ? `CTDefaultVolumeBarH : `CTDefaultBackground;
                      color_bg          <= `CTDefaultBackground;
                      color_bd          <= border_on     ? `CTDefaultBorder : `CTDefaultBackground;
                  end
            'd2 : begin
                      color_volumebar_l <= volume_bar_on ? `CTLugeVolumeBarL : `CTLugeBackground;
                      color_volumebar_m <= volume_bar_on ? `CTLugeVolumeBarM : `CTLugeBackground;
                      color_volumebar_h <= volume_bar_on ? `CTLugeVolumeBarH : `CTLugeBackground;
                      color_bg          <=`CTLugeBackground;
                      color_bd          <= border_on ? `CTLugeBorder : `CTLugeBackground;
                  end
            'd3 : begin
                      color_volumebar_l <= volume_bar_on ? `CTRochorVolumeBarL : `CTRochorBackground;
                      color_volumebar_m <= volume_bar_on ? `CTRochorVolumeBarM : `CTRochorBackground;
                      color_volumebar_h <= volume_bar_on ? `CTRochorVolumeBarH : `CTRochorBackground;
                      color_bg          <= volume_bar_on ? `CTRochorBackground : `CTRochorBackground;
                      color_bg          <=`CTRochorBackground;
                      color_bd          <= border_on ? `CTRochorBorder : `CTRochorBackground;
                  end
        endcase
    end

    reg clk6p25m;
    integer counter_2 = 'd15;
    always @ (posedge CLK100MHZ) begin
        counter_2 <= ( counter_2 == 0 )     ? 'd15     : counter_2 - 1;
        clk6p25m  <= ( counter_2 <  8   )   ? 'd1      : 'd0;
    end
    
    reg [15:0] oled_data = 'd0;
    wire [12:0] pixel_index;
    always @ (pixel_index) begin
        if (pixel_index<'d96 || pixel_index>'d6047 || pixel_index%96==0 || pixel_index%96==95) begin
            oled_data = color_bd;
        end else if ((pixel_index % 96 < 30) || (65 < pixel_index % 96)) begin
            oled_data = color_bg;
        end else if (30 <= pixel_index % 96 && pixel_index % 96 <= 65) begin
            oled_data = color_bg;
            if (pixel_index / 96 < 64 && pixel_index / 96 > 60)
                oled_data = num >=  0 ? color_volumebar_l  : color_bg;
            else if (pixel_index / 96 < 60 && pixel_index / 96 > 56)
                oled_data = num >=  1 ? color_volumebar_l  : color_bg;
            else if (pixel_index / 96 < 56 && pixel_index / 96 > 52)
                oled_data = num >=  2 ? color_volumebar_l  : color_bg;
            else if (pixel_index / 96 < 52 && pixel_index / 96 > 48)
                oled_data = num >=  3 ? color_volumebar_l  : color_bg;
            else if (pixel_index / 96 < 48 && pixel_index / 96 > 44)
                oled_data = num >=  4 ? color_volumebar_l  : color_bg;
            else if (pixel_index / 96 < 44 && pixel_index / 96 > 40)
                oled_data = num >=  5 ? color_volumebar_l  : color_bg;
            else if (pixel_index / 96 < 40 && pixel_index / 96 > 36)
                oled_data = num >=  6 ? color_volumebar_m  : color_bg;
            else if (pixel_index / 96 < 36 && pixel_index / 96 > 32)
                oled_data = num >=  7 ? color_volumebar_m  : color_bg;
            else if (pixel_index / 96 < 32 && pixel_index / 96 > 28)
                oled_data = num >=  8 ? color_volumebar_m  : color_bg;
            else if (pixel_index / 96 < 28 && pixel_index / 96 > 24)
                oled_data = num >=  9 ? color_volumebar_m  : color_bg;
            else if (pixel_index / 96 < 24 && pixel_index / 96 > 20)
                oled_data = num >= 10 ? color_volumebar_m  : color_bg;
            else if (pixel_index / 96 < 20 && pixel_index / 96 > 16)
                oled_data = num >= 11 ? color_volumebar_h  : color_bg;
            else if (pixel_index / 96 < 16 && pixel_index / 96 > 12)
                oled_data = num >= 12 ? color_volumebar_h  : color_bg;
            else if (pixel_index / 96 < 12 && pixel_index / 96 >  8)
                oled_data = num >= 13 ? color_volumebar_h  : color_bg;
            else if (pixel_index / 96 <  8 && pixel_index / 96 >  4)
                oled_data = num >= 14 ? color_volumebar_h  : color_bg;
            else if (pixel_index / 96 <  4 && pixel_index / 96 >  0)
                oled_data = num >= 15 ? color_volumebar_h  : color_bg;
        end
    end
    
    wire ha1, ha2, ha3, ha4;
    Oled_Display  od ( .clk(clk6p25m),
                       .reset(rst),
                       .frame_begin(ha1),
                       .sending_pixels(ha2),
                       .sample_pixel(ha3),
                       .pixel_index(pixel_index),
                       .pixel_data(oled_data),
                       .cs(JB[0]),
                       .sdin(JB[1]),
                       .sclk(JB[3]),
                       .d_cn(JB[4]),
                       .resn(JB[5]),
                       .vccen(JB[6]),
                       .pmoden(JB[7]),
                       .teststate(ha4) );
    
endmodule