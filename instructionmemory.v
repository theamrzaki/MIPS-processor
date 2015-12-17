module instruction_memory#(parameter size_word=2)(op,rs,rt,rd,shamt,func,read_address,clk);
input clk;
input [$clog2(size_word*4)-1:0]read_address;//log2(4*size_word=2)=3-1=2 ----->
				            //input[2:0}---->3bit address---> 8byte instructionmemory
output reg[5:0]op,func;
output reg[4:0]rs,rt,rd,shamt;
reg [7:0] register [0:size_word*4-1];// [7:0}register[0:7]
integer i;
//for assigning concept//={register[read_address][7:0] ,register[read_address+1][7:0] , register[read_address+2][7:0], register[read_address+3][7:0]};

always@(posedge clk)
    fork
	#200	for(i=2;i<8;i=i+1)   op[i-2]=register[read_address][i];               //op

	#200	for(i=0;i<3;i=i+1)   rs[i]= register[read_address+1][i+5];           //rs
	#200	for(i=0;i<2;i=i+1)   rs[i+3]= register[read_address][i];            //rs

	#200	for(i=0;i<5;i=i+1)   rt[i]= register[read_address+1][i];           //rt

	#200	for(i=3;i<8;i=i+1)   rd[i-3]=register[read_address+2][i];         //rd

	#200	for(i=0;i<2;i=i+1)   shamt[i]= register[read_address+3][i+6];    //shamt
	#200	for(i=0;i<3;i=i+1)   shamt[i+2]= register[read_address+2][i];   //shamt	

	#200	for(i=0;i<6;i=i+1)   func[i]= register[read_address+3][i];     //func
    join
initial
   begin
    $readmemh("instmem.txt",register);
   end
endmodule
