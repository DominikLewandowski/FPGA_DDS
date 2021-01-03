`timescale 1ns / 1ps
`include "config.vh"
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
  input wire [`ROM_PHASE_BIT-2:0] phase,
  input wire [`DAC_MAX_V_BIT-2:0] amplitude,
  input wire [`OFFSET_BIT-1:0] offset,
  input wire [`SIGNAL_TYPE_BIT-1:0] signal_type,
  input wire new_data_flag,
  output reg [`ROM_PHASE_BIT-2:0] phase_M,
  output reg [`DAC_MAX_V_BIT-2:0] signal_A,
  output reg [1:0] signal_shape
);


  reg [`ROM_PHASE_BIT-2:0] phase_M_nxt=10;
  reg [`DAC_MAX_V_BIT-2:0] signal_A_nxt=1200;
  reg [`SIGNAL_TYPE_BIT:0] signal_shape_nxt=0;    // 0 - sin, 1 - triang, 2 - square 
  
  always @*
  begin
      if(new_data_flag)
      begin
          phase_M_nxt<=phase;
          signal_A_nxt<=amplitude;
          signal_shape_nxt<=signal_type;
      end
      else begin end
  end
  
  always@(posedge clk) begin
    if(rst) begin
      phase_M <= 0;
      signal_A <= 0;
      signal_shape <= 0;
    end
    else begin
      phase_M <= phase_M_nxt;
      signal_A <= signal_A_nxt;
      signal_shape <= signal_shape_nxt;
    end
  end
  
endmodule
