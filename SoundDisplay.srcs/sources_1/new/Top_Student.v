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


module Top_Student (
    input  CLK100MHZ,
    input  [15:0] sw,
    input  btnC,
    input  btnU,
    input  btnL,
    input  btnR,
    input  btnD,
    input  J_MIC3_Pin3,   // Connect from this signal to Audio_Capture.v
    output J_MIC3_Pin1,   // Connect to this signal from Audio_Capture.v
    output J_MIC3_Pin4,   // Connect to this signal from Audio_Capture.v
    output [15:0] led,
    output [6:0]  seg,
    output dp,
    output [3:0] an,
    output [7:0] JB
    );
    
    reg clk20k;
    integer counter_1 = 'd4999;
    always @ (posedge CLK100MHZ) begin
        counter_1 <= ( counter_1 == 0 )     ? 'd4999   : counter_1 - 1;
        clk20k    <= ( counter_1 <  2500)   ? 1 : 0;
    end
    
    reg clk6p25m;
    integer counter_2 = 'd15;
    always @ (posedge CLK100MHZ) begin
        counter_2 <= ( counter_2 == 0 )     ? 'd15     : counter_2 - 1;
        clk6p25m  <= ( counter_2 <  8   )   ? 'd1      : 'd0;
    end
    
    wire [11:0] mic_in;
    wire [3:0] volume;
    
    wire [15:0] led_1;
    wire [6:0]  seg_1;
    wire [3:0]  an_1;
    wire dp_1;
    wire [15:0] oled_data_1;
    wire [15:0] led_2;
    wire [6:0]  seg_2;
    wire [3:0]  an_2;
    wire dp_2;
    wire [15:0] oled_data_2;
    
    Audio_Capture ac ( .CLK(CLK100MHZ),
                           .cs(clk20k),
                           .MISO(J_MIC3_Pin3),
                           .clk_samp(J_MIC3_Pin1),
                           .sclk(J_MIC3_Pin4),
                           .sample(mic_in) );
    wire ha1, ha2, ha3, ha4;
    wire [15:0] oled_data;
    wire [12:0] pixel_index;
    wire rst;
    SPO bl ( CLK100MHZ, btnC, rst );
    
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
    
    Volume_Calc vc ( .SampleClk(CLK100MHZ),
                     .mic_in(mic_in),
                     .volume(volume) );

    Bottom_Student control1 (
        .CLK100MHZ(CLK100MHZ),
        .sw(sw),
        .btnC(btnC),
        .btnU(btnU),
        .btnL(btnL),
        .btnR(btnR),
        .btnD(btnD),
        .mic_in(mic_in),
        .volume(volume),
        .led(led_1),
        .seg(seg_1),
        .dp(dp_1),
        .an(an_1),
        .oled_data(oled_data_1),
        .pixel_index(pixel_index),
        .next(rst)
    );
    
    NECPU_Peripherals control2 (
        .CLK100MHZ(CLK100MHZ),
        .sw(sw),
        .btnC(btnC),
        .btnU(btnU),
        .btnL(btnL),
        .btnR(btnR),
        .btnD(btnD),
        .mic_in(mic_in),
        .volume(volume),
        .led(led_2),
        .seg(seg_2),
        .dp(dp_2),
        .an(an_2),
        .oled_data(oled_data_2),
        .pixel_index(pixel_index)
    );
    
    assign       led = sw[15] ?       led_1 :       led_2;
    assign       seg = sw[15] ?       seg_1 :       seg_2;
    assign        dp = sw[15] ?        dp_1 :        dp_2;
    assign        an = sw[15] ?        an_1 :        an_2;
    assign oled_data = sw[15] ? oled_data_1 : oled_data_2;
    
endmodule