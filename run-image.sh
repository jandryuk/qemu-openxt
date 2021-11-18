#!/bin/bash

image=${1:-esp.raw}

TPM_STATE=tpm-state

run_swtpm() {
    [ ! -d "$TPM_STATE" ] && mkdir "$TPM_STATE"
    swtpm socket --tpmstate dir="$TPM_STATE" \
                 --ctrl type=unixio,path="$TPM_STATE"/swtpm-sock \
                 --log level=20 \
                 --tpm2
}

run_swtpm &

qemu-system-x86_64 -enable-kvm \
 -m 6000 \
 -smp 4 \
 --machine pc-q35-2.5 \
 -display gtk \
 -drive if=pflash,format=raw,readonly=on,file=./OVMF_CODE.fd \
 -drive if=pflash,format=raw,file=./OVMF_VARS.fd \
 -drive file=esp.raw,format=raw,index=0,media=disk \
 -boot menu=on \
 -chardev socket,id=chrtpm,path="$(pwd)/$TPM_STATE/swtpm-sock" \
 -tpmdev emulator,id=tpm0,chardev=chrtpm -device tpm-tis,tpmdev=tpm0 \
 -serial file:serial.log \
 -debugcon file:debug.log -global isa-debugcon.iobase=0x402 \
 -gdb tcp:localhost:1234
