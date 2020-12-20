`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.12.2020 22:02:59
// Design Name: 
// Module Name: phase_to_amplitude
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


module phase_to_amplitude(
  input wire clk,
  input wire rst,
  input wire [`ROM_PHASE_BIT-1:0] phase,
  input wire [1:0] shape,
  output wire [11:0] amplitude
);

  wire [11:0] signal [2:0];

  assign amplitude = ( shape == 2'b00 ) ? signal[0] : (( shape == 2'b01 ) ? signal[1] : signal[2]);

  signal_sine_rom signal_rom_1(
    .clk(clk),
    .rst(rst),
    .phase(phase), 
    .value(signal[0])
  );

  signal_triangle_rom signal_rom_2(
    .clk(clk),
    .rst(rst),
    .phase(phase), 
    .value(signal[1])
  );

  signal_square_rom signal_rom_3(
    .clk(clk),
    .rst(rst),
    .phase(phase), 
    .value(signal[2])
  );

endmodule
