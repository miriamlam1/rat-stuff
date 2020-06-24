`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2019 11:19:02 AM
// Design Name: 
// Module Name: I
//////////////////////////////////////////////////////////////////////////////////


module I(
    input I_SET,
    input I_CLR,
    input CLK,
    output logic OUT
    );
    
    always_ff@(posedge CLK)
        if (I_CLR)
            OUT <= 0;
        else if (I_SET)
            OUT <= 1;
endmodule
