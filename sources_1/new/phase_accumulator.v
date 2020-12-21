`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.12.2020 21:56:44
// Design Name: 
// Module Name: phase_accumulator
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


module phase_accumulator(
  input wire clk,
  input wire rst,
  input wire [`ROM_PHASE_BIT-2:0] M,
  output reg [`ROM_PHASE_BIT-1:0] phase
);

  reg [`ROM_PHASE_BIT-1:0] phase_nxt = 0;

  always @* begin
    if( phase >= 0) begin
      phase_nxt = ( phase + {1'b0, M} ) % `ROM_PHASE_MAX_VAL;
    end
  end

  always@(posedge clk)
    if( rst ) phase <= 0;
    else phase <= phase_nxt;
 
endmodule
