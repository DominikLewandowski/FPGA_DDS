`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.01.2021 17:29:43
// Design Name: 
// Module Name: DDS_generator_uart_tb
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


module DDS_generator_uart_tb();

// ---------------------- CLOCK GENERATOR -------------------- //
  reg clk_125MHz; 
  always begin
    clk_125MHz = 1'b1; #4;
    clk_125MHz = 1'b0; #4;
  end


  reg rx = 1;

  wire [11:0] sample_amplitude = DDS_generator_test.sample_amplitude_2;
  wire clk_DDS = DDS_generator_test.clk_DDS;


// ----------------------- UART TEST ------------------------- //

    reg [7:0] data_signal_type = 8'h01;
    reg [15:0] data_M = 16'h7702;
    reg [15:0] data_offset = 16'hFFFF;
    reg [15:0] data_amplitude = 16'h6645;

    integer i;

    initial begin
        wait (sample_amplitude >= 0);

        // -------- data_signal_type -------- //
        #104000
        rx = 0;
        for( i = 0; i < 8; i = i + 1 ) begin
            #104000
            rx = data_signal_type[i];
        end
        #104000
        rx = 1;
        // ------- data_M (MSB byte) ------ //
        #104000
        rx = 0;
        for( i = 8; i < 16; i = i + 1 ) begin
            #104000
            rx = data_M[i];
        end
        #104000
        rx = 1;
        // ------- data_M (LSB byte) ----- //
        #104000
        rx = 0;
        for( i = 0; i < 8; i = i + 1 ) begin
            #104000
            rx = data_M[i];
        end
        #104000
        rx = 1;
        // ------- data_offset (MSB byte) ------ //
        #104000
        rx = 0;
        for( i = 8; i < 16; i = i + 1 ) begin
            #104000
            rx = data_offset[i];
        end
        #104000
        rx = 1;
        // ------- data_offset (LSB byte) ----- //
        #104000
        rx = 0;
        for( i = 0; i < 8; i = i + 1 ) begin
            #104000
            rx = data_offset[i];
        end
        #104000
        rx = 1; 
        // ------- data_amplitude (MSB byte) ------ //
        #104000
        rx = 0;
        for( i = 8; i < 16; i = i + 1 ) begin
            #104000
            rx = data_amplitude[i];
        end
        #104000
        rx = 1;
        // ------- data_amplitude (LSB byte) ----- //
        #104000
        rx = 0;
        for( i = 0; i < 8; i = i + 1 ) begin
            #104000
            rx = data_amplitude[i];
        end
        #104000
        rx = 1;
    end
  
// -------------------- SAVE TO FILE ------------------------- //
    localparam SIM_N_SAMPLES = 2000;

    DDS_generator DDS_generator_test (
        .sysclk(clk_125MHz),
        .reset(1'b0),
        .rx(rx),
        .spi_mosi(),
        .spi_sck(),
        .spi_cs()
    );
  
    integer file_ptr, file_open;
    integer sample_counter = 0;
    
    initial begin
        wait (sample_amplitude >= 0);
        file_ptr = $fopen("signal_output.txt","w");
        file_open = 1;
        wait (sample_counter >= SIM_N_SAMPLES); 
        file_open = 0;
        $fclose(file_ptr);
        $finish;
    end
  
    always @(posedge clk_DDS)
    begin
        if( file_open == 1) begin
        $fwrite(file_ptr,"%d\n", sample_amplitude);
        sample_counter = sample_counter + 1;
    end
  end
// ----------------------------------------------------------- //
endmodule
