`timescale 1ns / 1ps
`include "config.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.12.2020 21:59:06
// Design Name: 
// Module Name: amplitude_control
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


module amplitude_control(
  input wire clk,
  input wire rst,
  input wire [`DAC_MAX_V_BIT-1:0] offset,
  input wire [`DAC_MAX_V_BIT-2:0] amplitude_mv,    // max 1650mV  -> 2*1650 = 3300mV = 3.3V -> max DAC Voltage
  input wire [`ROM_AMPLITUDE_BIT-1:0] value_in,
  output reg [`DAC_MAX_V_BIT-1:0] value_out
);

  reg [`DAC_MAX_V_BIT-1:0] value_out_nxt = 0;

  always @* 
  begin
      if( offset < amplitude_mv )
          value_out_nxt = (value_in * amplitude_mv) / `ROM_AMPLITUDE;
      else if( offset > `DAC_MAX_V - 2*amplitude_mv )
          value_out_nxt = (value_in * amplitude_mv) / `ROM_AMPLITUDE + (`DAC_MAX_V - 2*amplitude_mv);
      else
          value_out_nxt = (value_in * amplitude_mv) / `ROM_AMPLITUDE + (offset - amplitude_mv);   
  end
  
  always@(posedge clk)
    if( rst )  value_out <= 0;
    else value_out <= value_out_nxt;

endmodule
