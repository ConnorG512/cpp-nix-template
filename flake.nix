{
  description = "C++ Nix flake configuration.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    exec_name = "app";
    version = "1.0.0";

    build_dependencies = with pkgs; [
      llvmPackages_21.libcxxClang
      llvmPackages_21.libcxx
      cmake
    ];
    
    shell_hook_message = "Entering C++ Shell";
  in
  {
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        clang-tools
        # valgrind
        gef
      ];
      shellHook = ''
        echo "${shell_hook_message}" 
      '';
    };

    packages.${system} = {
      debug = pkgs.stdenv.mkDerivation (finalAttrs: {
          pname = "${exec_name}";
          version = "${version}";
          dontStrip = true;
          src = ./.;

          nativeBuildInputs = build_dependencies;

          buildInputs = with pkgs; [
            llvmPackages_21.libcxx
          ];

          cmakeFlags = [
            "-DCMAKE_BUILD_TYPE=Debug"
            "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON"
          ];
          
          installPhase = ''
            mkdir -p $out/bin
            cp compile_commands.json $out/bin
            cp ${exec_name} $out/bin
          '';
        });
      release = pkgs.stdenv.mkDerivation (finalAttrs: {
          pname = "${exec_name}";
          version = "${version}";
          src = ./.;

          nativeBuildInputs = build_dependencies;

          buildInputs = with pkgs; [
            llvmPackages_21.libcxx
          ];

          cmakeFlags = [
            "-DCMAKE_BUILD_TYPE=Release"
            "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON"
          ];
          
          installPhase = ''
            mkdir -p $out/bin
            cp compile_commands.json $out/bin
            cp ${exec_name} $out/bin
          '';
        });

        apps.${system} = {
          debug = {
            type = "app";
            program = "${self.packages.${system}.debug}/bin/${exec_name}";
          };
          release = {
            type = "app";
            program = "${self.packages.${system}.debug}/bin/${exec_name}";
          };
        };
    };
  };
}
