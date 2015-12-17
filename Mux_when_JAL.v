//mux for JAL before register
module mux_5bits (a,b,const,sel_0,sel_1,y);
input [4:0] a;
input [4:0] b;
input [4:0] const;
output [4:0] y;
input  sel_0;
input  sel_1;
reg [4:0] y;
integer i;

always@(a or b or sel_0 or sel_1) 
begin

if( (sel_0 ==1'b0) && (sel_1 ==1'b0) )begin               //select signal should not be 11

for(i=0;i<5;i=i+1) begin
y[i]= a[i];
end

end

else if( (sel_0 ==1'b1) && (sel_1 ==1'b0) ) begin

for(i=0;i<5;i=i+1) begin
y[i]= b[i];
end

end

else if( (sel_0 ==1'b0) && (sel_1 ==1'b1) ) begin

for(i=0;i<5;i=i+1) begin
y[i]= const[i];
end

end

end

endmodule
