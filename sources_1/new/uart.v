`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.12.2020 17:01:31
// Design Name: 
// Module Name: uart
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

// parameters values must sum to BN*8, the order of delivering data in rx must be: signal_type, freq_MSB, freq_LSB, offset, amplitude_MSB, amplitude_LSB  
module uart
   #(              
    parameter BN_ST=`SIGNAL_TYPE_BIT,       // number of bits for signal type
              BN_A=`DAC_MAX_V_BIT-1,        // number of bits for amplitude
              BN_F=`ROM_PHASE_BIT-1,        // number of bits for frequency
              BN_O=`OFFSET_BIT,             // number of bits for offset
              
              BYTES_ST=`SIGNAL_TYPE_BYTE,   // number of bytes needed to send signal type
              BYTES_A=`AMPLITUDE_BYTE,      // number of bytes needed to send amplitude
              BYTES_F=`FREQUENCY_BYTE,      // number of bytes needed to send frequency
              BYTES_O=`OFFSET_BYTE,         // number of bytes needed to send offset
              BN=`TOTAL_BYTE                // number of data transfer bytes              
    )
    (
        input wire rx, clk, clk_100MHz, rst,
        output wire new_data_flag,
        output wire [BN_A-1:0] amplitude,
        output wire [BN_F-1:0] frequency,
        output wire [BN_ST-1:0] signal_type,
        output wire [BN_O-1:0] offset
    );
    
    wire s_tick, rx_done;
    wire [7:0] data;
    
    uart_rx uart_unit(
        .rx(rx),
        .rst(rst),
        .s_tick(s_tick),
        .dout(data),
        .rx_done(rx_done)
    );
    baud_gen baud_gen_unit(
        .clk_100MHz(clk_100MHz),
        .rst(rst),
        .s_tick(s_tick)
    );
    interface #(.BN_ST(BN_ST),.BN_A(BN_A),.BN_O(BN_O),.BN_F(BN_F),.BN(BN),.BYTES_ST(BYTES_ST),.BYTES_A(BYTES_A),.BYTES_F(BYTES_F),.BYTES_O(BYTES_O))
    interface_unit(
        .rx_done(rx_done),
        .clk(clk),
        .rst(rst),
        .data(data),
        .new_data_flag(new_data_flag),
        .sig_amplitude(amplitude),
        .sig_frequency(frequency),
        .sig_offset(offset),
        .sig_type(signal_type)    
    );

    
endmodule
