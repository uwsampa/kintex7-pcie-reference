BOARD   := kc705


hwdir   := k7-board
sysdef  := $(hwdir)/k7-board.runs/impl_1/system_top.sysdef
hdf     := $(hwdir)/k7-board.sdk/system_top.hdf


.PHONY: all
define HELP
--------------------------------------------------------------------------------
Next steps:
--------------------------------------------------------------------------------

TODO WRITE HERE
--------------------------------------------------------------------------------
endef
export HELP

all: remake-board

program: 
	vivado -mode batch -source tcl/program_board.tcl

.PHONY: remake-board
remake-board: hardware/component.xml
	vivado -mode batch -source tcl/build_hw.tcl

hardware/component.xml:
	$(MAKE) -C hardware component.xml

.PHONY: clean
clean: 
	rm -rf $(hwdir) *.jou *.log .Xil 
