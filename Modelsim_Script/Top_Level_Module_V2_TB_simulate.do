######################################################################
#
# File name : Top_Level_Module_V2_TB_simulate.do
# Created on: Thu Jan 04 23:31:35 +0530 2018
#
# Auto generated by Vivado for 'behavioral' simulation
#
######################################################################

#Compile the source files
do {Top_Level_Module_V2_TB_compile.do}

vsim -voptargs="+acc" -L secureip -L xil_defaultlib -lib xil_defaultlib xil_defaultlib.Top_Level_Module_V2_TB

do {Top_Level_Module_V2_TB_wave.do}

view wave
view structure
view signals

do {Top_Level_Module_V2_TB.udo}

run 1ms




