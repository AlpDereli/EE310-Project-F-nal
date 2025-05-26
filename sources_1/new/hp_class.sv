`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.04.2025 21:00:54
// Design Name: 
// Module Name: c
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

module hp_class(f, fExp, fSig, isSnan, isQnan, isInfinity, isZero, isSubnormal,
                   isNormal);
    input [15:0] f;
    output signed [6:0] fExp;
    reg signed [6:0] fExp;
    output [10:0] fSig;
    reg [10:0] fSig;
    output isSnan, isQnan, isInfinity, isZero, isSubnormal, isNormal;
    
    wire expOnes, expZeroes, sigZeroes;
    
    assign expOnes   =  &f[14:10];
    assign expZeroes = ~|f[14:10];
    assign sigZeroes = ~|f[9:0];
    
    assign isSnan      =  expOnes   & ~sigZeroes & ~f[9];
    assign isQnan      =  expOnes                &  f[9];
    assign isInfinity  =  expOnes   &  sigZeroes;
    assign isZero      =  expZeroes &  sigZeroes;
    assign isSubnormal =  expZeroes & ~sigZeroes;
    assign isNormal    = ~expOnes   & ~expZeroes;
    
    reg [10:0] mask = ~0;
    reg [3:0] sa;
    
    integer i;
    
    always @(*)
      begin
        // Use actual exponent/significand values for sNaNs, qNaNs,
        // infinities, and zeroes.
        fExp = f[14:10];
        fSig = f[9:0];
        
        sa = 0;

        if (isNormal)
          {fExp, fSig} = {f[14:10] - 15, 1'b1, f[9:0]};
        else if (isSubnormal)
          begin
            // Shift the most significant bit into the position
            // of the Normal's implied 1. Keep track of how many
            // places were needed to shift the most significant
            // set bit so we can adjust the exponent when we're
            // done.
            for (i = 8; i > 0; i = i >> 1)
              begin
                if ((fSig & (mask << (11 - i))) == 0)
                  begin
                    fSig = fSig << i;
                    sa = sa | i;
                  end
              end
              
            fExp = -14 - sa; // "-14" is the smallest Normal exponent
                             // as a signed value.
          end
      end
    
endmodule

