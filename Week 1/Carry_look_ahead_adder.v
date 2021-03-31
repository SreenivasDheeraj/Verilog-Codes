// Q1) Implement the Verilog modeling for the Carry Lookahead Adder of 4 bits
`timescale 1ns/1ps  

module CLAA(sum, cout, a, b, cin);
    output [3:0] sum;
    output cout;
    input [3:0] a, b;
    input cin;
    wire c1, c2, c3;
    wire g0, g1, g2, g3, p0, p1, p2, p3  ;

    // g = a[x] & b[x]
    // p = a[x] ^ b[x]
    // Ci+1 = Gi + PiCi 
    assign g0 = a[0] & b[0];
    assign g1 = a[1] & b[1];
    assign g2 = a[2] & b[2];
    assign g3 = a[3] & b[3];

    assign p0 = a[0] ^ b[0];
    assign p1 = a[1] ^ b[1];
    assign p2 = a[2] ^ b[2];
    assign p3 = a[3] ^ b[3];

    assign c1 = g0 | (p0 & cin);
    assign c2 = g1 | (p1 & c1);
    assign c3 = g2 | (p2 & c2);
    assign cout = g3 | (p3 & c3);

    // Sum is Si = Pi ^ Ci
    assign sum[0] = cin ^ p0;
    assign sum[1] = c1 ^ p1;
    assign sum[2] = c2 ^ p2;
    assign sum[3] = c3 ^ p3;
    
endmodule // CLAA

module CLAA_tb;
    reg [3:0] a, b;
    reg cin;
    wire [3:0] sum;
    wire cout;

    CLAA claa(sum, cout, a, b, cin);

    initial begin
        #0      a = 4'b0000; b = 4'b0000; cin = 0;
        #10     a = 4'b0000; b = 4'b0000; cin = 1;
        #10     a = 4'b1010; b = 4'b1101; cin = 0;
        #10     a = 4'b0110; b = 4'b1001; cin = 1;
        #10     a = 4'b0010; b = 4'b0010; cin = 0;
        #10     a = 4'b0101; b = 4'b0010; cin = 1;
        #10     a = 4'b1000; b = 4'b0011; cin = 0;
        #10     a = 4'b1100; b = 4'b0011; cin = 1;
        #10     a = 4'b0101; b = 4'b0100; cin = 0;
        #10     a = 4'b0000; b = 4'b0100; cin = 1;
        #10     a = 4'b1000; b = 4'b1101; cin = 0;
    end

    initial begin
        $monitor("\n%d: a=%b b=%b cin=%b sum=%b cout=%b",$time,a,b,cin,sum,cout);
    end
endmodule // CLAA_tb
