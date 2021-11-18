#!/bin/bash


cat << EOF
Build and run a minimal OpenXT-ish UEFI ESP
qemu gdb stub is running - Use \`target remote localhost:1234\`

From an OpenXT build, copy:
	Q35_SINIT_51.BIN
	fbx64.efi
	shimx64.efi
	tboot.gz
	openxt.cfg
	tboot
	BOOT.CSV
	bzImage
	initrd
	policy.24
	microcode_intel.bin
to local directory

# Get OVMF code and variables:
cp /usr/share/edk2/ovmf/OVMF_{CODE,VARS}.fd .

#Trim the sinit modules from openxt.cfg to run a little faster
sed -i 's/sinit=.*/sinit=Q35_SINIT_51.BIN/' openxt.cfg

Set XEN= and TBOOT= variables in src-vars
XEN=~/openxt/xen
TBOOT=~/openxt/tboot

# Build Xen, tboot, and OVMF image and run it under qemu:
bash test-run.sh

#For serial port output:
tail -F serial.log

#For OVMF debug output:
tail -F debug.log
EOF
