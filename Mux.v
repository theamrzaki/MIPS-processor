//mux after register
module mux_32bit (a,b,sel,y);
input [31 : 0] a;
input [31 : 0] b;
output [31 : 0] y;
input sel;
reg [31 : 0] y;
integer i ;
always@(a or b or sel) 
begin
if(sel==1'b0)begin
for(i=0;i<32;i=i+1) begin
y[i]= a[i];
end
end
else begin
for(i=0;i<32;i=i+1) begin
y[i]= b[i];
end
end
end
endmodule
