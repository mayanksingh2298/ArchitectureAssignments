library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
entity shifter is
  port( 
      a : in std_logic_vector (31 downto 0);
      opcode : in std_logic_vector (1 downto 0);
      shiftAmount : in std_logic_vector(31 downto 0);
      carryIn : in std_logic;
      result : out std_logic_vector (31 downto 0);
      c : out std_logic
);
end shifter;
architecture func2 of shifter is
signal shiftInt : integer := 0;
signal carryInd : integer;
begin
	shiftInt <= to_integer(unsigned(shiftAmount(4 downto 0)));
--	c <= carryIn when shiftInt = 0 ELSE
--	     a(32-shiftInt) when (opcode = "00" and shiftInt /=0 ) ELSE
--	     a(shiftInt-1);
    process(carryIn,a,shiftInt,opcode)
    	begin
    		if (shiftInt = 0) then
    			c <= carryIn;
    		elsif(opcode="00") then
    			c <= a(32-shiftInt);
    		else 
    			c <= a(shiftInt-1);
    		end if;	
    end process;
   
	
	with opcode select result <=
		std_logic_vector(shift_left(unsigned(a), shiftInt)) when "00", --logical shift left
		std_logic_vector(shift_right(unsigned(a), shiftInt)) when "01", --logical shift right
		std_logic_vector(shift_right(signed(a), shiftInt)) when "10", --arithematic shift right
		std_logic_vector(rotate_right(unsigned(a), shiftInt)) when others; --right rotate
end func2;

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
entity ALU is
  port( 
      a : in std_logic_vector (31 downto 0);
      b : in std_logic_vector (31 downto 0);
      opcode : in std_logic_vector (3 downto 0);
      carry : in std_logic;

      result : out std_logic_vector (31 downto 0);
      z : out std_logic;
      n : out std_logic;
      c : out std_logic;
      v : out std_logic 
);
end ALU;
architecture func1 of ALU is
--signals
signal tempResult : std_logic_vector(31 downto 0);
signal carry1or0 :integer;
signal c31 : std_logic;
signal c32 : std_logic;
begin
    result <= tempResult;
	c31 <= a(31) xor b(31) xor tempResult(31);
	c32 <= (a(31) and b(31)) or (a(31) and tempResult(31)) or (tempResult(31) and b(31));
	with carry select carry1or0 <=
		1 when '1',
		0 when others;
	--This one changes the result, see slides 7 and 9 of lec9....implemented slide 7 only
	with opcode select tempResult <=
	    a and b when "0000", --and
	    a xor b when "0001", --xor
	    std_logic_vector(signed(a)+1+signed(not b)) when "0010", --sub
	    std_logic_vector(signed(not a)+1+signed(b)) when "0011", --rsb
	    std_logic_vector(signed(a)+signed(b)) when "0100", --add
	    std_logic_vector(signed(a)+carry1or0+signed(b)) when "0101", --adc
	    std_logic_vector(signed(a)+carry1or0+signed(not b)) when "0110", --sbc
	    std_logic_vector(signed(not a)+carry1or0+signed(b)) when "0111", --rsc
	    a and b when "1000", --tst
	    a xor b when "1001", --teq
	    std_logic_vector(signed(a)+1+signed(not b)) when "1010", --cmp
	    std_logic_vector(signed(a)+signed(b)) when "1011", --cmn
	    a or b when "1100", --orr
	    b when "1101", --mov
	    a and (not b) when "1110", --bic
	    not b when others; --mvn
	--working on flags
	n <= tempResult(31);
	z <= tempResult(31) and tempResult(30) and tempResult(29) and tempResult(28) and tempResult(27) and tempResult(26) and tempResult(25) and tempResult(24) and tempResult(23) and tempResult(22) and tempResult(21) and tempResult(20) and tempResult(19) and tempResult(18) and tempResult(17) and tempResult(16) and tempResult(15) and tempResult(14) and tempResult(13) and tempResult(12) and tempResult(11) and tempResult(10) and tempResult(9) and tempResult(8) and tempResult(7) and tempResult(6) and tempResult(5) and tempResult(4) and tempResult(3) and tempResult(2) and tempResult(1) and tempResult(0);
	c <= c31;
	v <= c31 xor c32;
end func1;





library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
entity multiplier is
	port(
		a : in std_logic_vector(31 downto 0);
		b : in std_logic_vector(31 downto 0);
		c : out std_logic_vector(31 downto 0)
);
end multiplier;
architecture func3 of multiplier is
    signal tmpMultiply : std_logic_vector(63 downto 0);
begin
    tmpMultiply <= std_logic_vector(signed(a)*signed(b));
	c <= tmpMultiply(31 downto 0);
end func3;


library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
entity RegisterFile is
	port(
		a : in std_logic_vector(31 downto 0);
		r1: in std_logic_vector(3 downto 0);
		r2: in std_logic_vector(3 downto 0);
		w1: in std_logic_vector(3 downto 0);
		clk: in std_logic;
		reset: in std_logic;
		we : in std_logic;

		pc : out std_logic_vector(31 downto 0);
		o1 : out std_logic_vector(31 downto 0);
		o2 : out std_logic_vector(31 downto 0) 
);
end RegisterFile;
architecture func4 of RegisterFile is
--Registers
type arraytype is array (0 to 15) of std_logic_vector(31 downto 0);
signal registers : arraytype;
--signal registers : array (0 to 15) of std_logic_vector(31 downto 0);
begin
	
	pc <= registers(15);
	o1 <= registers(to_integer(unsigned(r1)));
	o2 <= registers(to_integer(unsigned(r2)));
	process(clk,reset)
	begin
        if (reset = '1') then
           registers(15) <= "00000000000000000000000000000000";
        end if;
	  
	    if (clk = '1' and clk'EVENT) then
	    	if (we = '1') then
	      		registers(to_integer(unsigned(w1))) <= a;
	    	end if;
	    end if;	
	end process;
end func4;

-- offset is 0 when rightmost byte is considered
-- offset should be 00 in case of word load, 00/01 in case of half word and 00/01/10/11 for byte else wrong results
-- 000 -> ldrb
-- 001 -> ldrb signed
-- 010 -> ldrhw
-- 011 -> ldrhw signed
-- 100 -> ldr
-- 101 -> strb
-- 110 -> strhw
-- 111 -> str
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
entity ProcessorMemoryPath is
	port(
		FromReg : in std_logic_vector(31 downto 0);
		FromMem: in std_logic_vector(31 downto 0);
		offset: in std_logic_vector(1 downto 0);
		opcode: in std_logic_vector(2 downto 0);
		
		ToReg : out std_logic_vector(31 downto 0);
		ToMem : out std_logic_vector(31 downto 0);
		mwe : out std_logic_vector(3 downto 0) 
);
end ProcessorMemoryPath;
architecture func5 of ProcessorMemoryPath is
signal ext: std_logic;
signal extall1: std_logic_vector(23 downto 0);
signal extall2: std_logic_vector(15 downto 0);
begin
    with (opcode & offset) select ext <=
        FromMem(7) when "00100",
        FromMem(15) when "00101",
        FromMem(23) when "00110",
        FromMem(31) when "00111",
        FromMem(15) when "01100",
        FromMem(31) when others;
    with ext select extall1 <=
        "111111111111111111111111" when '1',
        "000000000000000000000000" when others;
    with ext select extall2 <=
            "1111111111111111" when '1',
            "0000000000000000" when others;
            
	with (offset & opcode) select ToReg <=
-- Load instruction		
		"000000000000000000000000" & FromMem(7 downto 0) when "00000", -- unsigned byte load
		"000000000000000000000000" & FromMem(15 downto 8) when "01000", -- unsigned byte load
		"000000000000000000000000" & FromMem(23 downto 16) when "10000", -- unsigned byte load
		"000000000000000000000000" & FromMem(31 downto 24) when "11000", -- unsigned byte load
        "0000000000000000"  & FromMem(15 downto 0)when "00010", -- unsigned halfWord load
        "0000000000000000"  & FromMem(31 downto 16)when "01010", -- unsigned halfWord load
		extall1 & FromMem(7 downto 0)when "00001", -- signed byte load
		extall1 & FromMem(15 downto 8)when "01001", -- signed byte load
		extall1 & FromMem(23 downto 16)when "10001", -- signed byte load
		extall1 & FromMem(31 downto 24)when "11001", -- signed byte load
		extall2 & FromMem(15 downto 0)when "00011", -- signed halfWord load
		extall2 & FromMem(31 downto 16)when "01011", -- signed halfWord load
		FromMem when "00100", -- word load
		FromReg when others;
        
    with (offset & opcode) select ToMem <=    
-- store instructions
        (("111111111111111111111111" & (FromReg(7 downto 0))) and (FromMem(31 downto 8) & "11111111")) when "00101", -- byte store
        (("1111111111111111" & FromReg(7 downto 0) & "11111111") and (FromMem(31 downto 16) & "11111111" & FromMem(7 downto 0))) when "01101", -- byte store
        (("11111111" & FromReg(7 downto 0) & "1111111111111111") and (FromMem(31 downto 24) & "11111111" & FromMem(15 downto 0))) when "10101", -- byte store
        ((FromReg(7 downto 0) & "111111111111111111111111") and ("11111111" & FromMem(23 downto 0))) when "11101", -- byte store
		(("1111111111111111" & FromReg(15 downto 0)) and (FromMem(31 downto 16) & "1111111111111111")) when "00110", -- halfWord store
        ((FromReg(15 downto 0) & "1111111111111111") and ("1111111111111111" & FromMem(15 downto 0))) when "01110", -- halfword store
		FromMem when others; -- word store
-- set ToReg or ToMem from result

	with (offset & opcode(2 downto 0)) select mwe <=
        "0001" when "00101",
        "0010" when "01101",
        "0100" when "10101",
        "1000" when "11101",
        "0011" when "00110",
        "1100" when "01110",
        "1111" when "00111",
        "0000" when others;	
end func5;


library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
entity MainDataPath is
	port(
        PW: in std_logic;
        IorD: in std_logic;
        MR: in std_logic;
        MW: in std_logic;
        IW: in std_logic;
        DW: in std_logic;
        Rsrc: in std_logic;
        M2R: in std_logic;
        RW: in std_logic;
        BW: in std_logic;
        AW: in std_logic;
        Asrc1: in std_logic;
        Asrc2: in std_logic_vector(1 downto 0);
        Fset: in std_logic;
        op: in std_logic_vector(3 downto 0);
        ReW: in std_logic;
        clk: in std_logic;     
        
        IR_out: out std_logic_vector(31 downto 0);
        flags: out std_logic_vector(3 downto 0)
);
end MainDataPath;
architecture DataPath of MainDataPath is
signal flagsTemp: std_logic_vector(3 downto 0);
signal Rn: std_logic_vector(3 downto 0); -- next 4 signals are for addresses to fetch as maybe they will be used to find value of read1 and read2
signal Rd: std_logic_vector(3 downto 0);
signal Rs: std_logic_vector(3 downto 0);
signal Rm: std_logic_vector(3 downto 0);
signal read1: std_logic_vector(3 downto 0); -- preferably address of Rn but still I have created above 4 signals for them separately
signal read1RegVal: std_logic_vector(31 downto 0); -- preferably stores Rn value or desired value at that time step
signal read2: std_logic_vector(3 downto 0); -- preferably address of Rm but still I have created above 4 signals for them separately
signal read2RegVal: std_logic_vector(31 downto 0); -- stores Rm or desired value at that time step
signal read3RegVal: std_logic_vector(31 downto 0); -- for Rs or to store value at Rs
signal read4RegVal: std_logic_vector(31 downto 0); -- for Rd or to store value at Rd
signal writeValReg: std_logic_vector(31 downto 0); -- value to be written in register in Reg file
signal writeReg: std_logic_vector(3 downto 0); -- write register address
signal resetReg: std_logic := '0';
signal carry: std_logic; -- contains carry flag to give input to others

--Mayank's signals
signal ALUresult: std_logic_vector(31 downto 0); -- contains ALU result
signal PCresult: std_logic_vector(31 downto 0); --PC result
signal MemInputAd: std_logic_vector(31 downto 0); --ad for Mem
signal MemInputWd: std_logic_vector(31 downto 0); --wd for Mem
signal IR: std_logic_vector(31 downto 0);
signal DR: std_logic_vector(31 downto 0);
signal EXResult: std_logic_vector(31 downto 0);
signal S2Result: std_logic_vector(31 downto 0);
signal A : std_logic_vector(31 downto 0);
signal B : std_logic_vector(31 downto 0);
signal ALUInputA : std_logic_vector(31 downto 0);
signal ALUInputB : std_logic_vector(31 downto 0);
signal RESresult : std_logic_vector(31 downto 0);

signal Shiftresult: std_logic_vector(31 downto 0); -- contains Shift result
signal Mulresult: std_logic_vector(31 downto 0); -- contains Multiply result
signal MemResult: std_logic_vector(31 downto 0); -- contains value fetched from memory to be loaded by ldr
signal ByteOffsetForRegister: std_logic_vector(31 downto 0); -- contains 0/1/2/3 value offset i.e after dividing by 4 left as remainder
signal WriteValMem: std_logic_vector(31 downto 0); -- contains value to be written in memory
signal mwe: std_logic_vector(3 downto 0); -- contains memory write enables
begin

    carry <= flagstemp(1) when Fset = '1'; -- To give carry flag as an input to ALU
    IR_out <= IR;
-------------------------------------------------------------------------
-----------------------------Port Mappings-------------------------------
-------------------------------------------------------------------------
    P2MPath: entity work.ProcessorMemoryPath(func5) port map(
        FromReg => read4RegVal,
        FromMem => MemResult,
        offset => ByteOffsetForRegister,
        opcode => op, -- this is wrong for now------------------------------------------------------
        
        ToReg => writeValReg,
        ToMem => writeValMem,
        mwe => mwe
    );
    Mul: entity work.multiplier(func3) port map(
        a => read1RegVal,
        b => read2RegVal,
        c => Mulresult
    );
        
    Shifter: entity work.shifter(func2) port map(
        a => read2RegVal,
        opcode => op,
        shiftAmount => read3RegVal,
        carryIn => carry,
        
        result => Shiftresult,
        c => flagstemp(1)
    );
    --THE PROBLEM IS THAT SEPERATE COPIS OF REGESTERS FOR BOTH THE ENTITIES... SO TRY TO DO IN ONE
    --TRY TO THINK OF SOMETHING GENERIC BY THINKING OF A NEWER WIRE STRUCTURE
    --BL
    --SHIFT
    --MUL/MLA
    --PC Box
    PC: entity work.RegisterFile(func4) port map(
        a => ALUresult,
        r1 => "DUMMY",
        r2 => "DUMMY",
        w1 => "1111",
        clk => clk,
        reset => '0',
        we => PW,
        pc => PCresult,
        o1 => "DUMMY",
        o2 => "DUMMY" 
    ); 
    --IorD mux
    MemInputAd <= PCresult when IorD = '0' ELSE
               <= RESresult when others;

    --IR Register
    IR <= MemResult when IW = '1';

    --DR Register
    DR <= MemResult when DW = '1';

    --M2R Mux
    writeValReg <= DR when M2R = '1' ELSE
    		 	<= RESresult when others;

    --Rsrc Mux
    read2 <= IR(3 downto 0) when Rsrc = '0' ELSE
    	  <= IR(15 downto 12) when others;
    --other inputs to Register file
    read1 <= IR(19 downto 16);
    writeReg <= IR(15 downto 12);
    --Register File (RF)
    RFile: entity work.RegisterFile(func4) port map(
        a => writeValReg,
        r1 => read1,
        r2 => read2,
        w1 => writeReg,
        clk => clk,
        reset => resetReg,
        we => RW,
        pc => "DUMMY",
        o1 => read1RegVal,
        o2 => read2RegVal 
    );

    --EX : THIS IS THE SHIFTED CONSTANT
    EXResult <= IR(11)&IR(11)&IR(11)&IR(11)&IR(11)&IR(11)&IR(11)&IR(11)&IR(11)&IR(11)&IR(11)&IR(11)&IR(11)&IR(11)&IR(11)&IR(11)&IR(11)&IR(11)&IR(11)&IR(11)&IR(11 downto 0);
    
    --Shifter: entity work.shifter(func2) port map(
    --    a => IR(7)&IR(7)&IR(7)&IR(7)&IR(7)&IR(7)&IR(7)&IR(7)&IR(7)&IR(7)&IR(7)&IR(7)&IR(7)&IR(7)&IR(7)&IR(7)&IR(7)&IR(7)&IR(7)&IR(7)&IR(7)&IR(7)&IR(7)&IR(7)&IR(7 downto 0),
    --    opcode => "11",
    --    shiftAmount => "000000000000000000000000000"&IR(11 downto 8)&"0",
    --    carryIn => carry,
        
    --    result => EXResult,
    --    c => flagstemp(1)
    --);

    --S2
    S2Result <= IR(23)&IR(23)&IR(23)&IR(23)&IR(23)&IR(23)&IR(23)&IR(23)&IR(23 downto 0);
    
    --A Register
    A <= read1RegVal when AW = '1';
    --B Register
    B <= read2RegVal when BW = '1';
    --Shifter2_B: entity work.shifter(func2) port map(
    --    a => read2RegVal,
    --    opcode => "11",
    --    shiftAmount => "000000000000000000000000000"&IR(11 downto 8)&"0",
    --    carryIn => carry,
        
    --    result => EXResult,
    --    c => flagstemp(1)
    --);

    --Asrc1 mux
    ALUInputA <= PCresult when Asrc = '1' ELSE
    		  <= A when others;
    --Asrc2 mux
    ALUInputB <= B when Asrc2 = "00" ELSE
    			 "00000000000000000000000000000100" when Asrc2 = "01" ELSE
    			 EXResult when Asrc2 = "11" ELSE
    			 S2Result when others;
   
    --ALU Box
    ALU_unit: entity work.ALU(func1) port map(
        a => ALUInputA,
        b => ALUInputB,
        opcode => op,
        carry => carry,
        
        result => ALUresult,
        z => flagsTemp(3),
        n => flagsTemp(2),
        c => flagsTemp(1),
        v => flagsTemp(0) 
    );   

    --F box
    flags <= flagsTemp when Fset = '1'; 

    RESresult <= ALUresult when ReW = '1';
          
end DataPath;

