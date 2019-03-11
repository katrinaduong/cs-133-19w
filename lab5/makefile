SRCS = cnn.h cnn.cpp opencl.cpp main.cpp

REQUIRED_FILES = lab5-report.pdf xilinx.cl
OPTIONAL_FILES = merlin/src/CnnKernel.cpp

#include ./utils.mk

DSA := xilinx_aws-vu9p-f1-04261818_dynamic_5_0
#DEVICES := xilinx_vcu1525_dynamic
DEVICE := $(AWS_PLATFORM_DYNAMIC_5_0)
XOCC := $(XILINX_SDX)/bin/xocc
CLFLAGS = -t $(TARGET) --platform $(DEVICE) --save-temps 

# Building kernel
cnn.$(TARGET).$(DSA).xo: ./xilinx.cl
	$(XOCC) $(CLFLAGS) -c -k CnnKernel -I'$(<D)' -o'$@' '$<'

cnn.$(TARGET).$(DSA).xclbin: cnn.$(TARGET).$(DSA).xo
	$(XOCC) $(CLFLAGS) -l $(LDCLFLAGS) --nk CnnKernel:1 -o'$@' $(+)

emconfig:emconfig.json
emconfig.json:
	emconfigutil --platform $(DEVICE) --od . 

export OPENCL_PLATFORM = Xilinx
export OPENCL_DEVICE = $(DSA)
export OPENCL_BINARY = cnn.$(TARGET).$(DSA).xclbin

test: cnn $(OPENCL_SOURCE) cnn.$(TARGET).$(DSA).xclbin
	. ./params.sh; ./$<

test-seq:
	@$(MAKE) --no-print-directory test SEQUENTIAL=

cnn: $(SRCS)
	$(CXX) $(CXXFLAGS) -o $@ $(filter %.cpp %.a %.o, $^) $(LDFLAGS)

include ../makefile

CXXFLAGS := $(subst -fno-loop-unroll-and-jam,,$(subst -march=native,,$(CXXFLAGS)))
LDFLAGS += -lOpenCL

swsim: emconfig
	XCL_EMULATION_MODE=sw_emu $(MAKE) TARGET=sw_emu test

hwsim: emconfig
	XCL_EMULATION_MODE=hw_emu $(MAKE) TARGET=hw_emu test

hls:
	$(MAKE) TARGET=hw cnn.hw.$(DSA).xo

