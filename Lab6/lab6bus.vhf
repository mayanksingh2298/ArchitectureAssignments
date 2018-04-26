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
-- haddr(15 downto 14) = 00 for memory, 01 for SSD


library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
entity MasterInterfaceProc is
    port(
        hready: in std_logic;
        hclk : in std_logic;
        enable: in std_logic;
        resetReg : in std_logic;
        hrdata : in std_logic_vector(31 downto 0);
--        dataToWrite: in std_logic_vector(15 downto 0);
        haddr: out std_logic_vector(15 downto 0);
        hwrite: out std_logic;
        hsize: out std_logic_vector(2 downto 0);
        htrans: out std_logic;  -- '0' idle | '1' nonseq
        hwdata: out std_logic_vector(31 downto 0);
        resetMem: out std_logic;
        
        push: in std_logic;
        ssdout: out std_logic_vector(31 downto 0)
    );
end MasterInterfaceProc;
architecture masterProc of MasterInterfaceProc is
    TYPE mystateProc IS (idle,rdAddr,rdDat,wrAddr,wrDat);
    signal state: mystateProc:= idle;
    signal tempMR: std_logic_vector(2 downto 0) := "000";
    signal tempMW: std_logic_vector(2 downto 0) := "000";
    signal haddrTemp: std_logic_vector(31 downto 0);
    signal dataToWrite: std_logic_vector(31 downto 0);
    signal start2: std_logic := '0';
    signal masterClkProc: std_logic:='0'; 
    signal dataout: std_logic_vector(31 downto 0);
    signal tempclk: std_logic;
begin
--     masterClkProc <= '0' when(hready = '0') else hclk;
--     masterClkProc <= hclk when((start2 = '1') and hready = '1') else '0';
--     tempclk <= hclk when ((enable or start2) = '0') else '0';
    
--    tempClk <= '0' when ((enable or start2) = '1') else hclk; 
--    masterClkproc <= tempClk when ()
--     when (hready = '0') else hclk;
--     hwdata <= dataout;
    masterClkProc <= '0' when (tempClk = '1') else hclk;
     process(hclk)
     begin
     	if(hclk='1' and hclk'event) then
     	case state is
     		when idle=>
     			htrans<='0';
     			if((enable or start2)='0') then --neither reading nor writing
     				state <= idle;
     			elsif(tempMR /= "000") then
                    htrans <= '1';
     			    tempClk <= '1';
     			    state <= rdAddr;
                    hwrite <= '0';
     			elsif(tempMW /= "000") then  --writing
                    htrans <= '1';
     				state <= wrAddr;
     				tempClk <= '1';
     				hwrite <= '1';
     			else
     			    state <= idle;
     			end if;
     		when rdAddr=>
                haddr <=  "00" & haddrTemp(13 downto 0);
     			htrans <= '0';
--     			hwrite <= '0';
     			--get the address which the processor has to read and save it in haddr
     			state <= rdDat;
     		when rdDat=>
				 if(tempMR = "101") then
                     hsize <= "000"; --ldrb
                 elsif(tempMR = "001") then
                     hsize <= "100"; -- ldrb signed
                 elsif(tempMR = "010") then
                     hsize <= "001";
                 elsif(tempMR = "011") then
                     hsize <= "101";
                 elsif(tempMR = "100") then
                     hsize <= "010";
                 else
                     hsize <= "111"; -- disable memory
                 end if;

     			if(hready='1') then
     				--store hrdata at its appropriate location
--                    htrans<='0';
                    dataout <= hrdata;
                    tempClk <= '0';
     				state <= idle;
     			else
     				state <= rdDat;
     			end if;
     		when wrAddr=>
                haddr <=  "00" & haddrTemp(13 downto 0);
     			htrans<='0';
--		  		hwrite <= '1';
--     			--get the address/data where/which the processor has to write and save them in haddr/hwdata
          		hwdata <= dataToWrite;
     			state <= wrDat;
     		when wrDat=>
                 if(tempMW = "001") then
                     hsize <= "000"; --strb
                 elsif(tempMW = "010") then
                     hsize <= "001"; --strhw
                 elsif(tempMW = "011") then
                     hsize <= "010";
                 else
                     hsize <= "111"; -- disable memory
                 end if;

     			if(hready='1') then
--         			htrans<='0';
         			hwrite <= '0';
     			    tempClk <= '0';
     				--when the slave has successfully written the data in the memory
     				state <= idle;
     			else
     				state <= wrDat;
     			end if;
     		when others=>
     		     
     	end case;
     	end if;
     end process; 
     
Processor: entity work.MainProcessor(MasterProcessor) port map(
        clk => masterClkProc,
        resetReg => resetReg,
        MemResult => dataout,
        
        MemInputAd => haddrTemp,
        B => dataToWrite,
        MR => tempMR,
        MW => tempMW,
        Memrst => resetMem,
        enableMasterProc => start2,
        
        push => push,
        ssdout => ssdout
     );         
end masterProc;


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
    TYPE mystateSwitch IS (idle,wrAddr,wrDat);
    signal state: mystateSwitch:= idle;
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
    		  		hwrite <= '1';
     			    htrans <= '1';
     				state <= wrAddr;
     			end if;
     		when wrAddr=>
     			htrans<='0';
--		  		hwrite <= '1';
--     			--get the address/data where/which the processor has to write and save them in haddr/hwdata
                haddr<= std_logic_vector(to_unsigned(4000, 16));
          		hwdata <= dataToWrite;
          		hsize <= ("010");
     			state <= wrDat;
     		when wrDat=>
--     			htrans<='0';
     			if(hready='1') then
     			    hwrite <= '0';
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
    				hreadyout<='0';
					if(hwrite='0') then
						state<=rdAddr;
					else
						state<=wrAddr;
					end if;
				end if;
			when wraddr=>
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
--use work.Global.all;
entity SlaveInterfaceSSD is
    port(
        enable: in std_logic;
        htrans: in std_logic;
        hwdata: in std_logic_vector(15 downto 0);
        hclk : in std_logic;

        hreadyout: out std_logic;
        anode: out std_logic_vector(3 downto 0);
        cathode: out std_logic_vector(6 downto 0)
    );
end SlaveInterfaceSSD;
architecture slaveSSD of SlaveInterfaceSSD is
	TYPE mystateSSD IS (waiting,rdAddr,rd1,rd2,rd3,wrAddr,wr1,wr2,wr3);
    signal state: mystateSSD:= waiting;
    signal a         : integer := 0;
    signal b         : integer := 0;
    signal c         : integer := 0;
    signal d         : integer := 0;
--    signal anodeTemp : std_logic_vector(3 downto 0);
--    signal cathodeTemp : std_logic_vector(6 downto 0);
begin

	process(hclk)
	begin
		if (hclk='1' and hclk'event) then
		case state is
			when waiting=>
				if(htrans='0') then
					state <= waiting;
				else
                    hreadyout<='0';
                    state <= wrAddr;
				end if;
			when wraddr=>
                a<=to_integer(unsigned(hwdata(15 downto 12)));
                b<=to_integer(unsigned(hwdata(11 downto 8)));
                c<=to_integer(unsigned(hwdata(7 downto 4)));
                d<=to_integer(unsigned(hwdata(3 downto 0)));
				state<=wr1;
			when wr1=>
				state<=wr2;
			when wr2=>
				state<=wr3;
			when wr3=>
				hreadyout<='1'; --assumed that by the time control reaches here, hwdata is set correctly
        		state<=waiting;
			when others=>
                                  
		end case;
		end if;
	end process; 
    
    Displaying: entity work.Display(segment) port map(
        int1    => a,
        int2    => b,
        int3    => c,
        int4    => d,
        clock2  => hclk,
        anode   => anode, 
        cathode => cathode
    );   
end slaveSSD;


library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity SlaveInterfaceMemory is
    port(
        haddr: in std_logic_vector(15 downto 0);
        hwrite: in std_logic;
        hsize: in std_logic_vector(2 downto 0);
        htrans: in std_logic;
        hreset: in std_logic;
        hwdata: in std_logic_vector(31 downto 0);
        hclk : in std_logic;

        hreadyout: out std_logic;
        dataToReturn: out std_logic_vector(31 downto 0)
    );
end SlaveInterfaceMemory;
architecture slaveMemory of SlaveInterfaceMemory is
	TYPE mystateMem IS (waiting,rdAddr,rd1,rd2,rd3,wrAddr,wr1,wr2,wr3);
    signal state: mystateMem:= waiting;
    signal MemInputAd: std_logic_vector(31 downto 0);
    signal MW: std_logic_vector(2 downto 0);
    signal MR: std_logic_vector(2 downto 0);
    signal tempHrdata: std_logic_vector(31 downto 0);
    signal tempHwdata: std_logic_vector(31 downto 0);
    signal tempDataToReturn: std_logic_vector(31 downto 0);
begin
	process(hclk)
	begin
		if (hclk='1' and hclk'event) then
		case state is
			when waiting=>
				if(htrans='0') then
					state<=waiting;
				else
    				hreadyout<='0';
					if(hwrite='0') then
						state<=rdAddr;
					elsif(hwrite = '1') then
						state<=wrAddr;
					else
					   state <= waiting;	
					end if;
				end if;
			when rdaddr=>
				MemInputAd <= "000000000000000000" & haddr(13 downto 0);
				MW <= "000";
				if(hsize = "000") then
				    MR <= "101"; -- ldrb
				elsif(hsize = "100") then
				    MR <= "001"; -- ldrb signed
				elsif(hsize = "001") then
                    MR <= "010"; -- ldrhw
				elsif(hsize = "101") then
                    MR <= "011"; -- ldrhw signed                        
				elsif(hsize = "010") then
                    MR <= "100"; -- ldr
				else
				    MR <= "000"; -- disable memory
				end if;
			
				--begin fetching from the memory using haddr
				state<=rd1;
			when rd1=>
				state<=rd2;
			when rd2=>
				state<=rd3;
			when rd3=>
				hreadyout<='1'; --assumed that by the time control reaches here, hrdata is set correctly
				dataToReturn <= tempdataToReturn;
				state<=waiting;
			when wraddr=>
				hreadyout<='0';
				--begin writing the memory using haddr and hwdata
				tempHwData <= hwData;
				MemInputAd <= "000000000000000000" & haddr(13 downto 0);
                MR <= "000";
                if(hsize = "000") then
                    MW <= "001"; -- strb
                elsif(hsize = "001") then
                    MW <= "010"; -- strhw
                elsif(hsize = "010") then
                    MW <= "011"; -- str
                else
                    MW <= "000"; -- disable memory
                end if;
				state<=wr1;
			when wr1=>
				state<=wr2;
			when wr2=>
				state<=wr3;
			when wr3=>
				hreadyout<='1'; --assumed that by the time control reaches here, hwdata is set correctly
        		state<=waiting;
			when others=>
                        
		end case;
		end if;
	end process;    

Memory: entity work.MemoryModule(func0) port map(
    address => MemInputAd,
    WriteData =>  temphwdata,
    clk => hclk,
    MR =>  MR,
    MW =>  MW,
    rst => hreset,
    
    RD =>  tempdataToReturn
);

end slaveMemory;



library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
entity mainBus is
	port(
		clk : in std_logic;
		sim : in  std_logic;
		inputSwitch : in std_logic_vector(15 downto 0);
		resetReg : in std_logic;
		startProc : in std_logic;
		SwitchEnable : in std_logic;
		push : in std_logic;
		
		outputLed : out std_logic_vector(15 downto 0);
		anode         : out std_logic_vector(3 downto 0);
		cathode       : out std_logic_vector(6 downto 0)
	);
end mainBus;
architecture main of mainBus is
	
	signal slaveReady: std_logic:='1';
	signal slaveReadySSD: std_logic:='1';
	signal slaveReadData: std_logic_vector(31 downto 0);
	signal masterWriteData: std_logic_vector(15 downto 0);
	signal masterAddress: std_logic_vector(15 downto 0);
	signal masterWriteBool: std_logic;
	signal masterSize: std_logic_vector(2 downto 0);
	signal masterTrans: std_logic:='0';
	
	signal counter   : integer  := 0;
	signal clockDisp : std_logic:= '0';
	signal tmpDispClk: std_logic:= '0';

    signal memInputData : std_logic_vector (31 downto 0);
    signal memData : std_logic_vector (31 downto 0);
    signal memreset : std_logic;
    signal memtrans : std_logic;
    signal memhWrite : std_logic;
    signal memhsize : std_logic_vector (2 downto 0);
    signal memAddr : std_logic_vector (15 downto 0);
    signal memReady : std_logic;

    signal fromProcWriteData : std_logic_vector (31 downto 0);
    signal fromProcTrans : std_logic;
    signal fromProcresetMem : std_logic;
    signal fromProcWrite : std_logic;
    signal fromProcsize : std_logic_vector (2 downto 0);
    signal fromProcAddr : std_logic_vector (15 downto 0);
    signal readyForProc : std_logic;
    signal procClk : std_logic;
    signal flagStart : std_logic:= '0';
    
    signal ssdout: std_logic_vector(31 downto 0);
    signal tempStartProc : std_logic;
begin
    flagStart <= '1' when startProc = '1';
	process(clk)
	  begin
	    if (clk = '1' and clk'EVENT) then
--	      tempStartProc <= StartProc;
	      if (counter mod 100000 = 0) then
	        tmpDispClk <= not(tmpDispClk);
	        counter <= 1;
	      else
	      	counter <= counter + 1;
	      end if;
	    end if;
	end process;
	clockDisp <= (tmpDispClk and not(sim)) or (clk and sim); 
    
    Procclk <= clk when (flagStart = '1') else '0';
    
    readyForProc <= memReady; -------------------------------------------------------------------------
    ProcessorMaster: entity work.MasterInterfaceProc(masterProc) port map(
        hready => readyForProc,
        hclk => Procclk,
        enable => startProc,
        resetReg => resetReg,
        hrdata => memData,
        haddr => FromProcAddr,
        hwrite => FromProcWrite,
        hsize => fromProcSize,
        htrans => fromProctrans,  -- '0' idle | '1' nonseq
        hwdata => FromProcWriteData,
        resetMem => FromProcResetMem,
        
        push => push,
        ssdout => ssdout
    );
    
    memInputData <= ("0000000000000000"&masterWriteData) when (flagStart = '0' or masterTrans = '1') else FromProcWriteData;
    memHWrite <= masterWriteBool when (flagStart = '0' or masterTrans = '1') else FromProcWrite;
    memHSize <= masterSize when (flagStart = '0' or masterTrans = '1') else FromProcSize;
    memTrans <= masterTrans when (flagStart = '0' or masterTrans = '1') else FromProcTrans;
    memreset <= '0' when (flagStart = '0' or masterTrans = '1') else FromProcResetMem;
    memAddr <= masterAddress when (flagStart = '0' or masterTrans = '1') else FromProcAddr;
 
    MemorySlave: entity work.SlaveInterfaceMemory(slavememory) port map(
        haddr => memAddr,
        hwrite => memHwrite,
        hsize => memHsize,
        htrans => memTrans,
        hreset => memReset,
        hwdata => memInputData,
        hclk => clk,
    
        hreadyout => memReady,
        dataToReturn => memData
    );

	MasterInterfaceSwitch: entity work.MasterInterfaceSwitch(masterSwitch) port map(
		hready => slaveReady,
        hclk => clk,
        enable => switchEnable,
        dataToWrite => inputSwitch,
        haddr => masterAddress,
        hwrite => masterWriteBool,
        hsize => masterSize,
        htrans => masterTrans,
        hwdata => masterWriteData 
	);	
	SlaveInterfaceLed: entity work.SlaveInterfaceLed(slaveLed) port map(
        enable => '1',
		haddr => masterAddress,
        hwrite => masterWriteBool,
        hsize => masterSize,
        htrans => masterTrans,
        hwdata => masterWriteData,
        hclk => clk,
        hreadyout => slaveReady,
        datatoReturn => outputLed
	);
    
    SSDSLave: entity work.SlaveInterfaceSSD(slaveSSD) port map(
        enable => '1',
        htrans => fromProcTrans,
--        hwdata => memData(15 downto 0),
        hwdata => ssdout(15 downto 0),
        
        hclk => clockDisp,
        hreadyout => slaveReadySSD,
        anode => anode,
        cathode => cathode
    );    	
end main;
