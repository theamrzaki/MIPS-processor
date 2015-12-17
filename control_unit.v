module control_unit(Opcode,Funct,RegDst,Jump,Branch,MemRead,MemtoReg,ALUOp,MemWrite,ALUSrc,RegWrite,JumpRegister);
input [5:0] Opcode;//operation control code / [31-26] instruction
input [5:0] Funct;//R-type function /[5-0] instruction
output reg [1:0] RegDst;//Register file register(rt/rd) mux/selector to write data to
output reg Jump;//jump to address or normal increment mux
output reg Branch;
output reg MemRead;
output reg [1:0] MemtoReg;//Register file data source(data memory/ALU) mux/selecter
output reg [5:0] ALUOp;//ALU controller opcode
output reg MemWrite;
output reg ALUSrc;//ALU 2nd input R-type or I-type mux/selector
output reg RegWrite;
output reg JumpRegister;//Jump to address specified in register 


always @ (Opcode) begin #50
	case(Opcode)
		6'b000_000:begin//	R-type instructions	//////////////////
		RegDst<=2'b01;							//
		Jump<=1'b0;
		Branch<=1'b0;							//
		MemRead<=1'b0;
		MemtoReg<=2'b00;						//
		ALUOp<=6'b000_000;           
		MemWrite<=1'b0;							//
		ALUSrc<=1'b0;
		JumpRegister<=1'b0;						//
		if (Funct==6'b001_000) begin//	jr instruction check		//
		RegWrite<=1'b0;							//	
		JumpRegister<=1'b1;						
		end else							//
		RegWrite<=1'b1;	
		JumpRegister<=1'b0;						//
		end
		//////////////////////////////////////////////////////////////////

		6'b100_011:begin//	load word (lw)		//////////////////
		RegDst<=2'b00;
		Jump<=1'b0;							//
		Branch<=1'b0;
		MemRead<=1'b1;							//
		MemtoReg<=2'b01;
		ALUOp<=6'b100_011;						//
		MemWrite<=1'b0;
		ALUSrc<=1'b1;							//
		RegWrite<=1'b1;
		JumpRegister<=1'b0;						//
		end
		//////////////////////////////////////////////////////////////////

		6'b101_011:begin//	save word (sw)		//////////////////
		//RegDst<=2'bxx;
		Jump<=1'b0;							//
		Branch<=1'b0;
		MemRead<=1'b0;							//
		MemtoReg<=2'bxx;
		ALUOp<=6'b101_011;						//
		MemWrite<=1'b1;
		ALUSrc<=1'b1;							//
		RegWrite<=1'b0;
		JumpRegister<=1'b0;						//
		end
		//////////////////////////////////////////////////////////////////

		6'b001_000:begin//	add imediate (addi)	//////////////////
		RegDst<=2'b01;
		Jump<=1'b0;							//
		Branch<=1'b0;
		MemRead<=1'b0;							//
		MemtoReg<=2'b00;
		ALUOp<=6'b001_000;						//
		MemWrite<=1'b0;	
		ALUSrc<=1'b1;							//
		RegWrite<=1'b1;
		JumpRegister<=1'b0;						//
		end
		//////////////////////////////////////////////////////////////////

		6'b001_100:begin//	and imediate(andi)	//////////////////
		RegDst<=2'b01;
		Jump<=1'b0;							//
		Branch<=1'b0;
		MemRead<=1'b0;							//
		MemtoReg<=2'b00;
		ALUOp<=6'b001_100;						//
		MemWrite<=1'bx;
		ALUSrc<=1'b1;							//
		RegWrite<=1'b1;
		JumpRegister<=1'b0;						//
		end
		//////////////////////////////////////////////////////////////////

		6'b000_100:begin//	branch equal (beq)	//////////////////
		RegDst<=2'bxx;
		Jump<=1'b0;							//
		Branch<=1'b1;
		MemRead<=1'b0;							//
		MemtoReg<=2'bxx;
		ALUOp<=6'b000_100;						//
		MemWrite<=1'b0;
		ALUSrc<=1'b0;							//
		RegWrite<=1'b0;
		JumpRegister<=1'b0;						//
		end
		//////////////////////////////////////////////////////////////////

		6'b000_011:begin// 	jump and link (jal)	//////////////////
		RegDst<=1'b10;
		Jump<=1'b1;							//
		Branch<=1'bx;
		MemRead<=1'b1;							//
		MemtoReg<=2'b10;
		ALUOp<=6'b000_011;						//
		MemWrite<=1'b0;
		ALUSrc<=1'b1;							//
		RegWrite<=1'b0;
		JumpRegister<=1'b0;						//
		end
		//////////////////////////////////////////////////////////////////

	endcase

end
endmodule
