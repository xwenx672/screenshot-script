@echo off
:start:
setlocal EnableDelayedExpansion
title %~n0
set "batdir=%~dp0"
pushd "%batdir%"

powershell -WindowStyle Hidden -ExecutionPolicy Bypass -File "%batdir%settimestamps.ps1" -Folder "%batdir%compressed"
