`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Miriam Lam
// Create Date: 02/11/2019 04:51:22 PM
// Module Name: Z_FLAG
// Description: single bit register
//////////////////////////////////////////////////////////////////////////////////

module Z_FLAG(
    input LD,DIN,CLK,
    output logic DOUT
    );
    
    always_ff@(posedge CLK) begin
        if (LD ==1)
            DOUT <= DIN;
    end
endmodule

//////

module SHAD_Z(
    input LD, IN, CLK,
    output logic OUT);
    
    always_ff@(posedge CLK) begin
        if (LD)
            OUT <= IN;
    end
endmodule

///////

module Z_MUX(
    input Z, SHAD_OUT, FLG_LD_SEL,
    output logic Z_IN);
    
    always_comb begin
        if(FLG_LD_SEL == 0)
            Z_IN = Z;
        else if(FLG_LD_SEL == 1)
            Z_IN = SHAD_OUT;
        else 
            Z_IN = Z;
    end
endmodule  