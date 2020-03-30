`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2020 06:08:25 AM
// Design Name: 
// Module Name: Volume_Calc
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


module Volume_Calc(
    input SampleClk,
    input [11:0] mic_in,
    output reg [3:0] volume
    );
    
    reg [11:0] tmp_max_vol = 'd0;
    
    integer counter        = 'd1;
    
    always @ (posedge SampleClk) begin
        counter <= counter > 'd0 ? counter - 'd1 : 'd10000000;
        if (counter == 'd0) begin
            volume      <= (tmp_max_vol - 12'b100000000000) >> 'd7;
            tmp_max_vol <= 'd0;
        end else begin
            tmp_max_vol <= (mic_in > tmp_max_vol) ? mic_in : tmp_max_vol;
        end
    end
    
endmodule

/*
module Volume_Calc(
    input SampleClk,
    input [11:0] mic_in,
    output reg [3:0] volume
    );
    
    reg [11:0] tmp_max_vol = 'd0;
    
    integer counter        = 'd1;
    
    always @ (posedge SampleClk) begin
        counter <= counter > 'd0 ? counter - 'd1 : 'd100;
        if (counter == 'd0) begin
            volume      <= (tmp_max_vol - 12'b100000000000) >> 'd7;
            tmp_max_vol <= 'd0;
        end else begin
            tmp_max_vol <= (mic_in > tmp_max_vol) ? mic_in : tmp_max_vol;
        end
    end
    
endmodule
*/