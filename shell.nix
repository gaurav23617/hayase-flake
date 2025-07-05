{ pkgs }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    jq
    curl
    nix-prefetch
  ];
}
