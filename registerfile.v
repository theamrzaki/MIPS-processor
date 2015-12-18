module register_file(read_data_1,read_date_2,read_register_1,read_register_2,write_data,write_register,regwrite,clk);
output reg[31:0]read_data_1,read_date_2;
input [4:0]read_register_1,read_register_2,write_register;
input [31:0]write_data;
input regwrite,clk;
reg [31:0]register[0:31];
	initial
	  begin
  	     register[0]=32'h00000000;
	  end
	always@(posedge clk)
		#700	//xxx1  &&  //1010
		if(regwrite&&write_register)register[write_register]<=#100 write_data;
		// any write register -->results in a number(logical operator)....bec of && it would be seen as true 
		// sees a number not bits

//sync read
	/*always@(posedge clk)  
		fork  
		#200  read_data_1<=#100 register[read_register_1];
		#200  read_date_2<=#100 register[read_register_2];		
 		join*/
//async read
always@(posedge clk or read_register_1 or read_register_2)  
		fork  
		  read_data_1<=#100 register[read_register_1];
		  read_date_2<=#100 register[read_register_2];		
 		join
	
endmodule
