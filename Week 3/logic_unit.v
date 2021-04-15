// Verilog Code to Implement a Logic Unit ( two 6 bit inputs and a select line (4 bits))

`timescale 1ns/1ps

module Logic_Unit(in1, in2, out, sel);
	input [3:0] sel;
	input signed[5:0] in1, in2;
	output reg signed[5:0] out;
	wire[5:0] o1, o2, o3, o4, o5, o6, o7, o8, o9, o10, o11;
	
	assign o1 = in1 & in2;
	assign o2 = in1 | in2;
	assign o3 = in1 ^ in2;
	assign o4 = in1 >>> in2;
	assign o5 = in1 <<< in2;
	assign o6 = in1 >> in2;
	assign o7 = in1 << in2;
	assign o8 = ~in1;
	assign o9 = ~in2;
		
	
	
	always @(*)
	begin
		case(sel)
			4'b0000 : out = o1; // and operation
			4'b0001 : out = o2; // or operation
			4'b0010 : out = o3; // xor operation
			4'b0011 : out = o4; // arithmetic right shift operation
			4'b0100 : out = o5; // arithmetic left shift operation
			4'b0101 : out = o6; // logical right shift operation
			4'b0110 : out = o7; // logical left shift operation
			4'b0111 : out = o8; // complement of input 1
			4'b1000 : out = o9;	// complement of input 2
		endcase
		
	end 
	
	//Circular Right Shift
	always @(*)
		if ((in2 % 6 == 0) && sel == 4'b1001)
		begin
			out = in1;
		end
		else if ((in2 % 6 == 1) && sel == 4'b1001)
		begin
			out = {in1[0], in1[5:1]};
		end
		else if ((in2 % 6 == 2) && sel == 4'b1001)
		begin
			out = {in1[1:0], in1[5:2]};
		end
		else if ((in2 % 6 == 3) && sel == 4'b1001)
		begin
			out = {in1[2:0], in1[5:3]};
		end
		else if ((in2 % 6 == 4) && sel == 4'b1001)
		begin
			out = {in1[3:0], in1[5:4]};
		end
		else if ((in2 % 6 == 5) && sel == 4'b1001)
		begin
			out = {in1[4:0], in1[5]};
		end
		
		
		//Circular Left Shift
		else if ((in2 % 6 == 0) && sel == 4'b1010)
		begin
			out = in1;
		end
		else if ((in2 % 6 == 1) && sel == 4'b1010)
		begin
			out = {in1[4:0], in1[5]};
		end
		else if ((in2 % 6 == 2) && sel == 4'b1010)
		begin
			out = {in1[3:0], in1[5:4]};
		end
		else if ((in2 % 6 == 3) && sel == 4'b1010)
		begin
			out = {in1[2:0], in1[5:3]};
		end
		else if ((in2 % 6 == 4) && sel == 4'b1010)
		begin
			out = {in1[1:0], in1[5:2]};
		end
		else if ((in2 % 6 == 5) && sel == 4'b1010)
		begin
			out = {in1[0], in1[5:1]};
		end
	
endmodule	

module test_bench;
	reg[3:0] sel;
	reg signed[5:0] in1, in2;
	wire signed[5:0] out;
	
	Logic_Unit log(in1, in2, out, sel);
	
	initial begin;
	$monitor("%d in1:%b \t in2=%b \t out=%b \t sel=%d", $time,in1, in2, out, sel);
	#0	in1=6'b000111; in2=6'b000010; sel=4'b0000;
	#10 in1=6'b000001; in2=6'b000011; sel=4'b0001;
	#10	in1=6'b000101; in2=6'b000011; sel=4'b0010;
	#10	in1=6'b001100; in2=6'b000001; sel=4'b0011;
	#10	in1=6'b000101; in2=6'b000001; sel=4'b0100;
	#10	in1=6'b001100; in2=6'b000010; sel=4'b0101;
	#10	in1=6'b000101; in2=6'b000011; sel=4'b0110;
	#10	in1=6'b000101; in2=6'b000001; sel=4'b0111;
	#10	in1=6'b001111; in2=6'b000001; sel=4'b1000;
	#10	in1=6'b100111; in2=6'b000010; sel=4'b1001;
	#10	in1=6'b100111; in2=6'b000010; sel=4'b1010;
	end 
	
endmodule







