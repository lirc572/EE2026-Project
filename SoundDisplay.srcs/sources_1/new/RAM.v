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
    
    reg [31:0] memory [0:32767];
    
    initial begin
        memory[0] <= 16'b1010101010101010;
        memory[1] <= 16'b0101010101010101;
    end
    
    
    always @ (negedge clk) begin //negedge!!!
        if (read)
            data_out <= memory[address[14:0]];
        else if (write)
            memory[address[14:0]] <= data_in;
    end
    
endmodule
