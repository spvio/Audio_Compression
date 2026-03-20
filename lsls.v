module lsls_8(input wire[15:0] i_bits,
              input wire[2:0] shift_bits,
              output wire[3:0] o_bits );

integer i;
//intermediate wires aka "registers"
reg[15:0] layer1;
reg[15:0] layer2;
reg[15:0] layer3;
reg[15:0] layer4;
reg sel[3:0];



always @(*) begin 
//layer 1: aka shift 8
//calculating select line
sel[0] = shift_bits[0] & shift_bits[1] & shift_bits[2];

for(i = 0; i < 16; i = i+1) begin 
    if(i < 8) layer1[i] = (~sel[0]  & i_bits[i]) | (sel[0] & i_bits[i+8]);

    else layer1[i] = (~sel[0] & i_bits[i]);
    
end

//layer 2: aka shift 4
sel[1] = shift_bits[2] ^ (shift_bits[1] & shift_bits[0]);
for(i = 0; i < 16; i = i + 1) begin 
    if( i < 13) layer2[i] = sel[1] ? layer1[i+4] : layer1[i];

    else layer2[i] = sel[1] ? 0 : layer1[i]; 

end 


//layer 3: aka shift 2
sel[2] = shift_bits[1] ^ shift_bits[0];
for(i = 0; i < 16; i = i+1) begin 
    if(i < 14)  layer3[i] = sel[2] ? layer2[i+2] : layer2[i];
    else        layer3[i] = sel[2] ? 0 : layer2[i];
end

//layer 4: aka shift 1
sel[3] = ~shift_bits[0];
for(i = 0 ; i < 16; i = i+1) begin 
    if(i < 15) layer4[i] = sel[3] ? layer3[i+1] : layer3[i];
    else layer4[i] = sel[3] ? 0 : layer3[i];

end
end
assign o_bits = layer4[3:0];
endmodule
