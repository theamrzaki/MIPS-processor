module pc_counter(out_add,in_add,clk);

output reg[31:0]out_add;
input [31:0]in_add;
input clk;

//pure d_flip_flop
always@(clk)
	out_add<=in_add;

initial
      begin
	out_add<=0;
	end

endmodule
