#!/bin/sh
export/Main lbcl examples/HelloWorld.lbcl.txt
export/Main hbcl examples/HelloWorld.hbcl.txt
echo 36| export/Main hbcl examples/GuessNumber.hbcl.txt
echo 46| export/Main hbcl examples/GuessNumber.hbcl.txt
echo 31| export/Main hbcl examples/GuessNumber.hbcl.txt
echo 149| export/Main hbcl examples/GuessNumber.hbcl.txt