// Wallace tree Multiplier - 4 x 4 bits

`timescale 1ns / 1ps

// Module to implement Half Adder
module Half_Adder(a,b,sum,carry);
    input a,b;
    output sum,carry;
    assign sum=a^b;
    assign carry=a&b;
endmodule

// Module to implement Full Adder
module Full_Adder(a,b,cin,sum,carry);

    input a, b, cin;
    output sum, carry;
    reg T1, T2, T3, carry;

    assign sum = a ^ b ^ cin;
    always @(a or b or cin)     // Execution at every stage
        begin
            T1 = a & b;
            T2 = a & cin;
            T3 = b & cin;
            carry=T1|T2|T3;
        end
endmodule

// Module for Wallace Algorith to multiply two numbers
module wallace(A,B,product);
    input [3:0] A,B;
    output [7:0] product;
    //internal variables - storing temporary sum and carry values
    wire s11,s12,s13,s14,s15,s22,s23,s24,s25,s26,s32,s33,s34,s35,s36,s37; // sum values
    wire c11,c12,c13,c14,c15,c22,c23,c24,c25,c26,c32,c33,c34,c35,c36,c37; // carry values
    wire [6:0] p0,p1,p2,p3;

    // Calculating Pi
    assign  p0 = A & {4{B[0]}};  // {} Repetetive concatenation
    assign  p1 = A & {4{B[1]}};
    assign  p2 = A & {4{B[2]}};
    assign  p3 = A & {4{B[3]}};

    // Initialise the final products
    assign product[0] = p0[0];          // This will ot change as there is only one term
    assign product[1] = s11;
    assign product[2] = s22;
    assign product[3] = s32;
    assign product[4] = s34;
    assign product[5] = s35;
    assign product[6] = s36;
    assign product[7] = s37;

    // Reduction layer 1
    Half_Adder ha11 (p0[1],p1[0],s11,c11);
    Full_Adder fa12(p0[2],p1[1],p2[0],s12,c12);
    Full_Adder fa13(p0[3],p1[2],p2[1],s13,c13);
    Full_Adder fa14(p1[3],p2[2],p3[1],s14,c14);
    Half_Adder ha15(p2[3],p3[2],s15,c15);

    // Reduction layer 2
    Half_Adder ha22 (c11,s12,s22,c22);
    Full_Adder fa23 (p3[0],c12,s13,s23,c23);
    Full_Adder fa24 (c13,c32,s14,s24,c24);
    Full_Adder fa25 (c14,c24,s15,s25,c25);
    Full_Adder fa26 (c15,c25,p3[3],s26,c26);

    // Final Stage
    Half_Adder ha32(c22,s23,s32,c32);
    Half_Adder ha34(c23,s24,s34,c34);
    Half_Adder ha35(c34,s25,s35,c35);
    Half_Adder ha36(c35,s26,s36,c36);
    Half_Adder ha37(c36,c26,s37,c37);

endmodule

// Test Bench Module
module Wallace_tb ;  
    reg [3:0] a;
    reg [3:0] b;

    // Outputs
    wire [7:0] prod;
    
    wallace wa(a, b, prod);

    // Test Values
    initial begin
        #0      a = 4'b0000; b = 4'b0000; 
        #10     a = 4'b0000; b = 4'b0000; 
        #10     a = 4'b1010; b = 4'b1101; 
        #10     a = 4'b0110; b = 4'b1001; 
        #10     a = 4'b0010; b = 4'b0010; 
        #10     a = 4'b0101; b = 4'b0010; 
        #10     a = 4'b1000; b = 4'b0011; 
        #10     a = 4'b1100; b = 4'b0011; 
        #10     a = 4'b0101; b = 4'b0100;
        #10     a = 4'b0010; b = 4'b0100; 
        #10     a = 4'b1010; b = 4'b1101; 
    end
    
    initial begin
        $monitor("\n%d: A =%b B =%b Product =%b ",$time,a,b,prod);
    end

endmodule
