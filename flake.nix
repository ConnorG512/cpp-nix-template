{
  description = "C++ Nix flake configuration.";

  inputs = 
  {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    execName = "app";
  in
  {
    devShells.${system}.default = 
    let
      shellHookMessage = "Entering C++ Shell";
    in
    pkgs.mkShell
    {
      packages = with pkgs; 
      [
        clang-tools
        gef
      ];
      shellHook = 
      ''
        echo "${shellHookMessage}" 
      '';
    };
    
    packages.x86_64-linux = 
    let 
      version = "1.0.0";
      compileCommandsOn = "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON";
      commonInstallPhase = 
      ''
        mkdir -p $out/bin
        cp compile_commands.json $out/bin
        cp ${execName} $out/bin
      '';
    
    build_dependencies = with pkgs; 
    [
      llvmPackages_21.libcxxClang
      cmake
    ];
    in
    {
      release = 
      let
        cmakeReleaseFlags = [
          "-DCMAKE_BUILD_TYPE=Release"
          compileCommandsOn
        ];
      in
      {
        glibc = pkgs.stdenv.mkDerivation (finalAttrs: 
        {
          pname = "${execName}";
          version = "${version}";
          src = ./.;
          nativeBuildInputs = build_dependencies;

          buildInputs = with pkgs; [
            llvmPackages_21.libcxx
          ];
          cmakeFlags = cmakeReleaseFlags;
          installPhase = commonInstallPhase;
        });
      };
      debug = 
      let
        cmakeDebugFlags = 
        [
          "-DCMAKE_BUILD_TYPE=Debug"
          compileCommandsOn
        ];
      in
      {
        glibc = pkgs.stdenv.mkDerivation (finalAttrs: 
        {
          pname = "${execName}";
          version = "${version}";
          dontStrip = true;
          src = ./.;
          nativeBuildInputs = build_dependencies;

          buildInputs = with pkgs; [
            llvmPackages_21.libcxx
          ];
          cmakeFlags = cmakeDebugFlags;
          installPhase = commonInstallPhase;
        });
      };
    };
    apps.x86_64-linux = 
    {
      glibc = 
      {
        type = "app";
        program = "${self.packages.x86_64-linux.release.glibc}/bin/${execName}";
      };
    };
  };
}
