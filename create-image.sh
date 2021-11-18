#!/bin/bash

set -e
set -u

extra_oxt_files=(
	8th_gen_i5_i7-SINIT_76.bin
	3rd_gen_i5_i7_SINIT_67.BIN
	4th_gen_i5_i7_SINIT_75.BIN
	5th_gen_i5_i7_SINIT_79.BIN
	6th_gen_i5_i7_SINIT_71.BIN
	i5_i7_DUAL_SINIT_51.BIN
	i7_QUAD_SINIT_51.BIN
	Q45_Q43_SINIT_51.BIN
)
oxt_files=(
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
)
xen_file=(
	xen.efi
)

image=${1:-esp.raw}

truncate -s 256M $image

mkfs.vfat $image

mmd -i $image EFI
mmd -i $image EFI/BOOT
mmd -i $image EFI/OpenXT

for f in "${oxt_files[@]}"; do
	mcopy -i $image $f ::EFI/OpenXT/$f
done

mcopy -i $image fbx64.efi ::EFI/BOOT/fbx64.efi
mcopy -i $image shimx64.efi ::EFI/BOOT/BOOTx64.EFI

mcopy -i $image xen.efi-4.14 ::EFI/OpenXT/xen.efi
