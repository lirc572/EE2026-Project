`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/03/2020 02:48:08 PM
// Design Name: 
// Module Name: SPO
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

//100.00Hz
module Clk100p0hz(
    input cin,
    output reg cout
    );
    reg [19:0] counter = 20'b0;
    always @ (posedge cin) begin
        counter <= (counter==20'b11110100001001000000) ? 20'b0 : counter + 1;
    end
    always @ (posedge cin) begin
        cout <= counter == 20'b0;
    end
endmodule

module My_Dff(input clk, input sig, output reg out);
    always @ (posedge clk) begin
        out <= sig;
    end
endmodule

module SPO(
    input clk,
    input sig,
    output out
    );
    
    wire haha, hoho, c;
    
    Clk100p0hz c1 (clk, c);
    My_Dff dff1 (c, sig, haha);
    My_Dff dff2 (c, haha, hoho);
    and and1 (out, haha, ~hoho);
    
endmodule
