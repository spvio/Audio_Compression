//personal encoder

module priority_encoder(
    input wire[9:0] bits,
    output wire[7:0] bits_
);

// b'
//wire bits_[7:0];

//intermediate wires
wire im2;
wire im3;
wire im4;
wire[2:0] im5;
wire[2:0] im6;
wire[2:0] im7;

//phase 1: account for edgecases
and2$ edge2(im2,bits[1], bits[0]);
or2$  o_edge2 (bits_[2], im2, bits[2]);

and3$ edge3(im3, bits[2], bits[1], bits[0]);
or2$ o_edge3 (bits_[3],im3, bits[3]);

and4$ edge41(im4, bits[3], bits[2], bits[1], bits[0]);
or2$  o_edge4(bits_[4], im4, bits[4]);

and3$ edge51(im5[0], bits[2], bits[1], bits[0]);
and2$ edge52(im5[1], bits[3], bits[5]);
and2$ edge53(im5_[2], im5[0], im5[1]);
or2$ o_edge5(bits_[5], im5[2], bit[5]);


and3$ edge61(im6[0], bits[2], bits[1], bits[0]);
and3$ edge62(im6[1], bits[3], bits[4], bits[5]);
and2$ edge63(im6[2] ,im6[0], im6[1]);
or2$ o_edge6(bits_[6], im6[2], bits[6]);

and4$ edge71(im7[0], bits[3], bits[2], bits[1], bits[0]);
and3$ edge72(im7[1], bits[4], bits[5], bits[6]);
and2$ edge73(im7[2], im7[0], im7[1]);
or2$ o_edge7(bits_[7], im7[2], bits[7]);

//buffers for bits 0 and 1 
buffer$ buffer0(bits_[0], bits[0]);
buffer$ buffer1(bits_[1], bits[1]);


endmodule
