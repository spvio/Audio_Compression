//personal encoder

module compression(
    input i_clk,
    input c14,
    //input wire[15:0] i_bits,
    output wire[7:0] o_bits
);
//intermdiate wires 
wire[15:0] k_add_out;
wire[2:0] p_out_;
wire[3:0]  lsls_out_;


wire ack;
wire[15:0] add_in;
wire[15:0] add_out;
wire[2:0] p_out;
wire[3:0] lsls_out;

//intermediate registers
reg[15:0] pcm_data; //have to give it some initial value
reg[15:0] r_add_in;
reg[15:0] r_add_out;
reg[2:0]  r_p_out = 0;
reg[3:0]  r_lsls_out = 0;
reg[7:0] r_out = 0;



//instantiatiate modules & all are combinational logic(pipelining into '4' stages)
k_bit_adder k_add_inst(.i_bits(add_in), .o_bits(k_add_out));
priority_encoder p_encoder_inst(.i_bits(add_out[14:5]), .o_bits(p_out_));
lsls_8  lsls_inst(.i_bits(k_add_out), .shift_bits(p_out), .o_bits(lsls_out_));


//with clock
uart_tx uart_tx_inst(.C14(c14), .i_clk(i_clk), .ack(ack), .data(pcm_data));

reg[2:0] lat_c = 0;
reg[1:0] state = 2'b00;
parameter idle = 2'b00;
parameter start = 2'b01;
always @(posedge i_clk) begin
    case(state) 
        idle: begin 
            if(ack == 1'b1) state <= start;
        end

        start: begin //assume all combinational takes one clock cycle..(latency = 3)
            r_add_in <= pcm_data;
            r_add_out <= k_add_out;
            r_p_out <= p_out_;
            r_lsls_out <= lsls_out_;

            if(lat_c != 4) lat_c = lat_c + 1;
            else begin 
                lat_c = 0;
                r_out =  {8{pcm_data[15]}}^{1'b0, p_out, lsls_out};
            end
            if(ack == 1'b0) state <= idle;
        end

    endcase

    
end
assign add_in = r_add_in;
assign add_out = r_add_out;
assign p_out   = r_p_out;
assign lsls_out = r_lsls_out;
//output:
assign o_bits = r_out;


endmodule


//zync-700 runs at 100MGHz, uart_bits
//baud rate: 115200, 8 bits : need to wait 868 cycles,
//I only care about C14(TX)
module uart_tx(
    input C14,
    input i_clk,
    output wire ack,
    output reg[15:0] data
);

initial begin 
data = 16'h000; //for the first value
end
reg r_ack = 0;
reg[1:0] state = 0;
reg[9:0] counter = 0;
reg[1:0] parts = 0;
reg[4:0] index= 0;
parameter idle   = 2'b00;
parameter start  = 2'b01;
parameter sample = 2'b10;
parameter stop   = 2'b11;



always @(posedge i_clk) begin 
    case(state)

    idle:begin 
        if(C14 == 1'b0) state <= start;
    end

    //goal sample in the middle
    start:begin 
        if(counter != 434) counter <= counter + 1;
        else begin 
            counter <= 0;
            state <= sample;
            r_ack <= 1'b0;  //new sample starting so have to restart;
        end
    end

    sample: begin 
        if(counter != 868) begin 
            counter <= counter + 1;
        end
        
        //sampling part
        //break it up
        else if(((index != 8) || (parts != 0)) && (index != 16)) begin 
            data[(15-index)] <= C14;
            index   <= index + 1;
            counter <= 0;
        end

        //will fail when index = 16, and index = 8 and parts = 0
        else begin
            state <= stop;
        end
        end
    
    stop: begin
        if(C14 == 1'b1) state <= idle;
        if(parts != 1) begin 
        parts <= parts + 1;//
        end
        else begin 
        parts <= 0;
        index <= 0;
        r_ack <= 1'b1;
        end
        counter <= 0;
    end

    endcase


end

assign ack = r_ack; //register is ready to read

endmodule


module priority_encoder(
    input wire[9:0] i_bits,
    output wire[2:0] o_bits
    //outputwire[7:0] bits_,
    //output wire im123_,
   // output wire im567_
);

reg[2:0] r_bits;
always@(*) begin 
    r_bits[0] = ((i_bits[0] | i_bits[1]) & ~(i_bits[2])) | (i_bits[3] & ~(i_bits[4])) | (i_bits[5] & ~i_bits[6]) | i_bits[9:7]; 
    r_bits[1] = ((i_bits[2] | i_bits[3]) & ~(i_bits[4]  | i_bits[5])) | (i_bits[9:7]);
    r_bits[2] = |(i_bits[9:4]);

end
assign o_bits = r_bits;
endmodule