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
    input  [15:0] address,
    input  [31:0] data_in,
    output reg [31:0] data_out,
    input  read,
    input  write
    );
    
    // 4 separate blocks deu to physical limitations
    reg [31:0] memory0 [0:16384];
    reg [31:0] memory1 [0:16384];
    reg [31:0] memory2 [0:16384];
    reg [31:0] memory3 [0:16384];
    
    always @ (*) begin
        if (read)
            if (address[15:14] == 'd0)
                data_out <= memory0[address[13:0]];
            if (address[15:14] == 'd1)
                data_out <= memory1[address[13:0]];
            if (address[15:14] == 'd2)
                data_out <= memory2[address[13:0]];
            if (address[15:14] == 'd3)
                data_out <= memory3[address[13:0]];
        else if (write)
            if (address[15:14] == 'd0)
                memory0[address[13:0]] <= data_in;
            if (address[15:14] == 'd1)
                memory1[address[13:0]] <= data_in;
            if (address[15:14] == 'd2)
                memory2[address[13:0]] <= data_in;
            if (address[15:14] == 'd3)
                memory3[address[13:0]] <= data_in;
    end
    
endmodule
