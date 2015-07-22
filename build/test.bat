@echo off
echo ==== Hello World LBCL
export\Main lbcl examples\HelloWorld.lbcl.txt
echo ==== Hello World HBCL
export\Main hbcl examples\HelloWorld.hbcl.txt
echo ==== Guess the Number HBCL (the number is 36)
echo == First try (correct)
echo 36| export\Main hbcl examples\GuessNumber.hbcl.txt
echo == Second try (incorrect, 46)
echo 46| export\Main hbcl examples\GuessNumber.hbcl.txt
echo == Third try (incorrect, 31)
echo 31| export\Main hbcl examples\GuessNumber.hbcl.txt
echo == Fourth try (incorrect, 149)
echo 149| export\Main hbcl examples\GuessNumber.hbcl.txt