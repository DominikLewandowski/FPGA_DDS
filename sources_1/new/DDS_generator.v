`timescale 1ns / 1ps
`include "config.vh"
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
  input wire rx,
  output wire spi_mosi,
  output wire spi_sck,
  output wire spi_cs
);
  ///////////// CLOCK ///////////////// 
  wire clk_100MHz, clk_1MHz, clk_DDS;
   
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
  
  frequency_divider #( 
    .DIVIDER(`DDS_CLOCK_PERIOD) 
  ) FreqDivider_2 (
    .rst(reset),
    .clk_in(clk_1MHz),
    .clk_out(clk_DDS)
  );
  //////////////////////////////////////
  
  wire [`ROM_PHASE_BIT-2:0] phase_M;
  wire [`DAC_MAX_V_BIT-2:0] signal_A;
  wire [1:0] signal_shape;

  control_unit ControlUnit (
    .clk_1MHz(clk_1MHz),
    .clk_100MHz(clk_100MHz),
    .rst(reset),
    .rx(rx),
    .phase_M(phase_M),
    .signal_A(signal_A),
    .signal_shape(signal_shape)
  );
  
  wire [`ROM_PHASE_BIT-1:0] signal_phase;
  wire [`ROM_AMPLITUDE_BIT-1:0] sample_amplitude_1;
  wire [`DAC_MAX_V_BIT-1:0] sample_amplitude_2;
  
  phase_accumulator Accumulator (
    .clk(clk_DDS),
    .rst(reset),
    .M(phase_M),
    .phase(signal_phase)
  );
  
  phase_to_amplitude PhaseToAmplitude (
    .clk(clk_DDS),
    .rst(reset),
    .phase(signal_phase),
    .shape(signal_shape),
    .amplitude(sample_amplitude_1)
  );
  
  amplitude_control AmplitudeControl (
    .clk(clk_DDS),
    .rst(reset),
    .amplitude_mv(signal_A),   
    .value_in(sample_amplitude_1),
    .value_out(sample_amplitude_2)
  );
  
  digital_to_analog DAC (
    .clk_1MHz(clk_1MHz),
    .rst(reset),
    .value_in(sample_amplitude_2),
    .spi_mosi(spi_mosi),
    .spi_sck(spi_sck),
    .spi_cs(spi_cs)
  );
  
endmodule
