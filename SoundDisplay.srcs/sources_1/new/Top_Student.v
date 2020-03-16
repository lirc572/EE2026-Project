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
    input CLK100MHZ,
    input [0:0] sw,
    input btnC,
    input  J_MIC3_Pin3,   // Connect from this signal to Audio_Capture.v
    output J_MIC3_Pin1,   // Connect to this signal from Audio_Capture.v
    output J_MIC3_Pin4,   // Connect to this signal from Audio_Capture.v
    output [11:0] led,
    output [7:0] JB
    );
    
    wire [11:0] mic_in;
    
    wire rst;
    
    reg clk20k, clk6p25m, clk100;
    
    wire [15:0] oled_data = {5'd0, 6'd0, mic_in[11:7]};
    
    assign led = sw[0] ? mic_in : 0;
    
    integer counter_1 = 'd4999, counter_2 = 'd15;
    
    always @ (posedge CLK100MHZ) begin
        counter_1 <= ( counter_1 == 0 )     ? 'd4999   : counter_1 - 1;
        counter_2 <= ( counter_2 == 0 )     ? 'd15     : counter_2 - 1;
        
        clk20k    <= ( counter_1 <  2500)   ? 1 : 0;
        clk6p25m  <= ( counter_2 <  8   )   ? 1 : 0;
    end
    
    SPO bl (CLK100MHZ, btnC, rst);
    
    Audio_Capture ac ( CLK100MHZ, clk20k, J_MIC3_Pin3, J_MIC3_Pin1, J_MIC3_Pin4, mic_in );
    
    Oled_Display  od ( clk6p25m, rst, ha1, ha2, ha3, ha4, oled_data, JB[0], JB[1], JB[3], JB[4], JB[5], JB[6], JB[7], ha5 );
    
endmodule