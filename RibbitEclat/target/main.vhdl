-- code generated from the following source code:
--   ../RibbitVm/fail.ecl
--   ../RibbitVm/vm.ecl
--
-- with the following command:
--
--    ./eclat ../RibbitVm/fail.ecl ../RibbitVm/vm.ecl

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.runtime.all;


entity main is
  
  port(signal clk    : in std_logic;
       signal reset  : in std_logic;
       signal run    : in std_logic;
       signal rdy    : out value(0 to 0);
       signal argument : in value(0 to 0);
       signal result : out value(0 to 0));
       
end entity;
architecture rtl of main is

  type t_state is (compute46, pause_getI47, pause_getII48, q_wait49);
  signal \state\: t_state;
  type array_value_96 is array (natural range <>) of value(0 to 95);
  signal arr43 : array_value_96(0 to 89999) := (others => (others => '0'));
  signal \$arr43_value\ : value(0 to 95);
  signal \$arr43_ptr\ : natural range 0 to 89999;
  signal \$arr43_ptr_write\ : natural range 0 to 89999;
  signal \$arr43_write\ : value(0 to 95);
  signal \$arr43_write_request\ : std_logic := '0';
  
  begin
    process (clk)
            begin
            if (rising_edge(clk)) then
                  if \$arr43_write_request\ = '1' then
                    arr43(\$arr43_ptr_write\) <= \$arr43_write\;
                  else
                   \$arr43_value\ <= arr43(\$arr43_ptr\);
                  end if;
            end if;
        end process;
    
    process(clk)
      variable \$v12\ : value(0 to 95) := (others => '0');
      variable rdy45, \$v50\, result44 : value(0 to 0) := (others => '0');
      variable \$arr43_ptr_take\ : value(0 to 0) := "0";
      
    begin
      
      if rising_edge(clk) then
        if (reset = '1') then
          default_zero(result44); default_zero(\$v12\); default_zero(\$v50\); 
          default_zero(rdy45); 
          rdy <= "1";
          rdy45 := "0";
          \state\ <= compute46;
          
        else if run = '1' then
          case \state\ is
          when pause_getI47 =>
            \state\ <= pause_getII48;
          when pause_getII48 =>
            \$arr43_ptr_take\(0) := '0';
            \$v12\ := \$arr43_value\;
            result44 := eclat_unit;
            eclat_print_string(of_string("Test"));
            
            rdy45 := eclat_true;
            \state\ <= compute46;
          when q_wait49 =>
            \$v50\ := \$arr43_ptr_take\;
            if \$v50\(0) = '1' then
              \state\ <= q_wait49;
            else
              \$arr43_ptr_take\(0) := '1';
              \$arr43_ptr\ <= 90000;
              \state\ <= pause_getI47;
            end if;
          when compute46 =>
            rdy45 := eclat_false;
            \$v50\ := \$arr43_ptr_take\;
            if \$v50\(0) = '1' then
              \state\ <= q_wait49;
            else
              \$arr43_ptr_take\(0) := '1';
              \$arr43_ptr\ <= 90000;
              \state\ <= pause_getI47;
            end if;
          end case;
          
          result <= result44;
          rdy <= rdy45;
          
        end if;
      end if;
    end if;
  end process;
end architecture;
