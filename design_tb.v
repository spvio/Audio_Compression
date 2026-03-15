
`timescale 1ns/1ps

//when making a testbech inputs = registers;
module tb_design;
reg[9:0] bits;
wire[7:0] bits_;

priority_encoder uut(.bits(bits), .bits_(bits_));
initial begin

$display("Time\tinput_bits\toutput_bits");
$monitor("%0t\t%b\t%b", $time, bits, bits_);

//test some edgecases:
bits = 10'b0000011111; #10;
bits = 10'b0000000111; #10;

$finish;


end

endmodule;