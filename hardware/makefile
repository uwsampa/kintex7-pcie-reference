all: component

.PHONY: ip
ip: ipx
	find "ipx/ipx.srcs" -type f -iname "*.xci" -exec cp {} ./ip \;

.PHONY: component
component:
	vivado -mode batch -source tcl/create_component.tcl

.PHONY: clean
clean:
	rm -rf component.xml ipx xgui *.jou *.log
