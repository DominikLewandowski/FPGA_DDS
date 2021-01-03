`timescale 1ns / 1ps

module baud_gen 
   #(
    parameter N=10, // number of bits in counter 
              M=651 // mod-M 
   )
   (
    input wire clk_100MHz, rst,
    output reg s_tick
   );

   //signal declaration
   reg s_tick_nxt;
   reg [N-1:0] counter;
   reg [N-1:0] counter_nxt;

   always @*
   begin
     counter_nxt <= (counter==(M-1)) ? 0 : counter + 1;
     s_tick_nxt<=(counter==(M-1)) ? 1'b1 : 1'b0;
   end
   
   always @(posedge clk_100MHz)
   begin
      if (rst)
      begin
         counter <= 0;
         s_tick <= 0;
      end      
      else
      begin
         counter <= counter_nxt;
         s_tick <= s_tick_nxt;
      end
   end

endmodule