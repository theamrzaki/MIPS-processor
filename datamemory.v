module data_memory#(parameter size_ward=2)(read_data,address,write_data,clk,memwrite,memread);
output reg[31:0]read_data;
input [31:0]write_data;
input [$clog2(4*size_ward)-1:0]address;
input memread,memwrite,clk;
reg [7:0] regester [0:size_ward*4-1];
//async read
always@(posedge  clk or address )
	#200    read_data<={regester[address],regester[address+1],regester[address+2],regester[address+3]};
always @(posedge clk)
	 #500
	  if(memwrite&!memread)
	   fork
	#200	regester[address]<=write_data[31:24];
	#200	regester[address+1]<=write_data[23:16];
	#200	regester[address+2]<=write_data[15:8];
	#200	regester[address+3]<=write_data[7:0];
	#201    $writememh("datamem.txt",regester);
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
    $readmemh("initial_datamem.txt",regester);
   end

endmodule
