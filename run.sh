#!/bin/bash

export UVMHOME="/tools/cadence/XCELIUM2309/tools/methodology/UVM/CDNS-1.1d/"

echo "THIS: $(dirname -- $(readlink -fn -- "$0"))"

export CURRENT_PATH=$(dirname -- $(readlink -fn -- "$0"))

seed=$(((RANDOM % 999999999 )  + 100000000))

echo "Running seed: $seed"

xrun -lwdgen -access rwc -uvm -uvmhome $UVMHOME -svseed $seed -f file_list.f +UVM_VERBOSITY=UVM_DEBUG