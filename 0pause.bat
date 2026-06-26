@echo off

if exist pause.txt (
del pause.txt
exit
)
if not exist pause.txt (
echo pause>pause.txt
exit
)
