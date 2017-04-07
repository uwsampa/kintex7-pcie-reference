Kintex 7 PCIe Reference Design
------------------------------

(TODO better description)

1. Build the driver in `software/driver` and copy the provided driver rules from the etc directory 
	to the `/etc/` directory on your system with `cp ../etc/udev/rules.d/* /etc/udev/rules.d/`
2. Build the hardware with `make remake-board` and program the board over jtag with `make program`
3. Load the driver after reboot with `sudo ./load_driver.sh` (in the software folder)
4. Test FPGA design with `python test_harness.py` (in the software folder)

A trimmed down verison of [this reference
design](https://www.xilinx.com/member/forms/download/design-license.html?cid=379014&filename=rdf0282-k7-connectivity-trd-2014-3.zip):

Important changes to get the reference driver to build:

  1. In `driver/xdma/xdma_base.c` file replace all of `__dev` prefixes with `__`
   (for
  example `__devinit` --> `__init`, `__devexit` --> `__exit`)

  2. In `driver/xrawdata0/Makefile` and `driver/xrawdata1/Makefile` add this
  line to end of file:
    `KBUILD_EXTRA_SYMBOLS := $(src)/../xdma/Module.symvers`

  3. Change device number to 0x7042 in `driver/xdma/xdma_base.c`.
