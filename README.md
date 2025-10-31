# Nix / CPP Configuration

*Viewing the nix tree:*
```
nix flake show
```
*Entering the development shell:*
```
nix develop
```
*Building the application*
`nix build *build type*.*libc*`
For example: 
```
nix build .\#debug.glibc
```
Or: 
```
nix build .\#release.glibc
```
*Running Application:*
```
nix run .\#glibc
```
