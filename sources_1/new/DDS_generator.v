`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.12.2020 18:06:53
// Design Name: 
// Module Name: DDS_generator
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


module DDS_generator( 
  input wire sysclk,
  input wire reset,
  output wire spi_mosi,
  output wire spi_sck,
  output wire spi_cs
);
  ///////////// CLOCK ///////////////// 
  wire clk_100MHz, clk_1MHz;
   
  clk_wiz_0 clk_config (
    .clk_100MHz(clk_100MHz),              
    .sysclk(sysclk)
  );
  
  frequency_divider #( 
    .DIVIDER(100) 
  ) FreqDivider_1 (
    .rst(reset),
    .clk_in(clk_100MHz),
    .clk_out(clk_1MHz)
  );
  //////////////////////////////////////
  
  wire [12:0] phase_M;
  wire [10:0] signal_A;
  wire [1:0] signal_shape;

  control_unit ControlUnit (
    .clk(clk_1MHz),
    .rst(reset),
    .phase_M(phase_M),
    .signal_A(signal_A),
    .signal_shape(signal_shape)
  );
  
  wire [13:0] signal_phase;
  wire [11:0] sample_amplitude [1:0];
  
  phase_accumulator Accumulator (
    .clk(clk_1MHz),
    .rst(reset),
    .M(phase_M),
    .phase(signal_phase)
  );
  
  phase_to_amplitude PhaseToAmplitude (
    .clk(clk_1MHz),
    .rst(reset),
    .phase(signal_phase),
    .shape(signal_shape),
    .amplitude(sample_amplitude[0])
  );
  
  amplitude_control AmplitudeControl (
    .clk(clk_1MHz),
    .rst(reset),
    .amplitude_mv(signal_A),   
    .value_in(sample_amplitude[0]),
    .value_out(sample_amplitude[1])
  );
  
  digital_to_analog DAC (
    .clk_1MHz(clk_1MHz),
    .rst(reset),
    .value_in(sample_amplitude[1]),
    .spi_mosi(spi_mosi),
    .spi_sck(spi_sck),
    .spi_cs(spi_cs)
  );
  
endmodule
