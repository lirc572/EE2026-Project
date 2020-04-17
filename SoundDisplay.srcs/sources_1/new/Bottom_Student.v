`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//
//  LAB SESSION DAY (Delete where applicable): MONDAY P.M, TUESDAY P.M, WEDNESDAY P.M, THURSDAY A.M., THURSDAY P.M
//
//  STUDENT A NAME: 
//  STUDENT A MATRICULATION NUMBER: 
//
//  STUDENT B NAME: 
//  STUDENT B MATRICULATION NUMBER: 
//
//////////////////////////////////////////////////////////////////////////////////


module Bottom_Student (
    input  CLK100MHZ,
    input  [15:0] sw,
    input  btnC,
    input  btnU,
    input  btnL,
    input  btnR,
    input  btnD,
    input  [11:0] mic_in,
    input  [ 3:0] volume,
    output [15:0] led,
    output [ 6:0] seg,
    output dp,
    output [3:0] an,
    output [15:0] oled_data,
    input [12:0] pixel_index,
    input next
    );
    wire [15:0] ledout;
    assign led = sw[0] ? {4'd0, mic_in} : ledout;
    wire rst;
    SPO bl ( CLK100MHZ, btnC, rst );
    OLed_Volume_Display ovd ( .en(1),
                              .CLK100MHZ(CLK100MHZ),
                              .num(volume),
                              .border_on(sw[1]),
                              .volume_bar_on(sw[2]),
                              .theme_sel(sw[5:4]),
                              .oled_data(oled_data),
                              .pixel_index(pixel_index),
                              .freeze(sw[14]),
                              .border_sel(sw[3]),
                              .next(next) );
    
    SegDisp sd ( .en(1),
                 .CLK100MHZ(CLK100MHZ),
                 .num(volume),
                 .seg(seg),
                 .dp(dp),
                 .an(an) );
    
    Led ld ( .en(1),
             .num(volume),
             .leds(ledout) );
    
endmodule