let
  pkgs = import <nixpkgs> {};
in pkgs.mkShell {
  packages = [
    (pkgs.python3.withPackages (python-pkgs: [
      python-pkgs.translate-toolkit
      python-pkgs.beautifulsoup4
    ]))
    pkgs.pandoc
    pkgs.mdbook
    pkgs.gettext
  ];
}
