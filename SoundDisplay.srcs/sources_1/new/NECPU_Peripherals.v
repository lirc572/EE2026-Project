`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2020 07:50:06 AM
// Design Name: 
// Module Name: NECPU_Peripherals
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


module NECPU_Peripherals(
    input  CLK100MHZ,
    input  [5:0] sw,
    input  btnC,
    input  btnU,
    input  btnL,
    input  btnR,
    input  btnD,
    input  [11:0] mic_in,
    input  [ 3:0] volume,
    output reg [15:0] led,
    output reg [ 6:0] seg,
    output reg dp,
    output reg [3:0] an,
    output reg [15:0] oled_data,
    input [12:0] pixel_index
    );
    wire cpu_write, cpu_read;
    wire [31:0] cpu_addr;
    wire [31:0] cpu_dout;
    reg  [31:0] cpu_din;
    CPU cpu_instance (
      .clk(CLK100MHZ),           // clock
      .rst(btnC),               // reset
      .write(cpu_write),        // CPU write request
      .read(cpu_read),          // CPU read request
      .address(cpu_addr),       // read/write address
      .dout(cpu_dout),          // write data
      .din(cpu_din)             // read data
    );
    
    always @ (negedge CLK100MHZ) begin
        cpu_din = 32'hxxxxxxxx;
        if (cpu_write) begin
          if (cpu_addr == 'd2147483648) begin
            led = cpu_dout[15:0];
          end
        end else if (cpu_read) begin
          if (cpu_addr == 'd2147483648) begin
            cpu_din = {16'hffff, led};
          end
        end
      end
endmodule