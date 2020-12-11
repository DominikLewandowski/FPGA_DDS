`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.12.2020 22:43:09
// Design Name: 
// Module Name: DDS_generator_tb
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


module DDS_generator_tb();

// ------------------------------------------------------------------- // 
  localparam SIM_N_SAMPLES = 1000;            
// ------------------------------------------------------------------- // 

  reg clk_100MHz; 
  
  always begin
    clk_100MHz = 1'b1; #5;
    clk_100MHz = 1'b0; #5;
  end

  DDS_generator DDS_generator_test (
    .sysclk(clk_100MHz),
    .reset(1'b0),
    .spi_mosi(),
    .spi_sck(),
    .spi_cs()
  );
  
  wire [11:0] sample_amplitude = DDS_generator_test.sample_amplitude[1];
  wire clk_1MHz = DDS_generator_test.clk_1MHz;
  
  integer file_ptr, file_open;
  integer sample_counter = 0;
  
  initial begin
    wait (sample_amplitude >= 0);
    file_ptr = $fopen("signal_output.txt","w");
    file_open = 1;
    wait (sample_counter == SIM_N_SAMPLES); 
    file_open = 0;
    $fclose(file_ptr);
    $finish;
  end
  
  always @(posedge clk_1MHz)
  begin
    if( file_open == 1) begin
      $fwrite(file_ptr,"%d\n", sample_amplitude);
      sample_counter = sample_counter + 1;
    end
  end

endmodule
