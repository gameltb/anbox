ccflags-y += -I$(src) -Wno-int-conversion -DCONFIG_ANDROID_BINDER_DEVICES="\"binder,hwbinder,vndbinder\""
obj-m := binder_linux.o
binder_linux-y := binder.o binder_alloc.o deps.o

KERNEL_SRC ?= /lib/modules/$(shell uname -r)/build

all:
	$(MAKE) -C $(KERNEL_SRC) V=0 M=$$PWD

install:
	cp binder_linux.ko $(DESTDIR)/

clean:
	rm -rf deps.h *.o *.ko *.mod.c *.symvers *.order .*.cmd .tmp_versions
