#!/bin/bash

output=$(forge --version)

if [[ $output == forge\ 0.2.0* || $output == forge\ 0.3.0* || $output == "forge Version: 0.3"* || $output == "forge Version: 1.0"* ]]; then
    echo 0x00 # This is false
else
    echo 0x01 # This is true
fi