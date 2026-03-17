//personal encoder

module priority_encoder(
    input wire[9:0] bits,
    output wire[3:0] o_bits,
    output wire[7:0] bits_,
    output wire im123_,
    output wire im567_
);

// b'
//wire bits_[7:0];
//wire[7:0] bits_;
//intermediate wires

wire[2:0] im1;
wire      e_im1;
wire im2;
wire im3;
wire im4;
wire[2:0] im5;
wire[2:0] im6;
wire[2:0] im7;

//phase 1: account for edgecases

or(bits_[1],bits[1], bits[0]);

and edge2(im2,bits[1], bits[0]);
or  o_edge2 (bits_[2], im2, bits[2]);

and edge3(im3, bits[2], bits[1], bits[0]);
or o_edge3 (bits_[3],im3, bits[3]);

and edge41(im4, bits[3], bits[2], bits[1], bits[0]);
or  o_edge4(bits_[4], im4, bits[4]);

and edge51(im5[0], bits[2], bits[1], bits[0]);
and edge52(im5[1], bits[3], bits[4]);
and edge53(im5[2], im5[0], im5[1]);
or o_edge5(bits_[5], im5[2], bits[5]);


and edge61(im6[0], bits[2], bits[1], bits[0]);
and edge62(im6[1], bits[3], bits[4], bits[5]);
and edge63(im6[2] ,im6[0], im6[1]);
or o_edge6(bits_[6], im6[2], bits[6]);

and edge71(im7[0], bits[3], bits[2], bits[1], bits[0]);
and edge72(im7[1], bits[4], bits[5], bits[6]);
and edge73(im7[2], im7[0], im7[1]);
or o_edge7(bits_[7], im7[2], bits[7], bits[8], bits[9]);

//buffers for bits 0 
buf buffer0(bits_[0], bits[0]);

nor(im1[0],bits[3], bits[2], bits[1], bits[0]);
nor(im1[1],bits[4], bits[5], bits[6], bits[7]);
nor(im1[2],bits[8], bits[9]);
and(e_im1, im1[0], im1[1], im1[2]);




//bit 0(aka odd or even)
//intermediate gates
wire im_o1;
wire n_im3_;
wire n_im5_;
wire n_im7_;
wire[3:0] bit0;

not not3(n_im3_, bits_[3]);
not not5(n_im5_, bits_[5]);
not not7(n_im7_, bits_[7]);

//nor     (bit0[3], bits_[0], bits_[1]);
and and23(bit0[0], bits_[2], n_im3_);
and and45(bit0[1], bits_[4], n_im5_);
and and67(bit0[2], bits_[6], n_im7_);

or o1(o_bits[0], bit0[0], bit0[1], bit0[2], e_im1);


//bit 1 
//intermediate wires
wire im12_;
//wire im123_;
wire im56_;
//wire im567_;

nor(im12_, bits_[1], bits_[2]);
nor(im123_, im12_, bits_[3]);



nor(im56_, bits_[5], bits_[6]);
nor(im567_, im56_, bits_[7]);
or (o_bits[1], im123_, im567_);

//bit 2
//intermediate wires
wire im3456_;
nor(im3456_ ,bits_[3], bits_[4], bits_[5], bits_[6]);
nor(o_bits[2] ,im3456_, bits_[7]);

//bit 3;
buf(o_bits[3], bits_[7]);

endmodule
