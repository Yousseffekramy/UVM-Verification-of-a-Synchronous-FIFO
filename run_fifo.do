vlib work

vlog -f src_files.list +cover -covercells

vsim -voptargs=+acc work.top -cover -classdebug -uvmcontrol=all 

run 0

add wave /top/fifo_if/*

add wave -position insertpoint \
sim:/@fifo_scoreboard@1.data_out_GM \
sim:/@fifo_scoreboard@1.wr_ack_GM \
sim:/@fifo_scoreboard@1.overflow_GM \
sim:/@fifo_scoreboard@1.underflow_GM \
sim:/@fifo_scoreboard@1.count_sb \
sim:/@fifo_scoreboard@1.full_GM \
sim:/@fifo_scoreboard@1.empty_GM \
sim:/@fifo_scoreboard@1.almostfull_GM \
sim:/@fifo_scoreboard@1.almostempty_GM \
sim:/@fifo_scoreboard@1.error_count \
sim:/@fifo_scoreboard@1.correct_count \
sim:/top/DUT/wr_en \
sim:/top/DUT/rd_en 

coverage save FIFO.ucdb -onexit

run -all
# vcover report FIFO_tb.ucdb -details -annotate -all -output FIFO.txt