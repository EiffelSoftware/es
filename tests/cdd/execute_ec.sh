#!/bin/bash
cd $1
echo -e "y\nI\nL\nW\nD\nL\nK\nQ\nQ\nL\nM\nQ\nQ\n" | ec -loop -config config.ecf -target sut
echo -e "T\nR\nQ\n" | ec -loop -config config.ecf -target 2>zzz.outcome
