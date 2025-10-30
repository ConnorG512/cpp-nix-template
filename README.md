# Nix / CPP Configuration

*Viewing the nix tree:*
```
nix flake show
```
*Entering the development shell:*
```
nix develop
```
*Building the debug build:*
```
nix build .\#debug
```
*Building the release build:*
```
nix build .\#release
```
*Building and running the debug build*
```
nix run .\#debug
```
*Building and running the release build*
```
nix run .\#release
```
