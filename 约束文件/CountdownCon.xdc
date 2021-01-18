##debug use
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets En]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets CP]
##clock
set_property PACKAGE_PIN R1 [get_ports CP]
set_property IOSTANDARD LVCMOS33 [get_ports CP]
set_property PACKAGE_PIN N4 [get_ports En]
set_property IOSTANDARD LVCMOS33 [get_ports En]
##output
set_property PACKAGE_PIN F6 [get_ports state[2]]
set_property IOSTANDARD LVCMOS33 [get_ports state[2]]
set_property PACKAGE_PIN G4 [get_ports state[1]]
set_property IOSTANDARD LVCMOS33 [get_ports state[1]]
set_property PACKAGE_PIN G3 [get_ports state[0]]
set_property IOSTANDARD LVCMOS33 [get_ports state[0]]
set_property PACKAGE_PIN J4 [get_ports t_up]
set_property IOSTANDARD LVCMOS33 [get_ports t_up]