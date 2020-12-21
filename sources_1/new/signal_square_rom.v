`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.12.2020 20:40:57
// Design Name: 
// Module Name: signal_square_rom
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


module signal_square_rom(
  input wire clk,
  input wire rst,
  input wire [13:0] phase,
  output reg [11:0] value
);

  reg [11:0] rom [0:16383];

  initial $readmemh("signal_square.data", rom); 

  always @(posedge clk)
    if( rst ) value <= 12'h000;
    else value <= rom[phase];
  
endmodule
