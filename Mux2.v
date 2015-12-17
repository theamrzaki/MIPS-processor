//mux before register
module mux_2 (a,b,sel,y);
input [4:0] a;
input [4:0] b;
output [4:0] y;
input sel;
reg [4:0] y;
integer i;

always@(a or b or sel) 
begin

if(sel==1'b0)begin

for(i=0;i<5;i=i+1) begin
y[i]= a[i];
end

end

else begin

for(i=0;i<5;i=i+1) begin
y[i]= b[i];
end

end

end

endmodule
