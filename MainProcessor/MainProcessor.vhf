library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use work.Global.all;
entity MainProcessor is
    port(
        clk : in std_logic;
        resetReg : in std_logic;
        MemResult : in std_logic_vector(31 downto 0);
        
        MemInputAd : out std_logic_vector(31 downto 0);
        B : out std_logic_vector(31 downto 0);
        MR : out std_logic_vector(2 downto 0);
        MW : out std_logic_vector(2 downto 0);
        Memrst : out std_logic;
        EnableMasterProc : out std_logic
    );
end MainProcessor;

architecture MasterProcessor of MainProcessor is
signal IR : std_logic_vector(31 downto 0);
signal flags : std_logic_vector(3 downto 0) := "0000";

signal IorD : std_logic;
signal IW : std_logic;
signal DW : std_logic;
signal Rsrc : std_logic;
signal M2R : std_logic_vector(1 downto 0);
signal RW : std_logic;
signal BW : std_logic;
signal AW : std_logic;
signal Asrc1 : std_logic_vector(1 downto 0);
signal Asrc2 : std_logic_vector(2 downto 0);
signal Fset : std_logic;
signal op : std_logic_vector(3 downto 0);
signal ReW : std_logic;
signal read1Sig : std_logic;
signal writeAddSig : std_logic_vector(1 downto 0);            
signal shiftAmtSig : std_logic;
signal shiftHoldSig : std_logic;
signal mulHoldSig : std_logic;
signal opShift : std_logic_vector(1 downto 0);
signal MRTemp : std_logic_vector(2 downto 0);
signal MWTemp : std_logic_vector(2 downto 0);

begin
MR <= MRTemp;
MW <= MWTemp;
enableMasterProc <= '1' when ((MRTemp /= "000") and (MWTemp /= "000")) else '0';
--------------------------------------------------
------------------Port Mappings ------------------
--------------------------------------------------
CONTROL: entity work.MasterController(MasterControl) port map(
    clk => clk,
    IR => IR,
    flags => flags,

    IorD => IorD, 
    MR => MRTemp,
    MW => MWTemp,
    IW => IW, 
    DW => DW, 
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
    shiftHoldSig => shiftHoldSig, 
    mulHoldSig => mulHoldSig, 
    opShift => opShift,
    Memrst => Memrst
);

Data: entity work.MainDataPath(DataPath) port map(
    IorD => IorD,
    IW => IW,
    DW => DW,
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
    clk => clk,
    shiftHoldSig => shiftHoldSig,
    mulHoldSig => mulHoldSig,
    opShift => opShift,
    resetReg => resetReg,
    
    IR_out => IR,
    flags => flags,
    
    MemResult => MemResult,
    BOut => B,
    MemInputAd => MemInputAd
);

--Memory: entity work.MemoryModule(func0) port map(
--    address => MemInputAd,
--    WriteData =>  B,
--    clk => clk,
--    MR =>  MR,
--    MW =>  MW,
--    rst => Memrst,
    
--    RD =>  MemResult
--);

end MasterProcessor;
