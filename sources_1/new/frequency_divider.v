`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.12.2020 21:44:52
// Design Name: 
// Module Name: frequency_divider
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


module frequency_divider #(parameter DIVIDER = 2)
(
  input wire rst,
  input wire clk_in,
  output reg clk_out
);

  reg [7:0] counter, counter_nxt = 8'b0;
  reg clk_out_nxt = 1'b0;
  
  always@* begin
    if( counter < ((DIVIDER/2)-1) )
      begin
        counter_nxt = counter + 1;
        clk_out_nxt = clk_out;
      end
    else 
      begin
        counter_nxt = 8'b0;
        clk_out_nxt = ~clk_out;
      end
  end
  
  always@(posedge clk_in)
    if( rst ) begin
      clk_out <= 1'b0;
      counter <= 8'b0;
    end
    else begin
      clk_out <= clk_out_nxt;
      counter <= counter_nxt;
    end

endmodule
