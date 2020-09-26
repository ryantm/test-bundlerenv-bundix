let

  pkgs = import (builtins.fetchTarball {
    url = "https://github.com/nixos/nixpkgs/archive/bbeed7ecf8a0d154f7588002c9734220032b5e56.tar.gz";
    sha256 = "sha256:1g7f0wf50js2fngs6vxwyi4pk300iz0860jdbrijysc89z1wvx61";
  }) {};

  env = extraGroups: pkgs.bundlerEnv {
    name = "bundler-env";
    gemdir  = ./.;

    groups   = [ "default" ] ++ extraGroups;
  };

in
{

  # fails
  # nix-shell -A default --run "rspec"
  default = pkgs.mkShell {
    buildInputs = [ (env []) ];
  };

  # fails
  # nix-shell -A test --run "rspec"
  test = pkgs.mkShell {
    buildInputs = [ (env ["test"]) ];
  };

  # fails
  # nix-shell -A dev --run "rspec"
  dev = pkgs.mkShell {
    buildInputs = [ (env ["dev"]) ];
  };

  # works
  # nix-shell -A all --run "rspec"
  all = pkgs.mkShell {
    buildInputs = [ (env ["dev" "test"]) ];
  };

}
