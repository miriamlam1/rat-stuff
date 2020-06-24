`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Miriam Lam and Kelly Wong
// Create Date: 01/28/2019 01:23:03 PM
// Module Name: SCRATCH_RAM
// Description: Stores 10-bit inputs into an address but will only use 8-bits  
// 
//////////////////////////////////////////////////////////////////////////////////
module SCRATCH_RAM(
    input [9:0] DATA_IN,
    input [7:0] SCR_ADDR,
    input SCR_WE,
    input CLK,
    output [9:0] DATA_OUT
    );
    
    
    logic [9:0] ram [0:255];
    
    initial
    begin
    int i;
    for (i = 0; i < 256; i++);
        ram[i] = 0;
    end
    
    always_ff @ (posedge CLK)
    begin
        if (SCR_WE == 1)
        ram[SCR_ADDR] = DATA_IN;
    end
    
    assign DATA_OUT = ram[SCR_ADDR];
    
    
endmodule


