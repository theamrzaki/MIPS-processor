module instruction_memory(op,rs,rt,rd,shamt,func,read_address,clk);
input clk;
input [31:0]read_address;
output reg[5:0]op,func;
output reg[4:0]rs,rt,rd,shamt;
reg [7:0] regester [0:31];
always@(posedge clk)
    fork
	#200  op={regester[read_address][7:2]};            
	#200  rs={regester[read_address][1:0],regester[read_address+1][7:5]};
	#200  rt={regester[read_address+1][4:0]};
	#200  rd={regester[read_address+2][7:3]};
	#200  shamt={regester[read_address+2][2:0],regester[read_address+3][7:6]};
	#200  func={regester[read_address+3][5:0]};
    join
initial
   begin
    $readmemb("instmem.txt",regester);
   end
endmodule

module instruction_memory_test;

reg clk;
reg [31:0]read_address;
wire[5:0]op,func;
wire[4:0]rs,rt,rd,shamt;

instruction_memory instruction_memory(op,rs,rt,rd,shamt,func,read_address,clk);

initial begin
clk=1;
read_address=32'h00000000;
end

always
begin
#100 clk=~clk;
$monitor($time,"op:%b,rs:%b,rt:%b,rd:%b,shamt:%b,func:%b,read_address:%b,clk:%b",op,rs,rt,rd,shamt,func,read_address,clk);
end
endmodule
