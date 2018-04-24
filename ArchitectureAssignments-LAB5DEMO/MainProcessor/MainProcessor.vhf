library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;
entity Display is
  port(   int1 : in integer;
          int2 : in integer;
          int3 : in integer;
          int4 : in integer;
          clock2 : in std_logic;
          anode : out std_logic_vector (3 downto 0);  
          cathode : out std_logic_vector (6 downto 0)
);
end Display;

architecture segment of Display is
Signal counter3 : integer := 0;
Signal tempanode : std_logic_vector (3 downto 0);
signal reg_sm1 : std_logic_vector(3 downto 0) := "0000";
signal reg_sm2 : std_logic_vector(3 downto 0) := "0000";
signal reg_sm3 : std_logic_vector(3 downto 0) := "0000";
signal reg_sm4 : std_logic_vector(3 downto 0) := "0000";
signal reg_a : std_logic_vector(7 downto 0) := "00000000";
signal reg_b : std_logic_vector(7 downto 0) := "00000000";
begin
reg_sm1 <= std_logic_vector(to_unsigned(int1, reg_sm1'length));
reg_sm2 <= std_logic_vector(to_unsigned(int2, reg_sm2'length));
reg_sm3 <= std_logic_vector(to_unsigned(int3, reg_sm3'length));
reg_sm4 <= std_logic_vector(to_unsigned(int4, reg_sm4'length));

process(clock2)
  begin
  if (clock2 = '1' and clock2'EVENT) then
      if(counter3 mod 4 = 0) then 
        anode <= "0111";
        if(reg_sm1(3 downto 0) = "0000") then
            cathode <= "1000000";
        elsif(reg_sm1(3 downto 0) = "0001") then
            cathode <= "1111001";
        elsif(reg_sm1(3 downto 0) = "0010") then
            cathode <= "0100100"; 
        elsif(reg_sm1(3 downto 0) = "0011")then 
            cathode <= "0110000";
        elsif(reg_sm1(3 downto 0) = "0100")then 
            cathode <= "0011001";
        elsif(reg_sm1(3 downto 0) = "0101")then 
            cathode <= "0010010";
        elsif(reg_sm1(3 downto 0) = "0110")then 
            cathode <= "0000010";
        elsif(reg_sm1(3 downto 0) = "0111")then 
            cathode <= "1111000";
        elsif(reg_sm1(3 downto 0) = "1000")then 
            cathode <= "0000000";
        elsif(reg_sm1(3 downto 0) = "1001")then 
            cathode <= "0010000";
        elsif(reg_sm1(3 downto 0) = "1010")then 
            cathode <= "0001000";
        elsif(reg_sm1(3 downto 0) = "1011")then 
            cathode <= "0000011";
        elsif(reg_sm1(3 downto 0) = "1100")then 
            cathode <= "1000110";
        elsif(reg_sm1(3 downto 0) = "1101")then 
            cathode <= "0100001";
        elsif(reg_sm1(3 downto 0) = "1110")then 
            cathode <= "0000110";
        elsif(reg_sm1(3 downto 0) = "1111")then 
            cathode <= "0001110";
        else 
            cathode <= "0010000";
        end if;      
      elsif(counter3 mod 4 = 1) then
        anode <= "1011";
        if(reg_sm2(3 downto 0) = "0000") then
            cathode <= "1000000";
        elsif(reg_sm2(3 downto 0) = "0001") then
            cathode <= "1111001";
        elsif(reg_sm2(3 downto 0) = "0010") then
            cathode <= "0100100"; 
        elsif(reg_sm2(3 downto 0) = "0011")then 
            cathode <= "0110000";
        elsif(reg_sm2(3 downto 0) = "0100")then 
            cathode <= "0011001";
        elsif(reg_sm2(3 downto 0) = "0101")then 
            cathode <= "0010010";
        elsif(reg_sm2(3 downto 0) = "0110")then 
            cathode <= "0000010";
        elsif(reg_sm2(3 downto 0) = "0111")then 
            cathode <= "1111000";
        elsif(reg_sm2(3 downto 0) = "1000")then 
            cathode <= "0000000";
        elsif(reg_sm2(3 downto 0) = "1001")then 
            cathode <= "0010000";
        elsif(reg_sm2(3 downto 0) = "1010")then 
            cathode <= "0001000";
        elsif(reg_sm2(3 downto 0) = "1011")then 
            cathode <= "0000011";
        elsif(reg_sm2(3 downto 0) = "1100")then 
            cathode <= "1000110";
        elsif(reg_sm2(3 downto 0) = "1101")then 
            cathode <= "0100001";
        elsif(reg_sm2(3 downto 0) = "1110")then 
            cathode <= "0000110";
        elsif(reg_sm2(3 downto 0) = "1111")then 
            cathode <= "0001110";
        else 
            cathode <= "0010000";
        end if;
      elsif(counter3 mod 4 = 2) then
          anode <= "1101";
        if(reg_sm3(3 downto 0) = "0000") then
            cathode <= "1000000";
        elsif(reg_sm3(3 downto 0) = "0001") then
            cathode <= "1111001";
        elsif(reg_sm3(3 downto 0) = "0010") then
            cathode <= "0100100"; 
        elsif(reg_sm3(3 downto 0) = "0011")then 
            cathode <= "0110000";
        elsif(reg_sm3(3 downto 0) = "0100")then 
            cathode <= "0011001";
        elsif(reg_sm3(3 downto 0) = "0101")then 
            cathode <= "0010010";
        elsif(reg_sm3(3 downto 0) = "0110")then 
            cathode <= "0000010";
        elsif(reg_sm3(3 downto 0) = "0111")then 
            cathode <= "1111000";
        elsif(reg_sm3(3 downto 0) = "1000")then 
            cathode <= "0000000";
        elsif(reg_sm3(3 downto 0) = "1001")then 
            cathode <= "0010000";
        elsif(reg_sm3(3 downto 0) = "1010")then 
            cathode <= "0001000";
        elsif(reg_sm3(3 downto 0) = "1011")then 
            cathode <= "0000011";
        elsif(reg_sm3(3 downto 0) = "1100")then 
            cathode <= "1000110";
        elsif(reg_sm3(3 downto 0) = "1101")then 
            cathode <= "0100001";
        elsif(reg_sm3(3 downto 0) = "1110")then 
            cathode <= "0000110";
        elsif(reg_sm3(3 downto 0) = "1111")then 
            cathode <= "0001110";
        else 
            cathode <= "0010000";
        end if;
      elsif(counter3 mod 4 = 3) then 
          anode <= "1110";  
        if(reg_sm4(3 downto 0) = "0000") then
            cathode <= "1000000";
        elsif(reg_sm4(3 downto 0) = "0001") then
            cathode <= "1111001";
        elsif(reg_sm4(3 downto 0) = "0010") then
            cathode <= "0100100"; 
        elsif(reg_sm4(3 downto 0) = "0011")then 
            cathode <= "0110000";
        elsif(reg_sm4(3 downto 0) = "0100")then 
            cathode <= "0011001";
        elsif(reg_sm4(3 downto 0) = "0101")then 
            cathode <= "0010010";
        elsif(reg_sm4(3 downto 0) = "0110")then 
            cathode <= "0000010";
        elsif(reg_sm4(3 downto 0) = "0111")then 
            cathode <= "1111000";
        elsif(reg_sm4(3 downto 0) = "1000")then 
            cathode <= "0000000";
        elsif(reg_sm4(3 downto 0) = "1001")then 
            cathode <= "0010000";
        elsif(reg_sm4(3 downto 0) = "1010")then 
            cathode <= "0001000";
        elsif(reg_sm4(3 downto 0) = "1011")then 
            cathode <= "0000011";
        elsif(reg_sm4(3 downto 0) = "1100")then 
            cathode <= "1000110";
        elsif(reg_sm4(3 downto 0) = "1101")then 
            cathode <= "0100001";
        elsif(reg_sm4(3 downto 0) = "1110")then 
            cathode <= "0000110";
        elsif(reg_sm4(3 downto 0) = "1111")then 
            cathode <= "0001110";
        else 
            cathode <= "0010000";
        end if;
      end if;
    counter3 <= counter3 + 1;
  end if;
  end process;
end segment;
----------------------TILL HERE----------------- is the code for SSD
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use work.Global.all;
entity MainProcessor is
    port(
        clk : in std_logic;
        resetReg : in std_logic;
        switch : in std_logic_vector(3 downto 0);
        push : in std_logic;
        anode  : out std_logic_vector(3 downto 0);
        cathode : out std_logic_vector(6 downto 0)
    );
end MainProcessor;

architecture MasterProcessor of MainProcessor is
signal IR : std_logic_vector(31 downto 0);
signal flags : std_logic_vector(3 downto 0) := "0000";

signal IorD : std_logic;
signal MR : std_logic_vector(2 downto 0);
signal MW : std_logic_vector(2 downto 0);
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
signal Memrst : std_logic;

signal B : std_logic_vector(31 downto 0);
signal MemInputAd : std_logic_vector(31 downto 0);
signal MemResult : std_logic_vector(31 downto 0);
signal timepass : std_logic:='0';
signal tmpToSHow : std_logic_vector(31 downto 0):="00000000000000000000000000001111";

signal a         : integer := 0;
signal ba         : integer := 1;
signal c         : integer := 2;
signal d         : integer := 3;
signal counter   : integer  := 0;
signal clockDisp : std_logic:= '0';
signal tmpDispClk: std_logic:= '0';


begin
--------------------------------------------------
------------------Port Mappings ------------------
--------------------------------------------------
a<=to_integer(unsigned(tmptoShow(15 downto 12)));
ba<=to_integer(unsigned(tmptoShow(11 downto 8)));
c<=to_integer(unsigned(tmpToShow(7 downto 4)));
d<=to_integer(unsigned(tmpToSHow(3 downto 0)));
--a<=1 when switch(3) = '1' ELSE 0;
--ba<=1 when switch(2) = '1' ELSE 0;
--c<=1 when switch(1) = '1' ELSE 0;
--d<=1 when switch(0) = '1' ELSE 0;
timepass <= push;
process(clk)
  begin
    if (clk = '1' and clk'EVENT) then
      if (counter mod 100000 = 0) then
        tmpDispClk <= not(tmpDispClk);
        counter <= 1;
      else
        counter <= counter + 1;
      end if;
    end if;
end process;
clockDisp <= (tmpDispClk); 
	Displaying: entity work.Display(segment) port map(
    int1    => a,
    int2    => ba,
    int3    => c,
    int4    => d,
      clock2  => clockDisp,
    anode   => anode, 
      cathode => cathode
    );

CONTROL: entity work.MasterController(MasterControl) port map(
    clk => clk,
    IR => IR,
    flags => flags,

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
    Memrst => Memrst,
    resetReg => resetReg,
    
    IR_out => IR,
    flags => flags,
    
    MemResult => MemResult,
    BOut => B,
    MemInputAd => MemInputAd,
    
    showInSSD => tmpToShow,
    timepass => timepass,
    SSDread => switch
);

Memory: entity work.MemoryModule(func0) port map(
    address => MemInputAd,
    WriteData =>  B,
    clk => clk,
    MR =>  MR,
    MW =>  MW,
    rst => Memrst,
    
    RD =>  MemResult
);

end MasterProcessor;
