//mux for JAL after memory
module mux_32bit_4input (a,b,pcPlus4,sel_0,sel_1,y);
input [31:0] a;
input [31:0] b;
input [31:0] pcPlus4;
output [31:0] y;
input  sel_0;
input  sel_1;
reg [31:0] y;
integer i;

always@(a or b or sel_0 or sel_1) 
begin

if( (sel_0 ==1'b0) && (sel_1 ==1'b0) )begin               //select signal should not be 11

for(i=0;i<32;i=i+1) begin
y[i]= a[i];
end

end

else if( (sel_0 ==1'b1) && (sel_1 ==1'b0) ) begin

for(i=0;i<32;i=i+1) begin
y[i]= b[i];
end

end

else if( (sel_0 ==1'b0) && (sel_1 ==1'b1) ) begin

for(i=0;i<32;i=i+1) begin
y[i]= pcPlus4[i];
end

end

end


endmodule
