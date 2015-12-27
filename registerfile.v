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
		if(regwrite)register[write_register]<=#100 write_data;
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




///////////////////////to write registers at file\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
integer i,file;
reg [40:0]n[31:0];
initial
begin
n[0]="$zero";n[1]="$at";n[2]="$v0";n[3]="$v1";n[4]="$a0";n[5]="$a1";n[6]="$a2";n[7]="$a3";
n[8]="$t0";n[9]="$t1";n[10]="$t2";n[11]="$t3";n[12]="$t4";n[13]="$t5";n[14]="$t6";n[15]="$t7";
n[16]="$s0";n[17]="$s1";n[18]="$s2";n[19]="$s3";n[20]="$s4";n[21]="$s5";n[22]="$s6";n[23]="$s7";
n[24]="$t8";n[25]="$t9";n[26]="$k0";n[27]="$k1";n[28]="$gp";n[29]="$sp";n[30]="$fp";n[31]="$ra";
file = $fopen("register_file.txt","w");
$fclose(file);
end
always@(posedge clk)
	begin
		if(regwrite)
		 begin
		  	file = $fopen("register_file.txt","a");
			$fdisplay(file,"\n\n",$time,": %s -> 0x%h",n[0],register[0]);
		  	for (i = 1; i<32; i=i+1) begin
			if(i%4==0)
		  	$fdisplay(file,"%s -> 0x%h",n[i],register[i]);
			else
			$fwrite(file,"%s -> 0x%h, ",n[i],register[i]);
		  	end
			$fclose(file);
		end
	end
 ///////////////////////to write registers\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
endmodule
