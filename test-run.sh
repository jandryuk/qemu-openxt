#!/bin/bash

. src-vars

( cd $TBOOT ; make ) && \
  ( cd $XEN/xen ; make -j8 ) && \
  cp $XEN/xen/xen.efi xen.efi-4.14 && \
  cp $TBOOT/tboot/tboot{,.gz} ./ && \
  bash create-image.sh && \
  bash run-image.sh
