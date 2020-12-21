`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.12.2020 22:23:13
// Design Name: 
// Module Name: frequency_divider_tb
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


module frequency_divider_tb();

  reg clk_100MHz;
  wire clk_1MHz;
  
  frequency_divider #( 
      .DIVIDER(100) 
    ) FreqDivider (
    .rst(1'b0),
    .clk_in(clk_100MHz),
    .clk_out(clk_1MHz)
  );
  
 always
   begin
     clk_100MHz = 1'b1;
     #5;
     clk_100MHz = 1'b0;
     #5;
   end
   
endmodule
