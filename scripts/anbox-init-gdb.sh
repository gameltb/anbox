#!/system/bin/sh
# Copyright (C) 2016 Simon Fels <morphis@gravedo.de>
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 3, as published
# by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranties of
# MERCHANTABILITY, SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR
# PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program.  If not, see <http://www.gnu.org/licenses/>.

set -x

function prepare_filesystem() {
	# These dev files need to be adjusted everytime as they are
	# bind mounted into the temporary rootfs
	for f in qemu_pipe qemu_trace goldfish_pipe input/* ; do
		if [ ! -e "/dev/$f" ] ; then
			continue
		fi
		chown system:system /dev/$f
		chmod 0666 /dev/$f
	done

	if [ -e "/dev/tun" ] ; then
		chown system:vpn /dev/tun
		chmod 0660 /dev/tun
	fi
	mkdir -m 0755 /dev/socket
	mount -t tmpfs -o mode=0755,uid=0,gid=1000,noexec,nosuid,nodev tmpfs /mnt
	mkdir -m 0755 /mnt/vendor
	chmod 777 /dev/kmsg

}

prepare_filesystem &
echo "Waiting for filesystem being prepared ..."
wait $!

echo androidboot.hardware=goldfish androidboot.selinux=permissive \
    > /data/cmdline
mount -o bind /data/cmdline /proc/cmdline

echo  0 > /data/fake_mmap_rnd_compat_bits
mount -o bind /data/fake_mmap_rnd_compat_bits /proc/sys/vm/mmap_rnd_compat_bits

echo  0 > /data/fake_mmap_rnd_bits
mount -o bind /data/fake_mmap_rnd_bits /proc/sys/vm/mmap_rnd_bits

echo  0 > /data/fake_kptr_restrict
mount -o bind /data/fake_kptr_restrict /proc/sys/kernel/kptr_restrict

mount -o bind /sys/fs/cgroup/cpu,cpuacct /acct

mkdir /dev/cpuctl
mount -o bind /sys/fs/cgroup/cpu,cpuacct /dev/cpuctl

touch /dev/.coldboot_done

ifconfig eth0 192.168.250.2
ip ro add default via 192.168.250.1 dev eth0

echo "Starting real init now ..."
export INIT_SELINUX_TOOK=1500
export INIT_STARTED_AT=1000
export INIT_SECOND_STAGE=true
#exec strace /init
exec gdbserver64 :1234 /init
