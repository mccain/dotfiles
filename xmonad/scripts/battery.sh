#!/bin/bash
bat=$(acpi -b | egrep -o [[:digit:]]+ | tail -n 1)
if [ $(echo -n $bat | wc -c) -ne 0 ]
then echo ${bat}%
else echo removed
fi
