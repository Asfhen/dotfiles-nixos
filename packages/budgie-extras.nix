{ stdenv, fetchFromGitHub, pkgs, lib }:

stdenv.mkDerivation rec {
  pname = "budgie-extras";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "UbuntuBudgie";
    repo = "budgie-extras";
    rev = "70d14d2d4f1cd5605b2ce9ed9c36c6da396840a6";
    sha256 = "TPqrBQAsbC064YCr4AZBupCQ8fA7iDFQ00dafD941aM=";
    fetchSubmodules = true;
    deepClone = true;
  };

  nativeBuildInputs = with pkgs; [
    meson
    ninja
    vala
    intltool
    pkgconfig
    glib
    glibc
    cmake
    budgie.budgie-desktop
  ];
  buildInputs = with pkgs; [
    gtk3
    clang
    rapidjson
    libgee
    pantheon.granite
    appstream
    json-glib
    libhandy
    libpeas
    libwnck
    libnotify
    libsoup
    keybinder3
    gnome.gnome-settings-daemon
    networkmanager
    libnma
  ];

  buildPhase = ''
    # mkdir build && cd build
    meson --buildtype plain \
          -Dbuild-recommendee=false \
          -Dwith-default-schema=false \
          -Dbuild-applications-menu=true \
          -Dbuild-dropby=true \
          -Dbuild-hotcorners=true \
          -Dbuild-kangaroo=true \
          -Dbuild-network-manager=true \
          -Dbuild-quicknote=true \
          -Dbuild-visualspace=true \
          -Dbuild-wallstreet=true \
          -Dbuild-weathershow=true \
          -Dbuild-wpreview=false \
          --prefix=/usr \
          --libdir=/usr/lib
  '';

  installPhase = ''
    ninja install
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/UbuntuBudgie/budgie-extras";
    description = "Additional enhancements for the user experience.";
    license = lib.licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.UbuntuBudgie ];
  };
}