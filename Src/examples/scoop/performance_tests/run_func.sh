#!/bin/bash

TIMEOUT=60s

function run_loop {
    EXEC=EIFGENs/$1/F_code/$@
    TIMEOUT_EXEC="timeout -s 9 $TIMEOUT time -f \"%e\" $EXEC 2>&1 >/dev/null"

    # redirect stderr to stdout and stdout to /dev/null
    out=$($TIMEOUT_EXEC)

    while [ $? -ne 0 ]; do
        out=$($TIMEOUT_EXEC)
    done

    echo $out
}