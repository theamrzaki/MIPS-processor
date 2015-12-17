module adder (in1 ,in2,out);

input [31:0] in1;
input [31:0] in2;     //should be 4 byte (32bit) ??
output [31:0] out;
assign out = in1 +in2;
endmodule
