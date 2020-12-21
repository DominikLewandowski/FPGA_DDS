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


module frequency_divider(
  input wire rst,
  input wire clk_100MHz,
  output reg clk_1MHz
);

  localparam DIVIDER = 7'd100;

  reg [6:0] counter, counter_nxt = 7'b0;
  reg clk_1MHz_nxt = 1'b0;
  
  always@* begin
    if( counter < ((DIVIDER/2)-1) )
      begin
        counter_nxt = counter + 1;
        clk_1MHz_nxt = clk_1MHz;
      end
    else 
      begin
        counter_nxt = 7'b0;
        clk_1MHz_nxt = ~clk_1MHz;
      end
  end
  
  always@(posedge clk_100MHz)
    if( rst ) begin
      clk_1MHz <= 1'b0;
      counter <= 7'b0;
    end
    else begin
      clk_1MHz <= clk_1MHz_nxt;
      counter <= counter_nxt;
    end

endmodule
