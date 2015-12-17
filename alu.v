module alu(
input wire [31:0] in_1,
input wire [31:0] in_2,
input wire [3:0]alu_control,
input wire [4:0]shamt,
output reg zero_signal,
output reg [31:0] out);

parameter add=0010, addi=0011,
	  lw=1000, sw=1001,
	  sll=0100,And=0000,Andi=0001,Nor=1100,
	  beq=1010,jal=1011,jr=1111,
	  slt=0111;

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
