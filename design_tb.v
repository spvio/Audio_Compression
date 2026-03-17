
`timescale 1ns/1ps

//when making a testbech inputs = registers;
module tb_design;
reg[9:0] bits;
wire[3:0] o_bits;
wire[7:0] bits_;
wire one;
wire two;

priority_encoder uut(.bits(bits), .o_bits(o_bits), .bits_(bits_), .im123_(one), .im567_(two));
initial begin

$display("Time\tinput_bits\toutput_bits\titermediate_bits\tim");
$monitor("%0t\t%b\t%b\t\t%b\t%b\t%b", $time, bits, o_bits, bits_, one, two);

//test some edgecases

bits = 10'b0000000000; #10;
bits = 10'b0000000001; #10;
bits = 10'b0000000010; #10;
bits = 10'b0000000100; #10;
bits = 10'b0000001000; #10;
bits = 10'b0000010000; #10;
bits = 10'b0000100000; #10;
bits = 10'b0001000000; #10;
bits = 10'b0010000000; #10;
bits = 10'b0100000000; #10;
bits = 10'b1000000000; #10;








$finish;


end

endmodule;