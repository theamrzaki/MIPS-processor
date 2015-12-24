module alu(
input wire [31:0] in_1,
input wire [31:0] in_2,
input wire [3:0]alu_control,
input wire [4:0]shamt,
output reg zero_signal,
output reg [31:0] out);

parameter add=4'b0010, addi=4'b0011,
	  lw=4'b1000, sw=4'b1001,
	  sll=4'b0100,And=4'b0000,Andi=4'b0001,Nor=4'b1100,
	  beq=4'b1010,jal=4'b1011,jr=4'b1111,
	  slt=4'b0111;

always@(alu_control)
   begin #200
	case(alu_control)
		//########################################################################
		//########################################################################
		////----simple arithmatic operations-------
		add:  out=in_1+in_2;
		addi: out=in_1+in_2; //in_2 after sign extenstion is 32 bits
		

		//########################################################################
		//########################################################################
		////----computes memory access-------
		lw: out=in_1+in_2;  //lw $5,4($1)-----$5=Mem[4+$1]-------4 after sign extension
		sw: out=in_1+in_2;  //sw $5,4($1)-----Mem[4+$1]=$5-------4 after sign extension
		



		//########################################################################
		//########################################################################
		////----logical operations-----------
		sll: out=in_1<<shamt;	// sll  d,s,shft           # $d gets the bits in $s 
                  		        //sll out,in_1,shamt	  //# shifted left logical
                						  // # by shft positions,
                						  // # where  0 ? shft < 32
		And: out=in_1 && in_2;
		Andi: out=in_1 && in_2;//after in_2 is extended
		Nor: out= !(in_1 || in_2);



		//########################################################################
		//########################################################################
		////----branch and jump---------------------
		beq://@@@@@@@@@special case in case of beq let out=0
		if(in_1 == in_2)
			begin
			zero_signal=1;  ////if in_1-in_2=0  or in_1==in_2 --->zero signal=1
			out=0; 
			 end
		else
			begin
			 zero_signal=0;
			out=0;
			end 
		jal: out=in_1<<0;//sll 0------> no operation
		jr:  out=in_1<<0;//sll 0------> no operation
	
			
		//########################################################################
		//########################################################################
		////----set if less than---------------------
		slt:if(in_1 < in_2) //set output to 1 if in_1 < in_2
			begin
			out=1; 
			 end
		else
			begin
			 out=0;
			end  
	endcase
   end
endmodule



module alu_test;
reg [31:0] in_1;
reg [31:0] in_2;
reg [3:0]alu_control;
reg [4:0]shamt;
wire zero_signal;
wire [31:0] out;
initial begin
in_1=32'h000000000;
in_2=32'h000000004;
alu_control=4'b0011;
shamt=5'b00000;
end
alu alu(in_1,in_2,alu_control,shamt,zero_signal,out);
always
begin
#100 $monitor($time,": in_1:%b,in_2:%b,alu_control:%b,shamt:%b,zero_signal:%b,out:%b",in_1,in_2,alu_control,shamt,zero_signal,out);
end 
endmodule
