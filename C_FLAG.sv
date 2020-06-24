`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 
// Create Date: 02/11/2019 04:51:22 PM
// Module Name: Z_FLAG
// Description: single bit register
//////////////////////////////////////////////////////////////////////////////////


module C_FLAG(
    input LD, CLR, SET, CLK, DIN,
    output logic DOUT
    );
    
    always_ff@(posedge CLK) begin
        if (CLR==1)
            DOUT <= 0;
        else if (SET==1)
            DOUT <= 1;
        else if (LD ==1)
            DOUT <= DIN;
    end
endmodule

/////////

module SHAD_C(
    input LD, IN, CLK,
    output logic OUT);
    
    always_ff@(posedge CLK) begin
        if (LD)
            OUT <= IN;
    end
endmodule

/////////

module C_MUX(
    input C, SHAD_OUT, FLG_LD_SEL,
    output logic C_IN);
    
    always_comb begin
        if(FLG_LD_SEL == 0)
            C_IN = C;
        else if(FLG_LD_SEL == 1)
            C_IN = SHAD_OUT;
        else 
            C_IN = C;
    end
endmodule  