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
  input wire clk_1MHz,
  input wire clk_100MHz,
  input wire rst,
  input wire rx,
  output reg [`ROM_PHASE_BIT-2:0] phase_M,
  output reg [`DAC_MAX_V_BIT-2:0] signal_A,
  output reg [1:0] signal_shape
);

    // ---------- DEFAULT VALUES ----------- //
    reg [`ROM_PHASE_BIT-2:0] phase_M_nxt = 10;          // Phase M (samples)
    reg [`DAC_MAX_V_BIT-2:0] signal_A_nxt = 1000;       // Amplitude (mV)
    reg [1:0] signal_shape_nxt = 0;                     // 0 - sin, 1 - triang, 2 - square
    // ------------------------------------- //

    wire read_flag;
    wire [7:0] var1;
    wire [15:0] var2, var3, var4;

    interface DDS_Interface(
        .clk_1MHz(clk_1MHz),
        .clk_100MHz(clk_100MHz),
        .rst(rst),
        .rx(rx),
        .data_ready(read_flag),
        .var_1(var1),
        .var_2(var2),
        .var_3(var3),
        .var_4(var4)
    );

    always @* begin
      if( read_flag == 1 ) begin
        phase_M_nxt <= var2;
        signal_A_nxt <= var4;
        signal_shape_nxt <= var1;
      end else begin
        phase_M_nxt <= phase_M;
        signal_A_nxt <= signal_A;
        signal_shape_nxt <= signal_shape;
      end
    end
  
  always@(posedge clk_1MHz) begin
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
