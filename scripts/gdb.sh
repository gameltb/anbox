#/usr/bin/sh
android=$PWD
product=x86_64

export LD_LIBRARY_PATH=$android/libncurses

$android/prebuilts/gdb/linux-x86/bin/gdb -q \
-ex "set sysroot $android/out/target/product/$product/symbols/" \
-ex "target remote 192.168.250.2:1234" \
-ex "set solib-search-path $android/out/target/product/$product/symbols/system/lib:$android/out/target/product/$product/symbols/system/lib/hw:$android/out/target/product/$product/symbols/system/lib/ssl/engines:$android/out/target/product/$product/symbols" \
-ex "gef config context.layout \"code regs source\""
