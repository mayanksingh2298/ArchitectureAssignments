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


-- MR and MW are of 3 bits each

-- MR = 101 and MW = 000 -> ldrb
-- MR = 001 and MW = 000 -> ldrb signed
-- MR = 010 and MW = 000 -> ldrhw
-- MR = 011 and MW = 000 -> ldrhw signed
-- MR = 100 and MW = 000 -> ldr
-- MR = 000 and MW = 001 -> strb
-- MR = 000 and MW = 010 -> strhw
-- MR = 000 and MW = 011 -> str

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
entity MemoryModule is
	port(
		address : in std_logic_vector(31 downto 0);
		WriteData: in std_logic_vector(31 downto 0);
		MR: in std_logic_vector(2 downto 0);
		MW: in std_logic_vector(2 downto 0);
		clk: in std_logic;

		RD : out std_logic_vector(31 downto 0) 
);
end MemoryModule;
architecture func0 of MemoryModule is
--Registers
type arraytype is array (0 to 1000) of std_logic_vector(31 downto 0);
signal memory : arraytype;

signal op : std_logic_vector(2 downto 0);
signal ByteOffsetForRegister : std_logic_vector(1 downto 0);
signal mwe : std_logic_vector(3 downto 0);
signal ProcReg : std_logic_vector(31 downto 0);
signal MemReg : std_logic_vector(31 downto 0);
signal ToProcReg : std_logic_vector(31 downto 0);
signal ToMemReg : std_logic_vector(31 downto 0);
signal ArrayIndex : integer;
begin
	op <= "000" when ((MR = "101") and (MW = "000")) else
		"001" when ((MR = "001") and (MW = "000")) else
		"010" when ((MR = "010") and (MW = "000")) else
		"011" when ((MR = "011") and (MW = "000")) else
		"100" when ((MR = "100") and (MW = "000")) else
		"101" when ((MR = "000") and (MW = "001")) else
		"110" when ((MR = "000") and (MW = "010")) else
		"111";
	ByteOffsetForRegister <= address(1 downto 0);
	ArrayIndex <= to_integer(unsigned("00" & unsigned(address(31 downto 2))));
	
	MemReg <= memory(ArrayIndex);
	--memory(ArrayIndex) <= ToMemReg;

	ProcReg <= WriteData when (MW /= "000");
	RD <= ToProcReg when (MR /= "000");
	
	process(clk)
	begin
        if (clk = '1' and clk'EVENT) then
	    	if (MW /= "000") then
	      		memory(ArrayIndex) <= ToMemReg;
	    	end if;
	    end if;	
	end process;

	P2MPath: entity work.ProcessorMemoryPath(func5) port map(
        FromReg => ProcReg,
        FromMem => MemReg,
        offset => ByteOffsetForRegister,
        opcode => op,
        
        ToReg => ToProcReg,
        ToMem => ToMemReg,
        mwe => mwe
    );
end func0;

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
signal tempResult : std_logic_vector(32 downto 0);
signal tempa : std_logic_vector(32 downto 0);
signal tempb : std_logic_vector(32 downto 0);
signal carry1or0 :integer;
signal c31 : std_logic;
signal c32 : std_logic;
begin
    result <= tempResult(31 downto 0);
	c31 <= tempa(31) xor tempb(31) xor tempResult(31);
    c32 <= tempResult(32);
	----c32 <= (a(31) and b(31)) or (a(31) and tempResult(31)) or (tempResult(31) and b(31));
    tempa <= a(31) & a; 
    tempb <= b(31) & b; 
	with carry select carry1or0 <=
		1 when '1',
		0 when others;
	--This one changes the result, see slides 7 and 9 of lec9....implemented slide 7 only
    with opcode select tempResult <=
        tempa and tempb when "0000", --and
        tempa xor tempb when "0001", --xor
        std_logic_vector(signed(tempa)+1+signed(not tempb)) when "0010", --sub
        std_logic_vector(signed(not tempa)+1+signed(tempb)) when "0011", --rsb
        std_logic_vector(signed(tempa)+signed(tempb)) when "0100", --add
        std_logic_vector(signed(tempa)+carry1or0+signed(tempb)) when "0101", --adc
        std_logic_vector(signed(tempa)+carry1or0+signed(not tempb)) when "0110", --sbc
        std_logic_vector(signed(not tempa)+carry1or0+signed(tempb)) when "0111", --rsc
        tempa and tempb when "1000", --tst
        tempa xor tempb when "1001", --teq
        std_logic_vector(signed(tempa)+1+signed(not tempb)) when "1010", --cmp
        std_logic_vector(signed(tempa)+signed(tempb)) when "1011", --cmn
        tempa or tempb when "1100", --orr
        tempb when "1101", --mov
        tempa and (not tempb) when "1110", --bic
        not tempb when others; --mvn

	n <= tempResult(31);
	with tempResult(31 downto 0) select z <=
        '1' when "00000000000000000000000000000000",
        '0' when others;
    c <= c32;
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

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
entity MainDataPath is
	port(
        IorD: in std_logic;
        MR: in std_logic_vector(2 downto 0);
        MW: in std_logic_vector(2 downto 0);
        IW: in std_logic;
        DW: in std_logic;
        Rsrc: in std_logic;
        M2R: in std_logic_vector(1 downto 0);
        RW: in std_logic;
        BW: in std_logic;
        AW: in std_logic;
        Asrc1: in std_logic_vector(1 downto 0);
        Asrc2: in std_logic_vector(2 downto 0);
        Fset: in std_logic;
        op: in std_logic_vector(3 downto 0);
        ReW: in std_logic;
        read1Sig: in std_logic;
        writeAddSig: in std_logic_vector(1 downto 0);            
        shiftAmtSig: in std_logic_vector(1 downto 0);
        clk: in std_logic;     
        shiftHoldSig: in std_logic;
        mulHoldSig: in std_logic;
        
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
signal shiftAmt: std_logic_vector(31 downto 0);

signal Shiftresult: std_logic_vector(31 downto 0); -- contains Shift result
signal ShiftresultHolder: std_logic_vector(31 downto 0); -- contains Shift result
signal Mulresult: std_logic_vector(31 downto 0); -- contains Multiply result
signal MulresultHolder: std_logic_vector(31 downto 0); -- contains Multiply result
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
    
    -- Memory Port Mapping. For now I have put B into Write Data. Maybe ShiftResultHolder is also a possibility.    
    Memory: entity work.MemoryModule(func0) port map(
		address => MemInputAd,
		WriteData =>  B,
		clk => clk,
		MR =>  MR,
		MW =>  MW,
		
		RD =>  MemResult
    );

    --IorD mux
    MemInputAd <= PCresult when IorD = '0' ELSE
               RESresult;

    --IR Register
    IR <= MemResult when IW = '1';

    --DR Register
    DR <= MemResult when DW = '1';

    --M2R Mux, originally 1 bit but now 2 bit, 00 when DR, 01 when RESresult, 10 when PC
    writeValReg <= DR when M2R = "00" ELSE
    		 	RESresult when M2R = "01" ELSE
    		 	PCresult;

    --Rsrc Mux
    read2 <= IR(3 downto 0) when Rsrc = '0' ELSE
    	  IR(15 downto 12);
    --other inputs to Register file
    --NEW CONTROL SIGNAL read1Sig is 0 when ins[19-16], 1 when ins[11-8]
    read1 <= IR(19 downto 16) when (read1Sig = '0') ELSE
    		 IR(11 downto 8);
    
    --NEW CONTROL SIGNAL writeAddSig is 00 when input is ins[15-12], 01 when input is 14, 10 when input is 15  
    writeReg <= IR(15 downto 12) when writeAddSig = "00" ELSE
    			"1110" when writeAddSig = "01" ELSE    --for LR
    			IR(19 downto 16) when writeAddSig = "10" ELSE --for mul
    			"1111";  --for PC
    --Register File (RF)
    RFile: entity work.RegisterFile(func4) port map(
        a => writeValReg,
        r1 => read1,
        r2 => read2,
        w1 => writeReg,
        clk => clk,
        reset => resetReg,
        we => RW,
        pc => PCresult,
        o1 => read1RegVal,
        o2 => read2RegVal 
    );

    

    --EX : THIS IS THE SHIFTED CONSTANT
    EXResult <= "00000000000000000000"&IR(11 downto 0);
    
    --S2
    S2Result <= IR(23)&IR(23)&IR(23)&IR(23)&IR(23)&IR(23)&IR(23 downto 0)&"00";
    
    --A Register
    A <= read1RegVal when AW = '1';
    --B Register
    B <= read2RegVal when BW = '1';
    
    Mul: entity work.multiplier(func3) port map(
        a => A,
        b => B,
        c => Mulresult
    );

    --NEW CONTROL SIGNAL, which tells when to hold the value of mulResult
    MulresultHolder <= MulResult when mulHoldSig = '1';
    --NEW CONTROL SIGNAL shiftAmtSig is 00 when read1, 01 when EXresult, 10 when no shift
    shiftAmt <= A when shiftAmtSig = "0" ELSE
    		 EXResult;
    
    --Shifter NEW CONTROL SIGNAL shiftTypeSig
    Shifter: entity work.shifter(func2) port map(
        a => B,
        opcode => IR(6 downto 5),
        shiftAmount => shiftAmt,
        carryIn => carry,
        
        result => Shiftresult,
        c => flagstemp(1)
    );
    --NEW CONTROL SIGNAL, which tells when to hold the value of shiftResult
    ShiftresultHolder <= shiftResult when shiftHoldSig = '1';

    --Asrc1 mux NEW CONTROL SIGNAL 00 PCresult, 01 A, 10 MulResult
    ALUInputA <= PCresult when Asrc1 = "00" ELSE
    		  A when Asrc1 = "01" ELSE
    		  MulresultHolder ;
    --Asrc2 mux NEW CONTROL SIGNAL Shiftresult when 000, 4 when 001, ExResult when 010, S2Result 011, 0 when others
    ALUInputB <= ShiftresultHolder when Asrc2 = "000" ELSE
    			 "00000000000000000000000000000100" when Asrc2 = "001" ELSE
    			 EXResult when Asrc2 = "010" ELSE
    			 S2Result when Asrc2= "011" ELSE
                 "00000000000000000000000000000000" when Asrc2= "100" ELSE
    			 B;
   
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

