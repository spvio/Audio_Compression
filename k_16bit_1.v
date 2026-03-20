module k_bit_adder(input wire[15:0] i_bits,
                output  reg[15:0] Gen,  //monitoring purposes
                output wire[15:0] o_bits);

//output "register"
reg[15:0] r_bits;

//intermediate  wires aka 'reg'
reg[15:0] im1;
reg        c0; //carry bit
reg        G0; //generation bit 0


//propogation values
reg[15:0] prop_1; 
reg[15:0] prop_2;
reg[15:0] prop_3; 
reg[15:0] prop_4;

//generation values

//extra declaration
integer i;

//pure combinational logic
always @(*)
begin 
    c0  = i_bits[15];
    im1 = {16{i_bits[15]}} ^ i_bits;//xor all bits with MSB


    //koggestone! Depth "pre-proccesing"
    Gen[0] = im1[0] & c0;

    //layer:1   (S0, S1)
    r_bits[0] = c0 ^ im1[0];
    
    prop_1[0] = c0 ^ im1[0]; //special cases
    prop_1[1] = (c0 ^ im1[0]) & im1[1];
    for(i = 2 ; i <= 15 ;i = i + 1)   
    begin 
        prop_1[i] = im1[i] & im1[i-1]; 
    end

    Gen[1] = Gen[0] & im1[1];

    //carrying the propogation line(b0)
    prop_1[0] = c0 ^ im1[0];
 
    


    //layer:2   (S2, S3)
    for(i = 2; i <= 15 ; i = i + 1) begin 
        prop_2[i] = prop_1[i] & prop_1[i-2]; 
    end


    Gen[2] = Gen[0] & prop_1[2];
    Gen[3] = Gen[1] & prop_1[3];

    //carrying previous propogation(b1, b2)
    prop_2[0] = prop_1[0];
    prop_2[1] = prop_1[1];
   

//layer 3:
for( i = 4; i <= 15; i = i+1) begin 
    prop_3[i] = prop_2[i] & prop_2[i-4];
end
    //generation bit G4-G7
    Gen[4] = Gen[0] & prop_2[4];
    Gen[5] = Gen[1] & prop_2[5];
    Gen[6] = Gen[2] & prop_2[6];
    Gen[7] = Gen[3] & prop_2[7];
    

    //carrying previous propogation(b0,b1,b2,b3)
    prop_3[0] = prop_2[0];
    prop_3[1] = prop_2[1];
    prop_3[2] = prop_2[2];
    prop_3[3] = prop_2[3];


//layer 4:
    for(i = 8; i <= 15; i = i +1)begin 
        prop_4[i] = prop_3[i-8]  & prop_3[i];
    end

    for(i = 8; i <= 15; i = i+1) begin
        Gen[i] = Gen[i-8] & prop_3[i]; 
    end

    //previous propgation(b0-b7)
    for(i = 0; i< 8; i = i +1)begin 
        prop_4[i] = prop_3[i];
    end

    //post proccessing for rest of bits 
    for(i = 1; i <= 15; i = i+1) begin 
        r_bits[i] = im1[i] ^ Gen[i-1]; //origial propgate bit.
    end


end

assign o_bits = r_bits; 
endmodule
