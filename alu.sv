`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////
// Engineer: Kattia Chang
// Module Name: ALU
/////////////////////////////////////////////////////////////////////
module ALU(
	input [7:0] A,
	input [7:0] B,
	input CIN,
	input [3:0] SEL,
	output logic [7:0] RES,
	output logic C,
	output logic Z   // logic used for changing outputs
	);   
	logic [8:0] nineBit;
	always_comb    
	begin
    	case(SEL)
    	0: nineBit = {1'b0, A} + {1'b0, B}; //ADD
    	1: nineBit = {1'b0, A} + {1'b0, B} +  {8'b0, CIN}; //ADDC
    	2: nineBit = {1'b0, A} - {1'b0, B}; // SUB
    	3: nineBit = {1'b0, A} - {1'b0, B} -  {8'b0, CIN}; //SUBC
    	4: nineBit = {1'b0, A} - {1'b0, B}; // CMP
    	5: nineBit = {1'b0, A} & {1'b0, B}; // AND
    	6: nineBit = {1'b0, A} | {1'b0, B}; // OR
    	7: nineBit = {1'b0, A} ^ {1'b0, B}; //EXOR
    	8: nineBit = A & B;  // TEST
    	9: nineBit = {A[7], A[6:0], CIN}; // LSL
    	10: nineBit = {A[0], CIN, A[7:1]}; // LSR
    	11: nineBit = {A[7], A[6:0], A[7]};//ROL
    	12: nineBit = {A[0], A[0], A[7:1]}; //12: ROR
    	13: nineBit = {A[0], A[7], A[7:1]};//13: ASR
    	14: nineBit = {1'b0, B};// MOV
    	15: nineBit = 0; // unused
   	default: nineBit = 0;
    	endcase
	end
 always_comb // for synchronous changes
 	begin
     	C = nineBit[8];    	
        RES = nineBit[7:0];	 
    	if(nineBit[7:0] == 0)
          	Z = 1 ;
    	else Z = 0;
  	end   
endmodule
