Kintex 7 PCIe Driver Reference
------------------------------

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
