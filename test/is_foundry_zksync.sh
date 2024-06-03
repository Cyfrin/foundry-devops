#!/bin/bash

output=$(forge --version)

if [[ $output == forge\ 0.2.0* ]]; then
    echo 0x00 # This is false
else
    echo 0x01 # This is true
fi