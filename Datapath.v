module Datapath(Clock, Reset, PCSrc, MemtoReg, MemWrite, ALUSrc,
				ALUControl, ImmSrc, RegWrite, Shift, RegSrc,
				Cond, Op, Funct, Rd, Flags, Result_Out);
	
	parameter Data_W = 32;
	parameter Addr_W = 6;
	input  Clock,Reset,MemtoReg,PCSrc, ALUSrc;  
	input  MemWrite, ImmSrc, RegWrite, Shift,RegSrc;
	input  [2:0] ALUControl;
	output [3:0] Cond;
	output [1:0] Op;
	output [5:0] Funct;
	output [3:0] Rd;
	output [3:0] Flags;
	output [31:0] Result_Out;
	wire [31:0] PC_in;
	wire [31:0] PCPlus4;
	wire [31:0] PCPlus8;
	wire [31:0] Result;
	wire [31:0] PC;
	wire [31:0] Inst;
	wire [3:0] RA2;
	wire [31:0] RD1;
	wire [31:0] RD2;
	wire [31:0] SRD2;
	wire [31:0] ExtImm;
	wire [31:0] ALUResult;
	wire [31:0] ALUResultS;
	wire [31:0] ReadData;
	wire [31:0] SrcB;
	
	assign Cond  = Inst[31:28];
	assign Op	 = Inst[27:26];
	assign Funct = Inst[25:20];
	assign Rd 	 = Inst[15:12];
	assign Result_Out = Result;
	
	Mux2x1 #(.W(Data_W)) PCMux (.In0(PCPlus4), .In1(Result), .Select(PCSrc), .Out(PC_in));
	
	PC #(.Addr_W(32)) ProgramCounter (.clock(Clock), .reset(Reset), .PC_in(PC_in), .PC_out(PC));
	
	IM #(.Addr_W(64),.Data_W(Data_W)) InstructionMemory (.reset(Reset), .read_addr(PC), .read_data(Inst));
																									
	Adder #(.W(Data_W)) PC4 (.A(PC), .B(32'h4), .Result(PCPlus4));
	
	Adder #(.W(Data_W)) PC8 (.A(PCPlus4), .B(32'h4), .Result(PCPlus8));
	
	Mux2x1 #(.W(4)) RA2Mux (.In0(Inst[3:0]), .In1(Inst[15:12]), .Select(RegSrc), .Out(RA2));
	
	RF #(.Addr_W(16), .Data_W(Data_W)) RegisterFile ( .clock(Clock), .reset(Reset), 
								  .write_enable(RegWrite), .write_data(Result), 
								  .read_addr1(Inst[19:16]), .read_addr2(RA2), .pc(PCPlus8), 
								  .write_addr(Inst[15:12]), .read_data1(RD1), .read_data2(RD2));
								  
	SignExtender SE1 (.In(Inst[11:0]), .Out(ExtImm), .ExtType(ImmSrc));
	
	Shifter SH1 (.In(RD2),.ShiftType(Inst[5]),.ShiftAmount(Inst[11:7]),.Out(SRD2));
	
	Mux2x1 #(.W(Data_W)) SrcBMux (.In0(SRD2), .In1(ExtImm), .Select(ALUSrc), .Out(SrcB));
	
	ALU #(.W(Data_W)) ALU1 (.A(RD1), .B(SrcB), .ALU_Control(ALUControl), 
							.ALU_Out(ALUResult), .CO(Flags[1]), .OVF(Flags[0]), 
							.N(Flags[3]), .Z(Flags[2]));
	
	Mux2x1 #(.W(Data_W)) SHMux (.In0(ALUResult), .In1(SrcB), .Select(Shift), .Out(ALUResultS));
	
	DM #(.Addr_W(64), .Data_W(Data_W)) DataMemory (.clock(Clock), .reset(Reset), .write_enable(MemWrite), 
													.write_data(RD2), .addr(ALUResultS), .read_data(ReadData));
													
	Mux2x1 #(.W(Data_W)) ResultMux (.In0(ALUResultS), .In1(ReadData), .Select(MemtoReg), .Out(Result));												

endmodule 
	