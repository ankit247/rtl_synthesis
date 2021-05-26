## Reference
## https://www.intel.com/content/www/us/en/programmable/quartushelp/13.0/mergedProjects/tafs/tafs/tcl_pkg_sdc_ver_1.5.htm

######################################################
#######               Parameters               #######
######################################################
set PERIOD_SYS 10

######################################################
#######            Clock Definition            #######
######################################################
## i/p clock
create_clock -name clk_sys -period $PERIOD_SYS [get_ports i_ipg_clk]
## Virtual clock
create_clock -name clk_vir -period $PERIOD_VIR
## clock divider
## create_generated_clock [-h | -help] [-long_help] [-add] [-divide_by <factor>] [-duty_cycle <percent>] [-edge_shift <shift_list>] [-edges <edge_list>] [-invert] [-master_clock <clock>] [-multiply_by <factor>] [-name <clock_name>] [-offset <time>] [-phase <degrees>] -source <clock_source> [<targets>]
create_generated_clock -name slow_clk -divide_by 2 -source [get_port clk] [get_pins div_2_clk_reg/Q]


######################################################
#######             I/O Definition             #######
######################################################
## External delay is 80% of clock delay for both input and output 
for {set i 0} {$i < 32} {incr i} {
	set_input_delay -max [expr $PERIOD_SYS * 0.8] -clock clk_sys [get_ports i_ips_wdata[$i]]
}
for {set i 0} {$i < 32} {incr i} { 
	set_output_delay -max [expr $PERIOD_SYS * 0.8] -clock clk_sys [get_ports o_ips_rdata[$i]]
}

# Defines unused output ports (ports left unconnected)
for {set i 2} {$i < 4} {incr i} {
	set_unconnected rdata[$i]
}

######################################################
#######            Set Area Constraint         #######
######################################################

## Optimize Area
set_max_area 0

## Check for unconstrained timing paths
check_timing
