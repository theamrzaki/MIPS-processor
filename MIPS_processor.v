module MIPS_processor();
reg clk;
//clk 
initial begin
clk=1;
end
always
#800 clk=~clk;

//##############################################################
//#########		instruction fetch	################
//pc counter
wire[31:0] initial_address;
wire[31:0] out_address;

pc_counter pc_counter(out_address,initial_address,clk);

//instruction memory
wire[5:0] op,func;
wire[4:0]rs,rt,rd,shamt;
instruction_memory instruction_memory(op,rs,rt,rd,shamt,func,out_address,clk);

//mux of write register
wire[1:0] regDst;
wire[4:0] write_register;
mux_5bits mux_5bits(rt,rd,5'd31,regDst[0],regDst[1],write_register);

//adder of pc+4
wire[31:0] normal_address;
adder adder(out_address ,32'd2,normal_address);

//##############################################################
//################  instruction decode #########################

//register file
wire [31:0] read_data_1,read_date_2,write_data;
wire regwrite;	   
register_file register_file(read_data_1,read_date_2,rs,rt,write_data,write_register,regwrite,clk);

//sign extend
wire[15:0] address={rd,shamt,func};
wire[31:0] extended_address;
sign_ext sign_ext(address,extended_address);


//control unit
wire Jump,Branch,MemRead,MemWrite,ALUSrc;
wire[1:0]  MemtoReg;
wire[5:0]  ALUOp;//###//can be 2 never bigger
control_unit control_unit(op,regDst,Jump,Branch,MemRead,MemtoReg,ALUOp,MemWrite,ALUSrc,regwrite);


//jump sign extension
wire [25:0] jump_26={rs,rt,rd,shamt,func};
wire [27:0] jump_28;
sl sl(jump_26,jump_28);

wire[3:0] pc_4_jump={op[5:2]};//###
wire[31:0] jump_32={pc_4_jump,jump_28};

//alu control
wire[3:0] alu_control;
wire JumpRegister;
alu_control_unit alu_control_unit(ALUOp,func,alu_control,JumpRegister);

//##############################################################
//################  exceution ##################################

//mux of 32 for read_date_2
wire[31:0] read_data_2_to_alu;
mux_32bit alu_mux_32bit(read_date_2,extended_address,ALUSrc,read_data_2_to_alu);

//alu
wire zero_signal;
wire[31:0] alu_output;
alu alu(read_data_1, read_data_2_to_alu,alu_control,shamt,zero_signal, alu_output);

//shift left 2
wire[31:0] branch_address;
sl_for_upper_alu sl_for_upper_alu(extended_address,branch_address);

//upper alu for branch
wire[31:0] updated_branch_address;
adder adder2(normal_address ,branch_address,updated_branch_address);

//and 1
wire normal_or_branch;
and a1(normal_or_branch,zero_signal,Branch);

//mux32 
wire [31:0] out_mux_normal_or_branch;
mux_32bit mux_32bit_2(normal_address,updated_branch_address,normal_or_branch,out_mux_normal_or_branch);

//mux32
mux_32bit_4input mux_32bit_4input(out_mux_normal_or_branch,jump_32,read_data_1,Jump,JumpRegister,initial_address);


//##############################################################
//################  data memory access #########################

//data memory
wire[31:0] meomry_data_output;
data_memory data_memory(meomry_data_output,alu_output,read_date_2,clk,MemWrite,MemRead);//####//1G word

//mux32
mux_32bit_4input mux_32bit_4input_of_memory(alu_output,meomry_data_output,normal_address,MemtoReg[0],MemtoReg[1],write_data);


//data_path_tracking
integer file;
integer counter;

parameter 
add=4'b0010, addi=4'b0011,lw=4'b1000, sw=4'b1001,
sll=4'b0100,And=4'b0000,Andi=4'b0001,Nor=4'b1100,
beq=4'b1010,jal=4'b1011,jr=4'b1111,slt=4'b0111;

initial begin
counter=0;
$fclose($fopen("tracking.txt","w"));
end

always @ alu_control
if(alu_control==add || alu_control==addi || alu_control==lw || alu_control==sw || alu_control==sll || alu_control==And || alu_control==And
 || alu_control==Andi || alu_control==Nor || alu_control==beq || alu_control==jal || alu_control==jal || alu_control==slt)begin
$monitor($time,": number of executed instructions:%02d,address:out_address:0x%h,alu_control:%b",counter,out_address,alu_control);
counter=counter+1;
file = $fopen("tracking.txt","a");
$fdisplay(file,$time,": instruction:%02d, address:0x%h",counter,out_address);
$fclose(file);	
end
else
$stop(2);

endmodule
