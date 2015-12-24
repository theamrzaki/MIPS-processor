module pc_counter(out_add,in_add,clk);

output reg[31:0]out_add;
input [31:0]in_add;
reg [31:0]intermediate;
input clk;
initial
intermediate=32'h00000000;
always @(in_add)
intermediate=in_add;
//pure d_flip_flop
always@(clk)
out_add=intermediate;
endmodule
