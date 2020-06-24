`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Miriam Lam and Kelly Wong
// Create Date: 01/28/2019 01:26:40 AM
// Module Name: REG_FILE
// Description: regFile - a 32x8 bit register that writes
// and reads to DX and DY
// 
//////////////////////////////////////////////////////////////////////////////////


module REG_FILE(
    input [7:0] DIN,
    input [4:0] ADRX,
    input [4:0] ADRY,
    input RF_WR,
    input CLK,
    output [7:0] DX_OUT,
    output [7:0] DY_OUT
    );
    
    
    //Create a memory with 8 bit width & 32 addresses
    logic [7:0] RAM [0:31]; // memory file that is 8 bit by 32 addresses (8 rows x 32 columns)
    initial
    begin
    int i; // start of the loop
    for (i = 0; i < 32; i++)
        RAM[i] = 0; // initializing whole roll to be 0's
    end
    
    always_ff @(posedge CLK)
    begin
    if(RF_WR == 1) // data is saved in the RAM memory synchronously on the rising edge of the clock
                    //data DIN will save if write enable RF_WR is high
        RAM[ADRX] = DIN;
    end
    
    assign DX_OUT = RAM [ADRX]; //asynch 
    assign DY_OUT = RAM [ADRY];  
    
endmodule
