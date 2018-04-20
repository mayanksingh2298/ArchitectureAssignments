library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

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
entity MasterInterfaceSwitch is
    port(
        hready: in std_logic;
        hclk : in std_logic;
        enable: in std_logic;
--        hrdata : in std_logic_vector(31 downto 0);
        dataToWrite: in std_logic_vector(15 downto 0);
        haddr: out std_logic_vector(15 downto 0);
        hwrite: out std_logic;
        hsize: out std_logic_vector(2 downto 0);
        htrans: out std_logic;  -- '0' idle | '1' nonseq
        hwdata: out std_logic_vector(15 downto 0)
    );
end MasterInterfaceSwitch;
architecture masterSwitch of MasterInterfaceSwitch is
    TYPE mystate IS (idle,rdAddr,rdDat,wrAddr,wrDat);
    signal state: mystate:= idle;
begin
     process(hclk)
     begin
     	if(hclk='1' and hclk'event) then
     	case state is
     		when idle=>
     			htrans<='0';
     			if(enable='0') then --neither reading nor writing
     				state <= idle;
     			else --writing
     				state <= wrAddr;
     			end if;
--     		when rdAddr=>
--     			trans='1';
--     			hwrite = '0';
--     			--get the address which the processor has to read and save it in haddr
--     			state = rdDat;
--     		when rdDat=>
--     			trans='0';
--     			if(hready='1') then
--     				--store hrdata at its appropriate location
--     				state = idle;
--     			else
--     				state = rdDat;
--     			end if;
     		when wrAddr=>
     			htrans<='1';
		  		hwrite <= '1';
--     			--get the address/data where/which the processor has to write and save them in haddr/hwdata
--                haddr<="";
          hwdata <= dataToWrite;
     			state <= wrDat;
     		when wrDat=>
     			htrans<='0';
     			if(hready='1') then
     				--when the slave has successfully written the data in the memory
     				state <= idle;
     			else
     				state <= wrDat;
     			end if;
     		when others=>
     		     
     	end case;
     	end if;
     end process;     
end masterSwitch;

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
--use work.Global.all;
entity SlaveInterfaceLed is
    port(
        enable: in std_logic;
        haddr: in std_logic_vector(15 downto 0);
        hwrite: in std_logic;
        hsize: in std_logic_vector(2 downto 0);
        htrans: in std_logic;
        --hselx: in std_logic;
        --hready: in std_logic; --let's forget this one, shall we?
        hwdata: in std_logic_vector(15 downto 0);
        hclk : in std_logic;

        hreadyout: out std_logic;
--        hrdata: out std_logic_vector(15 downto 0);
        dataToReturn: out std_logic_vector(15 downto 0)
    );
end SlaveInterfaceLed;
architecture slaveLed of SlaveInterfaceLed is
	TYPE mystate IS (waiting,rdAddr,rd1,rd2,rd3,wrAddr,wr1,wr2,wr3);
    signal state: mystate:= waiting;
begin
	process(hclk)
	begin
		if (hclk='1' and hclk'event) then
		case state is
			when waiting=>
				if(htrans='0') then
					state<=waiting;
				else
					if(hwrite='0') then
						state<=rdAddr;
					else
						state<=wrAddr;
					end if;
				end if;
--			when rdaddr=>
--				hreadyout<='0';
--				--begin fetching from the memory using haddr
--				state=rd1;
--			when rd1=>
--				state=rd2;
--			when rd2=>
--				state=rd3;
--			when rd3=>
--				hreadyout<='1'; --assumed that by the time control reaches here, hrdata is set correctly
--				state=waiting;
			when wraddr=>
				hreadyout<='0';
				--begin writing the memory using haddr and hwdata
				state<=wr1;
			when wr1=>
				state<=wr2;
			when wr2=>
				state<=wr3;
			when wr3=>
				hreadyout<='1'; --assumed that by the time control reaches here, hwdata is set correctly
        dataToReturn<=hwdata;
				state<=waiting;
			when others=>
                                  
		end case;
		end if;
	end process;    
end slaveLed;


library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
entity mainBus is
	port(
		clk: in std_logic;
		sim: in  std_logic;
		inputSwitch: in std_logic_vector(15 downto 0);
		outputLed:out std_logic_vector(15 downto 0);
		anode         : out std_logic_vector(3 downto 0);
		cathode       : out std_logic_vector(6 downto 0)
	);
end mainBus;
architecture main of mainBus is
	signal slaveReady: std_logic:='1';
	signal slaveReadData: std_logic_vector(31 downto 0);
	signal masterWriteData: std_logic_vector(15 downto 0);
	signal masterAddress: std_logic_vector(15 downto 0);
	signal masterWriteBool: std_logic;
	signal masterSize: std_logic_vector(2 downto 0);
	signal masterTrans: std_logic:='0';
	
	signal a         : integer := 0;
	signal b         : integer := 1;
	signal c         : integer := 2;
	signal d         : integer := 3;
	signal counter   : integer  := 0;
	signal clockDisp : std_logic:= '0';
	signal tmpDispClk: std_logic:= '0';

begin
    a<=to_integer(unsigned(inputSwitch(15 downto 12)));
	b<=to_integer(unsigned(inputSwitch(11 downto 8)));
    c<=to_integer(unsigned(inputSwitch(7 downto 4)));
    d<=to_integer(unsigned(inputSwitch(3 downto 0)));

--    outputLed<=inputSwitch;

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
	clockDisp <= (tmpDispClk and not(sim)) or (clk and sim); 

	--Displaying: entity work.Display(segment) port map(
	--	int1    => a,
	--	int2    => b,
	--	int3    => c,
	--	int4    => d,
	--  	clock2  => clockDisp,
	--    anode   => anode, 
	--  	cathode => cathode
	--	);

	MasterInterfaceSwitch: entity work.MasterInterfaceSwitch(masterSwitch) port map(
--	hready: in std_logic;
--            hclk : in std_logic;
--            enable: in std_logic;
--    --        hrdata : in std_logic_vector(31 downto 0);
--            dataToWrite: in std_logic_vector(15 downto 0);
--            haddr: out std_logic_vector(15 downto 0);
--            hwrite: out std_logic;
--            hsize: out std_logic_vector(2 downto 0);
--            htrans: out std_logic;  -- '0' idle | '1' nonseq
--            hwdata: out std_logic_vector(31 downto 0)
		hready => slaveReady,
        hclk => clk,
        enable => '1',
--        hrdata => slaveReadData,
        dataToWrite => inputSwitch,
        haddr => masterAddress,
        hwrite => masterWriteBool,
        hsize => masterSize,
        htrans => masterTrans,
        hwdata => masterWriteData 
	);	
	SlaveInterfaceLed: entity work.SlaveInterfaceLed(slaveLed) port map(
--	  enable: in std_logic_vector;
--          haddr: in std_logic_vector(15 downto 0);
--          hwrite: in std_logic;
--          hsize: in std_logic_vector(2 downto 0);
--          htrans: in std_logic;
--          --hselx: in std_logic;
--          --hready: in std_logic; --let's forget this one, shall we?
--          hwdata: in std_logic_vector(31 downto 0);
--          hclk : in std_logic;
  
--          hreadyout: out std_logic;
--          --hrdata: out
--          dataToReturn: out std_logic_vector(15 downto 0)
        enable => '1',
		haddr => masterAddress,
        hwrite => masterWriteBool,
        hsize => masterSize,
        htrans => masterTrans,
        --hselx =>,
        --hready =>,
        hwdata => masterWriteData,
        hclk => clk,

        hreadyout => slaveReady,
--       --hrdata        
        datatoReturn => outputLed
	);	
end main;
