`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/22/2019 05:59:42 PM
// Design Name: 
// Module Name: stackPointer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module stackPointer(
    input RST,
    input SP_LD,
    input SP_INCR,
    input SP_DECR,
    input [7:0] DATA_IN,
    input CLK,
    output logic [7:0] DATA_OUT
    );
    
    always_ff@(posedge CLK) begin
        if (RST)
            DATA_OUT <= 0;
        else if (SP_INCR)
            DATA_OUT ++;
        else if (SP_DECR)
            DATA_OUT --;
        else if (SP_LD)
            DATA_OUT <= DATA_IN;
    end
    
endmodule
