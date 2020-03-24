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

`define AVGNUM 100

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
    input [0:0] sw,
    input btnC,
    input  J_MIC3_Pin3,   // Connect from this signal to Audio_Capture.v
    output J_MIC3_Pin1,   // Connect to this signal from Audio_Capture.v
    output J_MIC3_Pin4,   // Connect to this signal from Audio_Capture.v
    output [15:0] led,
    output [6:0] seg,
    output dp,
    output [3:0] an,
    output [7:0] JB
    );
    wire [11:0] mic_in;
    reg [11:0] mic_in_reg [0:`AVGNUM-1];
    wire rst;
    reg clk20k, clk100;
    //wire [15:0] oled_data = {5'd0, 6'd0, mic_in[11:7]};
    reg [3:0] volume = 0;
    wire [15:0] ledout;
    assign led = sw[0] ? mic_in : ledout;
    
    integer i;
    initial begin
        for (i=0; i<`AVGNUM; i=i+1) begin
            mic_in_reg[i] = 'd0;
        end
    end
    
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
                              .JB(JB) );
    
    SegDisp sd ( .en(1),
                 .CLK100MHZ(CLK100MHZ),
                 .num(volume),
                 .seg(seg),
                 .dp(dp),
                 .an(an) );
    
    Led ld ( .en(1),
             .num(volume),
             .leds(ledout) );
    
    integer j = 'd0;
    always @ (mic_in) begin
        mic_in_reg[j] <= mic_in;
        j <= (j+1)<`AVGNUM ? j + 1 : 'd0;
    end
    
    integer k;
    reg [11:0] mic_in_max;
    reg [11:0] volume_tmp = 'd0;
    reg [11:0] mic_in_min;
    always @ (mic_in) begin
        if (j==0) begin
            mic_in_min = 'd4095;
            mic_in_max = 'd0;
            for (k=0; k<`AVGNUM; k=k+1) begin
                mic_in_max = mic_in_reg[k]>mic_in_max ? mic_in_reg[k] : mic_in_max;
                mic_in_min = mic_in_reg[k]<mic_in_min ? mic_in_reg[k] : mic_in_min;
            end
            volume_tmp = mic_in_max-mic_in_min;
        end
    end
    
    wire ccccc;
    Clk10p0hz c10p0 (CLK100MHZ, ccccc);
    always @ (posedge ccccc) begin //10 times a sec
        volume <= volume_tmp[11:8];
    end
    
endmodule