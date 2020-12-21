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
  input wire [`ROM_PHASE_BIT-1:0] phase,
  output reg [`ROM_AMPLITUDE_BIT-1:0] value
);

  reg [`ROM_AMPLITUDE_BIT-1:0] rom [0:`ROM_PHASE_MAX_VAL-1];

  initial $readmemh("signal_square.data", rom); 

  always @(posedge clk)
    if( rst ) value <= 0;
    else value <= rom[phase];
  
endmodule
