#include <stdint.h>
#include <stdio.h>


//8 segments
uint16_t thresholds[7] = {31, 95, 223, 479, 991, 2015, 4063};
int8_t segment(int16_t num){
int32_t j = 0;
for(int i = 0; i < 7; i++){
    if(thresholds[i] >= num){
        return (i);
    }
}
return 7;
}


int main(){
int16_t x = 0xa5a5;
uint8_t mask = 0x00;
if(x < 0){
    x = -x;
    mask = 0xFF;
} //getting absolute value
uint8_t seg = segment(x);
uint8_t f1 = ((seg) << 4)  | ((x >> (seg+1)) & (0xF));
printf("%x\tmask: %x\tsegment: %x \tx: %d, \tf1: %x \tshift: %d" , (f1 ^ mask), mask, seg, x, f1, ((x >> (seg))));
return 0;

}