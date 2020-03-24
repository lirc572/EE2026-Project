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

`define AVGNUM 10

module Clk2p00hz(
    input cin,
    output reg cout
    );
    reg [25:0] counter = 26'b0;
    always @ (posedge cin) begin
        counter <= (counter==26'b10111110101111000010000000) ? 26'b0 : counter + 1;
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
    reg clk20k, clk6p25m, clk100;
    wire [15:0] oled_data = {5'd0, 6'd0, mic_in[11:7]};
    reg [3:0] volume = 0;
    wire [15:0] ledout;
    assign led = sw[0] ? mic_in : ledout;
    
    integer i;
    initial begin
        for (i=0; i<`AVGNUM; i=i+1) begin
            mic_in_reg[1] = 'd0;
        end
    end
    
    integer counter_1 = 'd4999, counter_2 = 'd15;
    always @ (posedge CLK100MHZ) begin
        counter_1 <= ( counter_1 == 0 )     ? 'd4999   : counter_1 - 1;
        counter_2 <= ( counter_2 == 0 )     ? 'd15     : counter_2 - 1;
        
        clk20k    <= ( counter_1 <  2500)   ? 1 : 0;
        clk6p25m  <= ( counter_2 <  8   )   ? 1 : 0;
    end
    
    SPO bl ( CLK100MHZ, btnC, rst );
    
    Audio_Capture ac ( .CLK(CLK100MHZ),
                       .cs(clk20k),
                       .MISO(J_MIC3_Pin3),
                       .clk_samp(J_MIC3_Pin1),
                       .sclk(J_MIC3_Pin4),
                       .sample(mic_in) );
    
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
    
    SegDisp sd ( .en(1),
                 .CLK100MHZ(CLK100MHZ),
                 .num(volume),
                 .seg(seg),
                 .dp(dp),
                 .an(an) );
    
    Led ld ( .en(1),
             .num(volume),
             .leds(ledout) );
    
    wire [100:0] mic_sum [0:`AVGNUM-1];
    genvar j;
    for (j=0; j<`AVGNUM; j=j+1) begin
        assign mic_sum[j] = j==0 ? mic_in_reg[0] : mic_sum[j-1] + mic_in_reg[j];
    end
    wire [11:0] mic_avg;
    assign mic_avg = mic_sum[`AVGNUM-1] / `AVGNUM;
    
    always @ (mic_in) begin
        for (i=0; i<`AVGNUM-1; i=i+1)
            mic_in_reg[i] = mic_in_reg[i+1];
        mic_in_reg[i] = mic_in;
    end
    
    
    wire ccccc;
    Clk2p00hz c2p0 (CLK100MHZ, ccccc);
    always @ (posedge ccccc) begin //twice a sec
        volume <= mic_avg / 64;
    end
    
endmodule