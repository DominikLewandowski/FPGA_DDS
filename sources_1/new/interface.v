`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.01.2021 20:13:03
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


module interface(
    input wire clk_1MHz,
    input wire clk_100MHz,
    input wire rst,
    input wire rx,
    output reg data_ready,
    output wire [7:0] var_1,
    output wire [15:0] var_2,
    output wire [15:0] var_3,
    output wire [15:0] var_4
);

    reg [7:0] uart_data [6:0];
    reg [7:0] uart_data_nxt [6:0];
    
    assign var_1 = uart_data[0];
    assign var_2[15:8] = uart_data[1];
    assign var_2[7:0] = uart_data[2];
    assign var_3[15:8] = uart_data[3];
    assign var_3[7:0] = uart_data[4];
    assign var_4[15:8] = uart_data[5];
    assign var_4[7:0] = uart_data[6];
    
    reg data_ready_nxt = 1'b0;

    wire rx_empty;
    wire [7:0] rec_data;
    
    reg uart_read, uart_read_nxt = 1'b0;

    uart uart_unit (.clk(clk_100MHz), .reset(rst), .rd_uart(uart_read), .wr_uart(1'b0), .rx(rx),
        .w_data(0), .tx_full(), .rx_empty(rx_empty), .r_data(rec_data), .tx());


    localparam S_IDLE = 3'b000, S_1A = 3'b001, S_2A = 3'b010, S_2B = 3'b011, S_3A = 3'b100, S_3B = 3'b101, S_4A = 3'b110, S_4B = 3'b111;
    reg [2:0] state, state_nxt = S_IDLE;
    
    always@*
    begin
        uart_read_nxt = 1'b0;
        state_nxt = state;
        data_ready_nxt = 1'b0;
        
        uart_data_nxt[0] = uart_data[0];
        uart_data_nxt[1] = uart_data[1];
        uart_data_nxt[2] = uart_data[2];
        uart_data_nxt[3] = uart_data[3];
        uart_data_nxt[4] = uart_data[4];
        uart_data_nxt[5] = uart_data[5];
        uart_data_nxt[6] = uart_data[6];
        
        case(state)
            S_IDLE:
                if( rx_empty == 0 ) state_nxt = S_1A;
 
            S_1A:       // SHAPE
                if( (rx_empty == 0) && (uart_read == 0) )
                begin
                    uart_data_nxt[0] = rec_data;
                    uart_read_nxt = 1'b1;
                    state_nxt = S_2A;
                end

            S_2A:       // FREQUENCY - MSB
                if( (rx_empty == 0) && (uart_read == 0) )
                begin
                    uart_data_nxt[1] = rec_data;
                    uart_read_nxt = 1'b1;
                    state_nxt = S_2B;
                end

            S_2B:       // FREQUENCY - LSB
                if( (rx_empty == 0) && (uart_read == 0) )
                begin
                    uart_data_nxt[2] = rec_data;
                    uart_read_nxt = 2'b1;
                    state_nxt = S_3A;
                end

            S_3A:       // OFFSET - MSB
                if( (rx_empty == 0) && (uart_read == 0) )
                begin
                    uart_data_nxt[3] = rec_data;
                    uart_read_nxt = 2'b1;
                    state_nxt = S_3B;
                end

            S_3B:       // OFFSET - LSB
                if( (rx_empty == 0) && (uart_read == 0) )
                begin
                    uart_data_nxt[4] = rec_data;
                    uart_read_nxt = 2'b1;
                    state_nxt = S_4A;
                end

            S_4A:       // AMPLITUDE - MSB
                if( (rx_empty == 0) && (uart_read == 0) )
                begin
                    uart_data_nxt[5] = rec_data;
                    uart_read_nxt = 2'b1;
                    state_nxt = S_4B;
                end 

            S_4B:       // AMPLITUDE - LSB
                if( (rx_empty == 0) && (uart_read == 0) )
                begin
                    uart_data_nxt[6] = rec_data;
                    uart_read_nxt = 2'b1;
                    state_nxt = S_IDLE;
                    data_ready_nxt = 1'b1;
                end 

            default:
                state_nxt = S_IDLE;

        endcase
    end

    always@(posedge clk_1MHz)
    begin
        if(rst) begin
            uart_read <= 0;
            state <= S_IDLE;
            data_ready <= 0;

            uart_data[0] <= 0;
            uart_data[1] <= 0;
            uart_data[2] <= 0;
            uart_data[3] <= 0;
            uart_data[4] <= 0;
            uart_data[5] <= 0;
            uart_data[6] <= 0;

        end else begin
            uart_read <= uart_read_nxt;
            state <= state_nxt;
            data_ready <= data_ready_nxt;

            uart_data[0] <= uart_data_nxt[0];
            uart_data[1] <= uart_data_nxt[1];
            uart_data[2] <= uart_data_nxt[2];
            uart_data[3] <= uart_data_nxt[3];
            uart_data[4] <= uart_data_nxt[4];
            uart_data[5] <= uart_data_nxt[5];
            uart_data[6] <= uart_data_nxt[6];
        end
    end
endmodule
