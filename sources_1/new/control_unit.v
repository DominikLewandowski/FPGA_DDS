`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.12.2020 11:17:40
// Design Name: 
// Module Name: control_unit
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


module control_unit(
  input wire clk,
  input wire rst,
  output reg [12:0] phase_M,
  output reg [10:0] signal_A,
  output reg [1:0] signal_shape
);

  reg [12:0] phase_M_nxt = 10;
  reg [10:0] signal_A_nxt = 1000;
  reg [1:0] signal_shape_nxt = 0;    // 0 - sin, 1 - triang, 2 - square 
  
  always@(posedge clk) begin
    if(rst) begin
      phase_M <= 13'b0;
      signal_A <= 11'b0;
      signal_shape <= 1'b0;
    end
    else begin
      phase_M <= phase_M_nxt;
      signal_A <= signal_A_nxt;
      signal_shape <= signal_shape_nxt;
    end
  end
  
endmodule
