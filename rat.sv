`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////
// Engineer: Miriam Lam
// Module Name: Rat Microcontroller -rat
// Description: links all of the other modules using wires
///////////////////////////////////////////////////////////////////////

module REG_MUX(
    input [1:0] RF_WR_SEL,
    input [7:0] ALU_RES,
    input [7:0] SP_OUT,
    input [7:0] FROM_STACK,
    input [7:0] IN_PORT,
    output logic [7:0] DIN);
    always_comb begin
        if (RF_WR_SEL == 0)
            DIN = ALU_RES;
        else if (RF_WR_SEL == 1)
            DIN = FROM_STACK;
        else if (RF_WR_SEL == 2)
            DIN = SP_OUT;
        else if (RF_WR_SEL == 3)
            DIN = IN_PORT;
           
        else
            DIN = 0;
    end
endmodule

module SCR_DATA_SEL_MUX(
    input SCR_DATA_SEL,
    input [7:0] DX_OUT,
    input [9:0] PC_COUNT,
    output logic [9:0] DATA_IN);
    always_comb begin
        if (SCR_DATA_SEL ==0)
            DATA_IN = DX_OUT;
        else if (SCR_DATA_SEL ==1)
            DATA_IN = PC_COUNT;
        else
            DATA_IN = 0;
     end
endmodule

module ALUY_MUX(
    input ALU_OPY_SEL,
    input [7:0] IR8,
    input [7:0] DY_OUT,
    output logic [7:0] B);
    always_comb begin
        if (ALU_OPY_SEL == 0)
            B = DY_OUT;
        else if (ALU_OPY_SEL ==1)
            B = IR8;
        else
            B = 0;
    end
endmodule

module SCR_ADDR_MUX(
    input [1:0] SCR_ADDR_SEL,
    input [7:0] DY_OUT,
    input [7:0] IR8,
    input [7:0] SP_OUT,
    output logic [7:0] SCR_ADDR);
    always_comb begin
        if(SCR_ADDR_SEL == 0)
            SCR_ADDR = DY_OUT;
        else if(SCR_ADDR_SEL == 1)
            SCR_ADDR = IR8;
        else if (SCR_ADDR_SEL == 2)
            SCR_ADDR = SP_OUT;
        else if (SCR_ADDR_SEL ==3)
            SCR_ADDR = SP_OUT - 1;
        else
            SCR_ADDR =0;
    end
endmodule

module rat(
    input CLK,
    input [7:0] IN_PORT,
    input INTR,
    input RESET,
    output IO_STRB,
    output [7:0] OUT_PORT,
    output [7:0] PORT_ID
    );
    
//init all of the wires
        //INTERRUPT
    logic I_SET;
    logic I_CLR;
        //PC
    logic PC_LD;
    logic PC_INC;
    logic [1:0] PC_MUX_SEL;
    logic [9:0]PC_COUNT, FROM_STACK;
    logic [17:0] IR; 
        //ALU
    logic ALU_OPY_SEL;
    logic [3:0] ALU_SEL;
        //REGFILE
    logic RF_WR;
    logic [1:0]RF_WR_SEL;
        //SP
    logic SP_LD;
    logic SP_INCR;
    logic SP_DECR;
        //SCRATCHRAM
    logic SCR_WE;
    logic [1:0] SCR_ADDR_SEL;
    logic SCR_DATA_SEL;
        //FLAGS
    logic FLG_C_SET;
    logic FLG_C_CLR;
    logic FLG_C_LD;
    logic FLG_Z_LD;
    logic FLG_LD_SEL;
    logic FLG_SHAD_LD;
        //RST
    logic RST;
        //C and Z flag
    logic CF;
    logic ZF;
    logic C;
    logic Z;
    logic SHAD_Z_OUT;
    logic SHAD_C_OUT;
    logic ZMUX_OUT;
    logic CMUX_OUT;
        //internals
    logic [7:0] DX_OUT;
    logic [7:0] DY_OUT;
    logic [7:0] ALU_RES;
    logic [7:0] REG_IN;
    logic [7:0] B;
    logic [7:0] SCR_ADDR;
    logic [9:0] DATA_IN;
    logic [7:0] SP_OUT;
    logic I_OUT;
        
    //init all the modules used
    ALU ratALU (
        .A(DX_OUT),
        .B(B),
        .CIN(CF),
        .SEL(ALU_SEL),
        .RES(ALU_RES),
        .C(C),
        .Z(Z));
    
    SCR_DATA_SEL_MUX ratScrDataMux(
        .SCR_DATA_SEL(SCR_DATA_SEL),
        .DX_OUT(DX_OUT),
        .PC_COUNT(PC_COUNT),
        .DATA_IN(DATA_IN));
    
    SCR_ADDR_MUX ratScrAddrMux(
        .SCR_ADDR_SEL(SCR_ADDR_SEL),
        .DY_OUT(DY_OUT),
        .IR8(IR[7:0]),
        .SP_OUT(SP_OUT),
        .SCR_ADDR(SCR_ADDR));
    
    ALUY_MUX ratAluMux(
        .ALU_OPY_SEL(ALU_OPY_SEL),
        .IR8(IR[7:0]),
        .DY_OUT(DY_OUT),
        .B(B));
    
    REG_MUX ratRegMux(
        .ALU_RES(ALU_RES),
        .RF_WR_SEL(RF_WR_SEL),
        .FROM_STACK(FROM_STACK[7:0]),
        .SP_OUT(SP_OUT),
        .IN_PORT(IN_PORT),
        .DIN(REG_IN));
    
    PC_AND_MUX ratProgramCounter (
        .FROM_IMMED(IR[12:3]),
        .FROM_STACK(FROM_STACK),
        .PC_MUX_SEL(PC_MUX_SEL),
        .PC_LD(PC_LD),
        .PC_INC(PC_INC),
        .RST(RST), //from rat
        .CLK(CLK),  //clk
        .PC_COUNT(PC_COUNT)
        );
        
    controlUnit ratControlUnit (
        .C(CF),
        .Z(ZF),
        .INTR(INTR&I_OUT),
        .RESET(RESET),
        .CLK(CLK), //clk
        .OPCODE_HI_5(IR[17:13]),
        .OPCODE_LO_2(IR[1:0]),
        .I_SET(I_SET),
        .I_CLR(I_CLR),
        .PC_LD(PC_LD),
        .PC_INC(PC_INC), 
        .PC_MUX_SEL(PC_MUX_SEL),
        .ALU_OPY_SEL(ALU_OPY_SEL), 
        .ALU_SEL(ALU_SEL), 
        .RF_WR(RF_WR), 
        .RF_WR_SEL(RF_WR_SEL), 
        .SP_LD(SP_LD),
        .SP_INCR(SP_INCR),
        .SP_DECR(SP_DECR),
        .SCR_WE(SCR_WE),
        .SCR_ADDR_SEL(SCR_ADDR_SEL),
        .SCR_DATA_SEL(SCR_DATA_SEL),
        .FLG_C_SET(FLG_C_SET),
        .FLG_C_CLR(FLG_C_CLR), 
        .FLG_C_LD(FLG_C_LD), 
        .FLG_Z_LD(FLG_Z_LD), 
        .FLG_LD_SEL(FLG_LD_SEL), 
        .FLG_SHAD_LD(FLG_SHAD_LD), 
        .RST(RST),
        .IO_STRB(IO_STRB)); 
        
    SCRATCH_RAM ratScratchRam (
        .DATA_IN(DATA_IN),
        .SCR_ADDR(SCR_ADDR),
        .SCR_WE(SCR_WE),
        .CLK(CLK), //clk
        .DATA_OUT(FROM_STACK));
        
    REG_FILE ratRegFile (
        .DIN(REG_IN),
        .ADRX(IR[12:8]),
        .ADRY(IR[7:3]),
        .RF_WR(RF_WR),
        .CLK(CLK),
        .DX_OUT(DX_OUT),
        .DY_OUT(DY_OUT));
        
    progRom ratProgRom (
        .PROG_CLK(CLK), //clk
        .PROG_ADDR(PC_COUNT),
        .PROG_IR(IR));
        
    stackPointer ratStack(
            .RST(RST),
            .SP_LD(SP_LD),
            .SP_INCR(SP_INCR),
            .SP_DECR(SP_DECR),
            .DATA_IN(DX_OUT),
            .CLK(CLK),
            .DATA_OUT(SP_OUT)
            );
        
    C_FLAG ratCFlag(
        .LD(FLG_C_LD),
        .CLR(FLG_C_CLR),
        .SET(FLG_C_SET),
        .CLK(CLK), //clk
        .DIN(CMUX_OUT),
        .DOUT(CF));
        
     Z_FLAG ratZFlag(
        .LD(FLG_Z_LD),
        .CLK(CLK), //clk
        .DIN(ZMUX_OUT),
        .DOUT(ZF));
        
     SHAD_C ratCShad(
        .CLK(CLK),
        .LD(FLG_SHAD_LD),
        .IN(CF),
        .OUT(SHAD_C_OUT));
     
     SHAD_Z ratZShad(
        .CLK(CLK),
        .LD(FLG_SHAD_LD),
        .IN(ZF),
        .OUT(SHAD_Z_OUT));
        
     C_MUX cmux(
        .C(C),
        .SHAD_OUT(SHAD_C_OUT),
        .FLG_LD_SEL(FLG_LD_SEL),
        .C_IN(CMUX_OUT));
        
     Z_MUX zmux(
        .Z(Z),
        .SHAD_OUT(SHAD_Z_OUT),
        .FLG_LD_SEL(FLG_LD_SEL),
        .Z_IN(ZMUX_OUT));
        
      I ratI(
        .I_SET(I_SET),
        .I_CLR(I_CLR),
        .CLK(CLK),
        .OUT(I_OUT));
     
        
     assign OUT_PORT = DX_OUT;
     assign PORT_ID = IR[7:0];
endmodule
