`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.12.2020 22:06:38
// Design Name: 
// Module Name: digital_to_analog
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


module digital_to_analog(
  input wire clk_100MHz,
  input wire clk_1MHz,
  input wire rst,
  input wire [11:0] value_in,
  output reg spi_mosi,
  output reg spi_sck,
  output reg spi_cs
);

  always@(posedge clk_100MHz)
  begin
    spi_mosi <= ( |value_in[11:8] );
    spi_sck <= ( |value_in[7:4] );
    spi_cs <= ( |value_in[3:0] );
  end
  
endmodule
