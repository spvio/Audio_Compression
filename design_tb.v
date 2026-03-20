
`timescale 1ns/1ps

//when making a testbech inputs = registers;
module tb_design;
reg[15:0] i_bits;
wire[15:0] o_bits;
reg[15:0] gen_bits;


k_bit_adder uut(.i_bits(i_bits), .Gen(gen_bits),.o_bits(o_bits));
initial begin

$display("Time\tinput_bits\toutput_bits\tgen_bits");
$monitor("%0t\t%h\t\t%b\t\t%b", $time, i_bits, o_bits, gen_bits);

//test some edgecases

i_bits = 16'hF001; #10;
i_bits = 16'hFFFF; #10;







$finish;


end

endmodule;