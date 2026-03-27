
`timescale 1ns/1ps

// //when making a testbech inputs = registers;
// module tb_design;
// reg[15:0] i_bits;
// wire[15:0] o_bits;
// reg[15:0] gen_bits;


// k_bit_adder uut(.i_bits(i_bits), .Gen(gen_bits),.o_bits(o_bits));
// initial begin

// $display("Time\tinput_bits\toutput_bits\tgen_bits");
// $monitor("%0t\t%h\t\t%b\t\t%b", $time, i_bits, o_bits, gen_bits);

// //test some edgecases

// //i_bits = 16'hF001; #10;
// //i_bits = 16'hFFFF; #10;
// $finish;

// end

// endmodule;



//testing left shit module
// module lsls_v;
// reg[15:0] abs_val;
// reg[2:0] shift_b;
// wire[3:0] o_bits;

// lsls_8 uut(.i_bits(abs_val), .shift_bits(shift_b), .o_bits(o_bits));
// initial begin
//     $display("input\tshift\toutput");
//     $monitor("%b\t%b\t%b", abs_val, shift_b, o_bits);

//     abs_val = 16'h000F; shift_b = 3 'b001;  #10;
//     abs_val = 16'h0FF0; shift_b = 3'b001; #10;
//     abs_val = 16'hFFC0; shift_b = 3'b101; #10;
//     $finish;
// end


// endmodule

module compression_tb;

reg i_clk;
reg c14;
wire[7:0] o_bits;

//always #10 nanoseconds = 100 MGHZ
reg [7:0] data_sequence [0:1]; // two sequences
initial i_clk = 1'b1;
always  #10 i_clk = ~i_clk;   //dump into file //1 clock cyles is (20 ns is one clockcyle)
compression uut(.i_clk(i_clk),.c14(c14),.o_bits(o_bits));
integer i,j;
initial begin
    $dumpfile("compression.vcd");
    $dumpvars(0, compression_tb);
    data_sequence[0] = 8'b10100101; 
    data_sequence[1] = 8'b10100101; 

    for (i = 0; i < 2; i = i + 1) begin
        c14 = 1'b0;
        #(8680*2); //hold for one clock cycle
        for (j = 7; j >= 0; j = j - 1) begin
            c14 = data_sequence[i][j];
            #(8680*2); 
        end
        // Stop condition (c14 = 1)
        c14 = 1'b1;
        #(8680*2);
    end
   #100; //10 clockcyles should finish by then! 
$finish;
end


endmodule