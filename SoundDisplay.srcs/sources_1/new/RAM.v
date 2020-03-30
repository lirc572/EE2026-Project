`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2020 04:22:04 PM
// Design Name: 
// Module Name: RAM
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


module RAM(
    input clk,
    input  [15:0] address,
    input  [31:0] data_in,
    output reg [31:0] data_out,
    input  read,
    input  write
    );
    
    reg [31:0] memory0 [0:65535];
    
    always @ (negedge clk) begin //negedge!!!
        if (read)
            data_out <= memory0[address[15:0]];
        else if (write)
            memory0[address[15:0]] <= data_in;
    end
    
endmodule
