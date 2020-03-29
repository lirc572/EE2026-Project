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


module Clk2p00hz(
    input cin,
    output reg cout
    );
    reg [26:0] counter = 27'b0;
    always @ (posedge cin) begin
        counter <= (counter==27'b10111110101111000010000000) ? 27'b0 : counter + 1;
    end
    always @ (posedge cin) begin
        cout <= counter == 27'b0;
    end
endmodule


module Clk10p0hz(
    input cin,
    output reg cout
    );
    reg [23:0] counter = 24'b0;
    always @ (posedge cin) begin
        counter <= (counter=='b100110001001011010000000) ? 'b0 : counter + 1;
    end
    always @ (posedge cin) begin
        cout <= counter < 'b1011111010111100001000000;
    end
endmodule

module Top_Student (
    input CLK100MHZ,
    input [5:0] sw,
    input btnC,
    input  J_MIC3_Pin3,   // Connect from this signal to Audio_Capture.v
    output J_MIC3_Pin1,   // Connect to this signal from Audio_Capture.v
    output J_MIC3_Pin4,   // Connect to this signal from Audio_Capture.v
    output [15:0] led,
    output [6:0]  seg,
    output dp,
    output [3:0] an,
    output [7:0] JB
    );
    wire [11:0] mic_in;
    wire rst;
    reg clk20k, clk100;
    wire [3:0] volume;
    wire [15:0] ledout;
    assign led = sw[0] ? {4'd0, mic_in} : ledout;
    
    integer counter_1 = 'd4999;
    always @ (posedge CLK100MHZ) begin
        counter_1 <= ( counter_1 == 0 )     ? 'd4999   : counter_1 - 1;
        
        clk20k    <= ( counter_1 <  2500)   ? 1 : 0;
    end
    
    SPO bl ( CLK100MHZ, btnC, rst );
    
    Audio_Capture ac ( .CLK(CLK100MHZ),
                       .cs(clk20k),
                       .MISO(J_MIC3_Pin3),
                       .clk_samp(J_MIC3_Pin1),
                       .sclk(J_MIC3_Pin4),
                       .sample(mic_in) );
    
    OLed_Volume_Display ovd ( .en(1),
                              .rst(rst),
                              .CLK100MHZ(CLK100MHZ),
                              .num(volume),
                              .border_on(sw[1]),
                              .volume_bar_on(sw[2]),
                              .other_on(sw[3]),
                              .theme_sel(sw[5:4]),
                              .JB(JB) );
    
    Volume_Calc vc ( .SampleClk(CLK100MHZ),
                     .mic_in(mic_in),
                     .volume(volume) );
    
    SegDisp sd ( .en(1),
                 .CLK100MHZ(CLK100MHZ),
                 .num(volume),
                 .seg(seg),
                 .dp(dp),
                 .an(an) );
    
    Led ld ( .en(1),
             .num(volume),
             .leds(ledout) );
    
    /*
    wire ccccc;
    Clk2p00hz c2p0 (CLK100MHZ, ccccc);
    always @ (posedge ccccc)
        volume = volume + 1;
    */
endmodule