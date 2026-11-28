#!/bin/bash

# https://gist.github.com/planetceres/917840478e1e4d45f8373667630e51a0
for port in $(lspci | grep USB | cut -d' ' -f1); do
    echo -n "0000:${port}"| sudo tee /sys/bus/pci/drivers/xhci_hcd/unbind;
    echo
    sleep 5;
    echo -n "0000:${port}" | sudo tee /sys/bus/pci/drivers/xhci_hcd/bind;
    echo
    sleep 5;
done
