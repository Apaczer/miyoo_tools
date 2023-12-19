## Description
Script tool to generate working release for your binaries working under GMenu2X.

## Instruction  
Put inside working directory:  
- program's `<target_name>` binary
- `./assets` dir with all necessary files which goes in same place where binary goes
- `./opkg_assets` dir with custom IPK's control files (these are auto-generated if missing).
- edit ENVironment VARiables and EXECution commands in `gm2x_packager.sh` script to perform desired outcome
- run `./gm2x_packager.sh`

NOTES: Optionally put `Aliases.txt` & `<target_name>.man.txt` file in script current working directory
