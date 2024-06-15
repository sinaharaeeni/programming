@echo off
setlocal enabledelayedexpansion

set "dead_hosts="

for /L %%A in (10,1,11) do (
  for /L %%B in (1,1,28) do (
      set "ip=192.168.%%A.%%B"
      ping -n 1 -w 1000 !ip! | find "TTL=" >nul
      if errorlevel 1 (
          set "dead_hosts=!dead_hosts! !ip!"
      ) else (
          echo !ip! is alive
      )
  )
)

echo Dead hosts:%dead_hosts% >> err.txt
timeout /t 15
