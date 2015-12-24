module control_unit(Opcode,RegDst,Jump,Branch,MemRead,MemtoReg,ALUOp,MemWrite,ALUSrc,RegWrite);
input [5:0] Opcode;//operation control code / [31-26] instruction
output reg [1:0] RegDst;//Register file register(rt/rd) mux/selector to write data to
output reg Jump;//jump to address or normal increment mux
output reg Branch;
output reg MemRead;
output reg [1:0] MemtoReg;//Register file data source(data memory/ALU) mux/selecter
output reg [5:0] ALUOp;//ALU controller opcode
output reg MemWrite;
output reg ALUSrc;//ALU 2nd input R-type or I-type mux/selector
output reg RegWrite;


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
		RegWrite<=1'b1;							//
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
		end								//
		//////////////////////////////////////////////////////////////////

		6'b101_011:begin//	save word (sw)		//////////////////
		Jump<=1'b0;							//
		Branch<=1'b0;
		MemRead<=1'b0;							//
		ALUOp<=6'b101_011;
		MemWrite<=1'b1;							//
		ALUSrc<=1'b1;
		RegWrite<=1'b0;							//
		end
		//////////////////////////////////////////////////////////////////

		6'b001_000:begin//	add imediate (addi)	//////////////////
		RegDst<=2'b00;
		Jump<=1'b0;							//
		Branch<=1'b0;
		MemRead<=1'b0;							//
		MemtoReg<=2'b00;
		ALUOp<=6'b001_000;						//
		MemWrite<=1'b0;	
		ALUSrc<=1'b1;							//
		RegWrite<=1'b1;
		end								//
		//////////////////////////////////////////////////////////////////

		6'b001_100:begin//	and imediate(andi)	//////////////////
		RegDst<=2'b00;
		Jump<=1'b0;							//
		Branch<=1'b0;
		MemRead<=1'b0;							//
		MemtoReg<=2'b00;
		ALUOp<=6'b001_100;						//
		ALUSrc<=1'b1;
		RegWrite<=1'b1;							//
		end
		//////////////////////////////////////////////////////////////////

		6'b000_100:begin//	branch equal (beq)	//////////////////
		Jump<=1'b0;							//
		Branch<=1'b1;
		MemRead<=1'b0;							//
		ALUOp<=6'b000_100;
		MemWrite<=1'b0;							//
		ALUSrc<=1'b0;
		RegWrite<=1'b0;							//
		end
		//////////////////////////////////////////////////////////////////

		6'b000_011:begin// 	jump and link (jal)	//////////////////
		RegDst<=1'b10;							//
		Jump<=1'b1;
		MemRead<=1'b1;							//
		MemtoReg<=2'b10;
		ALUOp<=6'b000_011;						//
		MemWrite<=1'b0;
		ALUSrc<=1'b1;							//
		RegWrite<=1'b0;
		end								//
		//////////////////////////////////////////////////////////////////

	endcase

end
endmodule
