module uart_rx(
    input wire rx,
    input wire s_tick,
    input wire rst,
    output reg [7:0] dout,
    output reg rx_done
);

localparam [1:0]
    IDLE  = 2'b00,
    DATA  = 2'b01,
    STOP  = 2'b10;
          
reg [3:0] counter, counter_nxt;
reg [3:0] bit_count, bit_count_nxt;
reg [1:0] state, state_nxt;

reg [7:0] dout_nxt; 
reg rx_done_nxt;

initial
begin
    bit_count=0;
    counter=0;
    state=0;
end

always@*
begin
     case(state)
      IDLE:
        if(rx == 0 && counter == 4'd7)
        begin
            rx_done_nxt <= 0;
            state_nxt <= DATA;
            counter_nxt <= 0;
            bit_count_nxt <= 0;
            dout_nxt <= 8'b0;
        end 
        else 
        begin
            state_nxt<=IDLE;
            bit_count_nxt<=0;
            rx_done_nxt=1;
            counter_nxt <= counter + 1;
        end
      DATA:
       if(counter == 4'd15)
       begin
            state_nxt <= DATA;
            dout_nxt <= {rx, dout[7:1]};
            bit_count_nxt <= bit_count + 1;
            counter_nxt <= counter + 1;
            if(bit_count == 3'd7) 
            begin
                state_nxt <= STOP;
                bit_count_nxt <= 0;
                rx_done_nxt <= 0;
            end
       end 
       else 
       begin
           counter_nxt <= counter + 1;
       end
      STOP:
       if(counter == 4'd15) begin
           rx_done_nxt <= 1;
           state_nxt <= IDLE;
           counter_nxt <= 0;
       end
       else
       begin
            counter_nxt <= counter + 1;
       end
       
     endcase
end

always @(posedge s_tick)
begin
    if(rst)
    begin
        state<=IDLE;
        counter<=4'b0;
        rx_done<=1'b1;
    end
    else
    begin
        bit_count<=bit_count_nxt;
        counter<=counter_nxt;
        state<=state_nxt;
        dout<=dout_nxt;
        rx_done<=rx_done_nxt;
    end
end

endmodule