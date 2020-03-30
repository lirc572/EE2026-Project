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
    input  [15:0] sw,            // MEM[2147483648][31:16] (Read Only)
    input  btnC,                 // MEM[2147483649][0]     (Read Only)
    input  btnU,                 // MEM[2147483649][1]     (Read Only)
    input  btnL,                 // MEM[2147483649][2]     (Read Only)
    input  btnR,                 // MEM[2147483649][3]     (Read Only)
    input  btnD,                 // MEM[2147483649][4]     (Read Only)
    input  [11:0] mic_in,        // MEM[2147483650][11:0]  (Read Only)
    input  [ 3:0] volume,        // MEM[2147483650][19:16] (Read Only)
    output reg [15:0] led,       // MEM[2147483648][15:0]  (R/W)
    output reg [ 6:0] seg,       // MEM[2147483651][6:0]   (R/W)
    output reg dp,               // MEM[2147483651][7]     (R/W)
    output reg [3:0] an,         // MEM[2147483651][19:16] (R/W)
    output reg [15:0] oled_data, // MEM[2147483652][15:0]  (R/W)
    input [12:0] pixel_index     // MEM[2147483652][28:16] (Read Only)
    );
    
    wire cpu_write, cpu_read;
    wire [31:0] cpu_addr;
    wire [31:0] cpu_dout;
    reg  [31:0] cpu_din;
    
    CPU cpu_instance (
      .clk(CLK100MHZ),          // clock
      .rst(btnC),               // reset
      .write(cpu_write),        // CPU write request
      .read(cpu_read),          // CPU read request
      .address(cpu_addr),       // read/write address
      .dout(cpu_dout),          // write data
      .din(cpu_din)             // read data
    );
    
    wire ram_write, ram_read;
    wire [15:0] ram_addr;
    reg  [31:0] ram_din;
    wire [31:0] ram_dout;
    
    RAM ram (
      .address(ram_addr),
      .data_in(ram_din),
      .data_out(ram_dout),
      .read(ram_read),
      .write(ram_write)
    );
    
    // accessing ram if address within ram range
    assign ram_write = cpu_addr < 'd65536 ? cpu_write : 'b0;
    assign ram_read  = cpu_addr < 'd65536 ? cpu_write : 'b1;
    
    always @ (negedge CLK100MHZ) begin
        cpu_din <= 32'hxxxxxxxx;
        if (cpu_addr < 'd65536) begin
            if (cpu_write) begin
                ram_din <= cpu_dout;
            end else if (cpu_read) begin
                cpu_din <= ram_dout;
            end
        end else if (cpu_addr == 'd2147483648) begin // {sw[15:0], led[15:0]}
            if (cpu_write) begin
                led <= cpu_dout[15:0];
            end else if (cpu_read) begin
                cpu_din <= {sw[15:0], led[15:0]};
            end
        end else if (cpu_addr == 'd2147483649) begin // {27'hxxxxxxx, btnD, btnR, btnL, btnU, btnC}
            if (cpu_write) begin
                // Cannot lah
            end else if (cpu_read) begin
                cpu_din <= {27'hxxxxxxx, btnD, btnR, btnL, btnU, btnC};
            end
        end else if (cpu_addr == 'd2147483650) begin // {12'hxxx, volume[3:0], 4'hx, mic_in[11:0]}
            if (cpu_write) begin
                // Cannot lah
            end else if (cpu_read) begin
                cpu_din <= {12'hxxx, volume[3:0], 4'hx, mic_in[11:0]};
            end
        end else if (cpu_addr == 'd2147483651) begin // {12'hxxx, an[3:0], 8'hxx, dp, seg[6:0]}
            if (cpu_write) begin
                an  <= cpu_dout[19:16];
                dp  <= cpu_dout[7];
                seg <= cpu_dout[6:0];
            end else if (cpu_read) begin
                cpu_din <= {12'hxxx, an[3:0], 8'hxx, dp, seg[6:0]};
            end
        end else if (cpu_addr == 'd2147483652) begin // {3'bxxx, pixel_index[12:0], oled_data[15:0]}
            if (cpu_write) begin
                oled_data <= cpu_dout[15:0];
            end else if (cpu_read) begin
                cpu_din <= {3'bxxx, pixel_index[12:0], oled_data[15:0]};
            end
        end
    end
    
endmodule