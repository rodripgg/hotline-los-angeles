@echo off
setlocal

REM === Ejecuta siempre desde la carpeta donde está este .bat ===
cd /d "%~dp0"

echo.
echo Creando estructura de carpetas en:
echo   %CD%
echo.

for %%D in (
  "addons"
  "assets\art\sprites\vehicles"
  "assets\art\sprites\characters"
  "assets\art\sprites\fx"
  "assets\art\sprites\ui"
  "assets\art\textures\world"
  "assets\art\textures\props"
  "assets\art\materials"
  "assets\art\fonts"
  "assets\audio\music"
  "assets\audio\sfx"
  "assets\shaders"
  "assets\maps\tilesets"
  "scenes\_bootstrap"
  "scenes\levels\test"
  "scenes\levels\city_01"
  "scenes\world"
  "scenes\world\props"
  "scenes\entities\vehicles"
  "scenes\entities\characters"
  "scenes\entities\pickups"
  "scenes\entities\weapons"
  "scenes\ui\hud"
  "scenes\ui\menus"
  "scenes\ui\widgets"
  "scenes\fx"
  "scripts\core"
  "scripts\managers"
  "scripts\gameplay\vehicles"
  "scripts\gameplay\characters"
  "scripts\gameplay\weapons"
  "scripts\gameplay\systems"
  "scripts\ui"
  "scripts\debug"
  "data\configs"
  "data\defs\vehicles"
  "data\defs\characters"
  "data/defs/weapons"
  "data\localization"
  "tests"
  "build"
) do (
  if not exist "%%~D" (
    mkdir "%%~D" >nul
    echo + %%~D
  ) else (
    echo = %%~D
  )
)

echo.
echo Listo.
pause
endlocal
