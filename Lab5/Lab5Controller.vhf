package Global is 
    TYPE mystate IS (InitialState, fetch, rdAB, Branch, BranchRf, rdMul, multiply, MulAc, mulAcRd, MulWaste, Shift, shiftRegRd, shiftReg, shiftRead, NoneState1, NoneState2, arith , wrF, WriteMem, ReadMem, post2, Post1, M2RF, LRW);
end Global;

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use work.Global.all;
entity StateController is
    port(
        clk : in std_logic;
        IR : in std_logic_vector(31 downto 0);
        Currstate: in mystate;

        state: out mystate
    );
end StateController;
architecture StateFSM of StateController is
begin
    process(clk)
    begin
        if (clk = '1' and clk'EVENT) then
            if (Currstate = InitialState) then
                state <= fetch;         
                -- IR = mem(PC)
                -- Pc = Pc+4
            elsif (Currstate = fetch) then
                state <= rdAB;
                -- A = IR(19-16)
                -- B = IR(3-0)
            elsif (Currstate = rdAB) then
                if (SomeCondition) then
                    state <= shiftRegRd;
                    -- A = IR(11-8)
                elsif (SomeCondition) then
                    state <= Shift;
                    -- perform shift on B with IR or 
                elsif (SomeCondition) then
                    state <= rdMul;
                    -- read A = IR(11-8)
                elsif (SomeCondition) then
                    state <= NoneState1;
                    -- just a common state to partition states
                elsif (IR(27 downto 26) = "10") then
                    state <= Branch;
                    -- do pc + s2
                elsif (SomeCondition) then
                    state <= LRW;
                end if ;
            elsif (Currstate = Branch) then
                    state <= BranchRf;
                    -- store pc in rf                    
                end if ;
            elsif (Currstate = LRW) then
                    state <= Branch;
            elsif ((Currstate = BranchRf) or (Currstate = wrF) or (Currstate = M2RF) or (Currstate = Post1)) then
                state <= InitialState;
                -- do nithing but unconditionally proceed to fetch or maybe check terminating condition of program
            elsif (Currstate = rdMul) then
                state <= multiply;
                -- multiply B and A
            elsif (Currstate = mulAcRd) then
                state <= MulAc;
                -- add multiply result to new fetched value
            elsif (Currstate = multiply) then
                if (IR(24 downto 21) = "0001") then
                    state <= mulAcRd;
                    -- read B = IR(19-16)
                elsif (IR(24 downto 21) = "0000") then
                    state <= MulWaste; 
                    -- To add 0 to multiply answer. Basically a waste cycle to bring it equivalent to MLA op                                                      
                end if;
            elsif ((Currstate = MulAc) or (Currstate = MulWaste)) then
                    state <= wrF;
                    -- write in reg file
            elsif ((Currstate = Shift) or (Currstate = shiftRead)) then
                    state <= NoneState1;
                    -- just some conditions to partition state diagram
            elsif (Currstate = shiftRegRd) then
                    state <= shiftReg;
                    -- perform shifting with B and A
            elsif (Currstate = shiftReg) then
                    state <= shiftRead;
                    -- read 1st operand A = IR(19-16)
            elsif (Currstate = NoneState1) then
                state <= arith;
                -- perform arith for dp 
                -- calc offset for pre addressing
                -- for post addressing just add 0 in A so to give alu result in address in next cycle
            elsif (Currstate = arith) then
                state <= NoneState2;   
                -- another empty state                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
            elsif (Currstate = NoneState2) then
                if (SomeCondition) then
                    state <= WriteMem;
                    -- write in mem
                elsif (SomeCondition) then
                    state <= ReadMem;
                    -- read from mem
                elsif (SomeCondition) then
                    state <= wrF;
                    -- write in reg file
                end if ;    
            elsif (Currstate = WriteMem) then
                if (IR(24) = '1') then
                    state <= Post1;
                    --ALU operation of calculating new offset
                else state <= InitialState;
                end if ;
            elsif (Currstate = ReadMem) then
                if (IR(24) = '1') then
                    state <= post2;
                    -- Alu to calc new value of address to be stored in reg file
                else state <= M2RF;
                    -- store in reg file
                end if ;
            elsif (Currstate = post2) then
                state <= M2RF;
                -- store in reg file
            end if;
        end if;
    end process;
end StateFSM; -- MasterControl


library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use work.Global.all;
entity MainController is
    port(
        state : in mystate;
        IR : in std_logic_vector(31 downto 0); 

        IorD: out std_logic;
        MR: out std_logic_vector(2 downto 0);
        MW: out std_logic_vector(2 downto 0);
        IW: out std_logic;
        DW: out std_logic;
        Rsrc: out std_logic;
        M2R: out std_logic_vector(1 downto 0);
        RW: out std_logic;
        BW: out std_logic;
        AW: out std_logic;
        Asrc1: out std_logic_vector(1 downto 0);
        Asrc2: out std_logic_vector(2 downto 0);
        Fset: out std_logic;
        ReW: out std_logic;
        read1Sig: out std_logic;
        writeAddSig: out std_logic_vector(1 downto 0);            
        shiftAmtSig: out std_logic_vector(1 downto 0);
        shiftHoldSig: out std_logic;
        mulHoldSig: out std_logic;
        Memrst: out std_logic
    );
end MainController;

architecture MainControl of MainController is
begin
--    if(mystate = InitialState)then
--        controlState <= ReadMem;
--    elsif (mystate = ReadMem) then
--        MR <= "100";        
--        IorD <= '0';
--        Asrc1 <= "00";
--        Asrc2 <= "001";
--        op <= "0100";

--        controlState <= ReadOpAndPcinReg;
--    elsif (mystate = ReadOpAndPcinReg) then
--        IW <= '1'; -- to close in next state
--        M2R <= "10";
--        ReW <= '1'; -- to close in next state
--        writeAddSig <= "1111";
--        read1Sig <= '0';
--        Rsrc <= '0';
--        RW <= '1'; -- to be switched off in next state
--        if () then
--            controlState <= arith;
--        end if ;        
--    end if;
end MainControl;

-- flags(3) = Z, flags(2) = N, flags(1) = C, flags(0) = V
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use work.Global.all;
entity FlagCtrl is
    port(
        flags : in std_logic_vector(3 downto 0);
        flagIr : in std_logic_vector(3 downto 0);

        p : out std_logic
    );
end FlagCtrl;

architecture Bctrl of FlagCtrl is
begin
    p <= flags(3) when (flagIr = "0000") else
        not(flags(3)) when (flagIr = "0001") else
        flags(1) when (flagIr = "0010") else
        not(flags(1)) when (flagIr = "0011") else
        flags(2) when (flagIr = "0100") else
        not(flags(2)) when (flagIr = "0101") else
        flags(0) when (flagIr = "0110") else
        not(flags(0)) when (flagIr = "0111") else
        (flags(1) and not(flags(3))) when (flagIr = "1000") else
        not(flags(1) and not(flags(3))) when (flagIr = "1001") else
        not(flags(2) xor flags(0)) when (flagIr = "1010") else
        (flags(2) xor flags(0)) when (flagIr = "1011") else
        (not(flags(3)) and not(flags(2) xor flags(0))) when (flagIr = "1100") else
        not(not(flags(3)) and not(flags(2) xor flags(0))) when (flagIr = "1101") else
        '1';                
end Bctrl;

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use work.Global.all;
entity OpcodeGen is
    port(
        IR : in std_logic_vector(3 downto 0);

        op : out std_logic_vector(3 downto 0);
        opShift : out std_logic_vector(1 downto 0)
    );
end OpcodeGen;

architecture Actrl of OpcodeGen is
begin
    op <= IR(24 downto 21);
    opShift <= IR(6 downto 5);
end Actrl;

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use work.Global.all;
entity MasterController is
    port(
        clk : in std_logic
    );
end MasterController;
architecture MasterControl of MasterController is
signal Currstate : mystate := InitialState;
signal Nextstate : mystate := InitialState;
signal IR : std_logic_vector(31 downto 0);
signal flags : std_logic_vector(3 downto 0);
signal predicate : std_logic;

signal IorD: std_logic;
signal MR: std_logic_vector(2 downto 0);
signal MW: std_logic_vector(2 downto 0);
signal IW: std_logic;
signal DW: std_logic;
signal Rsrc: std_logic;
signal M2R: std_logic_vector(1 downto 0);
signal RW: std_logic;
signal BW: std_logic;
signal AW: std_logic;
signal Asrc1: std_logic_vector(1 downto 0);
signal Asrc2: std_logic_vector(2 downto 0);
signal op: std_logic_vector(3 downto 0);
signal opShift: std_logic_vector(1 downto 0);
signal Fset: std_logic;
signal ReW: std_logic;
signal read1Sig: std_logic;
signal writeAddSig: std_logic_vector(1 downto 0);            
signal shiftAmtSig: std_logic_vector(1 downto 0);
signal shiftHoldSig: std_logic;
signal mulHoldSig: std_logic;
signal Memrst: std_logic;

signal FsetTemp: std_logic;
signal RWTemp: std_logic;
signal MWTemp: std_logic_vector(2 downto 0);
--signal predicate: std_logic;

begin

Fset <= predicate and FsetTemp;
RW <= predicate and RWTemp;
MW <= MWTemp when (predicate = '1') else "000";
Currstate <= Nextstate;
--PW <= p and PWTemp;
--------------------------------------------------
------------------Port Mappings ------------------
--------------------------------------------------
CONTROL: entity work.MainController(MainControl) port map(
    state => Currstate,
    IR => IR, 

    IorD => IorD,
    MR => MR,
    MW => MWTemp,
    IW => IW,
    DW => DW,
    Rsrc => Rsrc,
    M2R => M2R,
    RW => RWTemp,
    BW => BW,
    AW => AW,
    Asrc1 => Asrc1,
    Asrc2 => Asrc2,
    Fset => FsetTemp, -- maybe to remove
    ReW => ReW,
    read1Sig => read1Sig,
    writeAddSig => writeAddSig,            
    shiftAmtSig => shiftAmtSig,
    shiftHoldSig => shiftHoldSig,
    mulHoldSig => mulHoldSig,
    Memrst => Memrst
);

OPCODESET: entity work.OpcodeGen(Actrl) port map(
    IR => IR,

    op => op,
    opShift => opShift
);

FLAGSET: entity work.FlagCtrl(Bctrl) port map(
    flags => flags,
    flagIr => IR(31 downto 28),

    p => predicate
);

FSM: entity work.StateController(StateFSM) port map(
    clk => clk,
    IR => IR,
    Currstate => Currstate,

    state => Nextstate
);

Data: entity work.MainDataPath(DataPath) port map(
    IorD => IorD,
    MR => MR,
    MW => MWTemp,
    IW => IW,
    DW => DW,
    Rsrc => Rsrc,
    M2R => M2R,
    RW => RWTemp,
    BW => BW,
    AW => AW,
    Asrc1 => Asrc1,
    Asrc2 => Asrc2,
    Fset => FsetTemp,
    op => op,
    ReW => ReW,
    read1Sig => read1Sig,
    writeAddSig => writeAddSig,            
    shiftAmtSig => shiftAmtSig,
    clk => clk,
    shiftHoldSig => shiftHoldSig,
    mulHoldSig => mulHoldSig,
    opShift => opShift,
    Memrst => Memrst,

    IR_out => IR,
    flags => flags

);
end MasterControl; -- MasterControl
