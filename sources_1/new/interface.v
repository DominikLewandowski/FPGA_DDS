`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.12.2020 17:00:48
// Design Name: 
// Module Name: interface
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

module interface
   #(              
        parameter BN_ST=2,  // number of bits for signal type
                  BN_A=11, // number of bits for amplitude
                  BN_F=13,  // number of bits for frequency
                  BN_O=12,  // number of bits for offset
                  
                  BYTES_ST=1,// number of bytes needed to send signal type
                  BYTES_A=2, // number of bytes needed to send amplitude
                  BYTES_F=2, // number of bytes needed to send frequency
                  BYTES_O=2, // number of bytes needed to send offset
                  BN=7     // number of data transfer bytes
    )    
    (
        input wire clk, rst,
        input wire [7:0] data,
        input wire rx_done,
        output reg [BN_A-1:0] sig_amplitude,
        output reg [BN_O-1:0] sig_offset,
        output reg [BN_F-1:0] sig_frequency,       
        output reg [BN_ST-1:0] sig_type,
        output reg new_data_flag     
    );
    
localparam [1:0]
        IDLE  = 2'b00,
        RECEIVING  = 2'b01,
        SENDING  = 2'b10;
            
reg [BN_A-1:0] sig_amplitude_nxt;
reg [BN_O-1:0] sig_offset_nxt;
reg [BN_F-1:0] sig_frequency_nxt;
reg [BN_ST-1:0] sig_type_nxt;         
reg [2:0] byte_counter, byte_counter_nxt;
reg [1:0] state, state_nxt;
reg new_data_flag_nxt;
reg [BN*8-1 :0] data_bus, data_bus_nxt;

always@*
begin
    case(state)
        IDLE:
            if(rx_done==0) state_nxt<=RECEIVING;
            else if(byte_counter==BN) state_nxt <= SENDING;
            else new_data_flag_nxt<=0;
            
        RECEIVING:
            if(rx_done==1)
            begin
                data_bus_nxt <= {data[7:0],data_bus[(BN*8-1):8]};
                byte_counter_nxt <= byte_counter+1;
                state_nxt <= IDLE;
            end
            else begin end
        
        SENDING:                            
        begin
            sig_amplitude_nxt <= data_bus[(BN*8-1)-(BYTES_A*8-BN_A) : (BN*8)-BYTES_A*8];
            sig_offset_nxt<= data_bus[(BN*8-1)-BYTES_A*8-(BYTES_O*8-BN_O) : (BN*8)-(BYTES_A+BYTES_O)*8];
            sig_frequency_nxt<=data_bus[(BN*8-1)-(BYTES_A+BYTES_O)*8-(BYTES_F*8-BN_F) : BYTES_ST*8 ];
            sig_type_nxt<=data_bus[(BYTES_ST*8-1) : 0];
            
            byte_counter_nxt <= 0;
            new_data_flag_nxt <= 1;        
            state_nxt<=IDLE;             
        end
    endcase
end
        
always@(posedge clk)
    begin
    if(rst)
    begin
        data_bus<=0;
        {sig_amplitude, sig_offset, sig_frequency, sig_type} <= 0;
        byte_counter <= 0;
        state<=0;
    end
    else
    begin
        new_data_flag <= new_data_flag_nxt;
        byte_counter<=byte_counter_nxt;
        state<=state_nxt;
        {sig_amplitude, sig_offset, sig_frequency, sig_type} <= {sig_amplitude_nxt, sig_offset_nxt, sig_frequency_nxt,sig_type_nxt }; 
        data_bus <= data_bus_nxt;
    end
end        
    
    
    
endmodule
