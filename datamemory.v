module data_memory#(parameter size_ward=2)(read_data,address,write_data,clk,memwrite,memread);
output reg[31:0]read_data;
input [31:0]write_data;
input [$clog2(4*size_ward)-1:0]address;
input memread,memwrite,clk;
reg [7:0] regester [0:size_ward*4-1];
integer i,j;
//async read
always@(posedge  clk or address )
	  #200
	  for(j=3;j>=0;j=j-1)
	     begin
		 for(i=0;i<8;i=i+1)
		 read_data[j*8+i]<=regester[address+3-j][i];
	     end
always @(posedge clk)
	 #500
	  if(memwrite&!memread)
	   begin
	      #200
		for(j=3;j>=0;j=j-1)
		 begin
		  for(i=0;i<8;i=i+1)
		  regester[address+3-j][i]<=write_data[j*8+i];
		 end		
		#1 $writememh("datamem.txt",regester);
	   end
  
//sync read
/*always @(posedge clk)
   begin
	 #500
	 if(memread&!memwrite)
	  #200
	  for(j=3;j>=0;j=j-1)
	     begin
		 for(i=0;i<8;i=i+1)
		 read_data[j*8+i]<=regester[address+3-j][i];
	     end
	 else if(memwrite&!memread)
	   begin
	      #200
		for(j=3;j>=0;j=j-1)
		 begin
		  for(i=0;i<8;i=i+1)
		  regester[address+3-j][i]<=write_data[j*8+i];
		 end		
		#1 $writememh("datamem.txt",regester);
	   end
   end	
*/
initial
   begin
    $readmemh("initial_datamem.txt",regester);
   end

endmodule
