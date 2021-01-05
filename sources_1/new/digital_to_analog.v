`timescale 1ns / 1ps


module digital_to_analog(
  input wire clk_1MHz,
  input wire rst,
  input wire [11:0] value_in,
  output wire spi_sck,
  output reg spi_mosi,
  output reg spi_cs
);


localparam wait_for_data=0, send_data=1;

wire[11:0] data;
reg state, state_nxt, spi_mosi_nxt = 'b0;
reg spi_cs_nxt = 'b1;
reg[3:0] ctr, ctr_nxt;
reg[15:0] to_send_data, to_send_data_nxt;


DAC_multiplier my_multiplier(
    .CLK(clk_1MHz),
    .A(value_in),
    .P(data)
);


always @* begin
    case(state)
        wait_for_data : begin
                            if(value_in != to_send_data[11:0]) begin
                                to_send_data_nxt = {4'b0011, data[11:0]};
                                ctr_nxt = 15;
                                state_nxt = send_data;
                                spi_mosi_nxt = to_send_data_nxt[15];
                                spi_cs_nxt = 'b1;
                            end
                            else begin
                                to_send_data_nxt = to_send_data;
                                ctr_nxt = ctr;
                                state_nxt = wait_for_data;
                                spi_mosi_nxt = spi_mosi;
                                spi_cs_nxt = 'b1;
                            end
                        end

        send_data:      begin
                            if(ctr > 0) begin
                                to_send_data_nxt = to_send_data;
                                ctr_nxt = ctr - 1;
                                state_nxt = send_data;
                                spi_mosi_nxt = to_send_data[ctr];
                                spi_cs_nxt = 'b0;
                            end
                            else begin
                                to_send_data_nxt = to_send_data;
                                ctr_nxt = ctr;
                                state_nxt = wait_for_data;
                                spi_mosi_nxt = to_send_data[0];
                                spi_cs_nxt = 'b0;
                            end
                        end
    endcase
end

always @(negedge clk_1MHz) begin
    if(rst) begin
        to_send_data <= 'b0;
        ctr <= 'b0;
        state <= wait_for_data;
        spi_mosi <= 'b0;
        spi_cs <= 'b1;
    end
    else begin
        to_send_data <= to_send_data_nxt;
        ctr <= ctr_nxt;
        state <= state_nxt;
        spi_mosi <= spi_mosi_nxt;
        spi_cs <= spi_cs_nxt;
    end

end

assign spi_sck = (spi_cs == 'b0) ? clk_1MHz : 'b0;

endmodule
