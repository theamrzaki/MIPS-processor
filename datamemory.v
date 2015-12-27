module data_memory(read_data,address,write_data,clk,memwrite,memread);
output reg[31:0]read_data;
input [31:0]write_data;
input [31:0]address;
input memread,memwrite,clk;
reg [7:0] regester [0:31];
//async read
always@(posedge  clk or address )
	#200    read_data<={regester[address],regester[address+1],regester[address+2],regester[address+3]};
always @(posedge clk)
	 #500
	  if(memwrite & !memread)
	   fork
	#200	regester[address]<=write_data[31:24];
	#200	regester[address+1]<=write_data[23:16];
	#200	regester[address+2]<=write_data[15:8];
	#200	regester[address+3]<=write_data[7:0];
	#201    $writememb("datamem.txt",regester);

	   join
  
//sync read
/*always @(posedge clk)
   begin
	 #500
	 if(memread&!memwrite)
	#200    read_data<={regester[address],regester[address+1],regester[address+2],regester[address+3]};
	 else if(memwrite&!memread)
	     fork
	#200	regester[address]<=write_data[31:24];
	#200	regester[address+1]<=write_data[23:16];
	#200	regester[address+2]<=write_data[15:8];
	#200	regester[address+3]<=write_data[7:0];
	#201    $writememh("datamem.txt",regester);
	   join
   end	
*/
initial
   begin
    $readmemb("initial_datamem.txt",regester);
   end

endmodule



module data_memory_test;

wire[31:0]read_data;
reg [31:0]write_data;
reg [31:0]address;
reg memread,memwrite,clk;
data_memory data_memory(read_data,address,write_data,clk,memwrite,memread);
initial begin
clk=1;
//sw $s1,0($t2)
memread=1'b0;
memwrite=1'b1;
address=32'h00000010;
write_data=32'hffffffffff;

#1000
//lw $s1,0($t5)
memread=1'b1;
memwrite=1'b0;
address=32'h00000010;
end

always
begin
#800 clk=~clk;
$monitor($time,": read_data:%h,address:%b,write_data:%h,clk:%b,memwrite:%b,memread:%b",read_data,address,write_data,clk,memwrite,memread);
end

endmodule
