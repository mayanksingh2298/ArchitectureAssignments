library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
entity MasterController is
    port(
        clk : in std_logic
    );
end MasterController;
architecture MasterControl of MasterController is
TYPE mystate IS (InitialState,ReadMemory, ReadOpAndPcinReg, arith);
signal state : mystate := InitialState;
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
signal Memrst: std_logic

begin
--------------------------------------------------
------------------Port Mappings ------------------
--------------------------------------------------
CONTROL: entity work.MainController(MainControl) port map(
    state => state,
    IR => IR, 

    IorD => IorD,
    MR => MR,
    MW => MW,
    IW => IW,
    DW => DW,
    Rsrc => Rsrc,
    M2R => M2R,
    RW => RW,
    BW => BW,
    AW => AW,
    Asrc1 => Asrc1,
    Asrc2 = Asrc2,
    Fset => Fset, -- maybe to remove
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
    flagIr : IR(31 downto 28),

    p => predicate
);

FSM: entity work.StateController(StateFSM) port map(
    clk => clk,
    IR => IR,

    state => state
);

Data: entity work.MainDataPath(DataPath) port map(
    IorD: => IorD,
    MR: => MR,
    MW: => MW,
    IW: => IW,
    DW: => DW,
    Rsrc => Rsrc,
    M2R => M2R,
    RW => RW,
    BW => BW,
    AW => AW,
    Asrc1 => Asrc1,
    Asrc2 => Asrc2,
    Fset => Fset,
    op => op,
    ReW => ReW,
    read1Sig => read1Sig,
    writeAddSig => writeAddSig,            
    shiftAmtSig => shiftAmtSig,
    clk => clock,
    shiftHoldSig => shiftHoldSig,
    mulHoldSig => mulHoldSig,
    opShift => opShift,
    Memrst => Memrst,

    IR_out => IR,
    flags => flags

);
end MasterControl; -- MasterControl

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
entity StateController is
    port(
        clk : in std_logic;
        IR : in std_logic_vector(31 downto 0);

        state: out mystate
    );
end StateController;
architecture StateFSM of StateController is
begin
    process(clk)
    begin

    end process;
end StateFSM; -- MasterControl


library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
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
clock <= clk;
process(clk) 
begin
    if(mystate = InitialState)then
        controlState <= ReadMemory;
    elsif (mystate = ReadMemory) then
        MR <= "100";        
        IorD <= '0';
        Asrc1 <= "00";
        Asrc2 <= "001";
        op <= "0100";

        controlState <= ReadOpAndPcinReg;
    elsif (mystate = ReadOpAndPcinReg) then
        IW <= '1'; -- to close in next state
        M2R <= "10";
        ReW <= '1'; -- to close in next state
        writeAddSig <= "1111";
        read1Sig <= '0';
        Rsrc <= '0';
        RW <= '1'; -- to be switched off in next state
        if () then
            controlState <= arith;
        end if ;        
    end if;
end process;
end MainControl;

-- flags(3) = Z, flags(2) = N, flags(1) = C, flags(0) = V
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
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
        (not(z) and not(flags(2) xor flags(0))) when (flagIr = "1100") else
        not(not(z) and not(flags(2) xor flags(0))) when (flagIr = "1101") else
        '1';                
end Bctrl;

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
entity OpcodeGen is
    port(
        IR : in std_logic_vector(3 downto 0);

        op : out std_logic_vector(3 downto 0)
        opShift : out std_logic_vector(1 downto 0)
    );
end OpcodeGen;

architecture Actrl of OpcodeGen is
begin
    op <= IR(24-21);
    opShift <= IR(6 downto 5);
end Actrl;
