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

    localparam SIM_N_SAMPLES = 2000;

    localparam SINE = 8'h00;
    localparam TRANG = 8'h01;
    localparam SQUARE = 8'h02;
    
    reg clk_125MHz; 
    reg rx = 1;
    wire clk_DDS = DDS_generator_test.clk_DDS;

// ----------------------- UART TEST ------------------------- //
    integer i;
    wire data_received = DDS_generator_test.ControlUnit.read_flag;

    initial begin
        #100000
        // ___________ type ___ M ___ offset _ amplitude _____ //
        SendConfigData(TRANG, 16'd100, 16'd1650, 16'd1000);
        // ___________ type ___ M ___ offset _ amplitude _____ //
        SendConfigData(SQUARE, 16'd100, 16'd1650, 16'd1000);
    end 
    
    task UartSendByte;
        input reg [7:0] data;
    begin
        #52083; rx = 0;
        for( i = 0; i < 8; i = i + 1 ) begin
            #52083; rx = data[i];
        end
        #52083; rx = 1;
    end 
    endtask
    
    task SendConfigData;
        input reg [7:0] data_signal_type;
        input reg [15:0] data_M;
        input reg [15:0] data_offset;
        input reg [15:0] data_amplitude;
    begin
        UartSendByte(data_signal_type[7:0]);        // data_signal_type
        UartSendByte(data_M[15:8]);                 // data_M (MSB byte)
        UartSendByte(data_M[7:0]);                  // data_M (LSB byte)
        UartSendByte(data_offset[15:8]);            // data_offset (MSB byte)
        UartSendByte(data_offset[7:0]);             // data_offset (LSB byte)
        UartSendByte(data_amplitude[15:8]);         // data_amplitude (MSB byte)
        UartSendByte(data_amplitude[7:0]);          // data_amplitude (LSB byte)
    end
    endtask
  
// -------------------- SAVE TO FILE ------------------------- //

    DDS_generator DDS_generator_test (
        .sysclk(clk_125MHz),
        .reset(1'b0),
        .rx(rx),
        .spi_mosi(),
        .spi_sck(),
        .spi_cs()
    );
    
    wire [11:0] sample_amplitude = DDS_generator_test.sample_amplitude_2;

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

// ---------------------- CLOCK GENERATOR -------------------- //
  always begin
    clk_125MHz = 1'b1; #4;
    clk_125MHz = 1'b0; #4;
  end

endmodule
