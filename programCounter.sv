`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Miriam Lam
// Create Date: 01/17/2019 09:24:55 AM
// Module Name: PC_AND_MUX
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module PC_AND_MUX(
    input [9:0] FROM_IMMED,
    input [9:0] FROM_STACK,
    input [1:0] PC_MUX_SEL,
    
    input PC_LD,
    input PC_INC,
    input RST,
    input CLK,
    output [9:0] PC_COUNT
    );
    
    logic [9:0] p;
    PC_MUX mux1(.FROM_IMMED(FROM_IMMED),.FROM_STACK(FROM_STACK),.PC_MUX_SEL(PC_MUX_SEL),.DOUT(p));
    ProgramCounter pcount1(.PC_LD(PC_LD),.PC_INC(PC_INC),.RST(RST),.CLK(CLK),.DIN(p),.PC_COUNT(PC_COUNT));
endmodule

module PC_MUX(
    input [9:0] FROM_IMMED,
    input [9:0] FROM_STACK,
    //10'h0x3FF,
    input [1:0] PC_MUX_SEL,
    output logic [9:0] DOUT = 0
    );
    
    always_comb
    begin
        if(PC_MUX_SEL ==0)
            DOUT = FROM_IMMED;
        else if (PC_MUX_SEL ==1)
            DOUT = FROM_STACK;
        else
            DOUT = 10'h3FF;
     end
endmodule

module ProgramCounter(
    input [9:0] DIN, 
    input PC_LD,
    input PC_INC,
    input RST,
    input CLK,
    output logic [9:0] PC_COUNT
    );
    
    always_ff @(posedge CLK)
    begin
        if (RST == 1)
            PC_COUNT <= 0;
        else if (PC_INC ==1)
            PC_COUNT++;
        else if (PC_LD ==1)
            PC_COUNT <= DIN;
    end
endmodule
