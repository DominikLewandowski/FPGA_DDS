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
  input wire [12:0] M,
  output reg [13:0] phase
);

  localparam MAX_PHASE_VAL = 14'd10000;

  reg [13:0] phase_nxt = 0;

  always @* begin
    if( phase >= 0) begin
      phase_nxt = ( phase + {1'b0, M} ) % MAX_PHASE_VAL;
    end
  end

  always@(posedge clk)
    if( rst )  phase <= 0;
    else  phase <= phase_nxt;
 
endmodule
