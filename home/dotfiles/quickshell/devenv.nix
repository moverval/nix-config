{ pkgs, lib, config, inputs, ... }:

{
  # 1. Benötigte Pakete bereitstellen
    packages = [
      pkgs.quickshell
      pkgs.qt6.qtdeclarative  # Stellt QtQuick & Layouts bereit
      pkgs.kdePackages.qt6ct          # Optional: Hilft oft bei Styling-Problemen
    ];

    # 2. Umgebungsvariablen für den Language Server (qmlls) setzen
    # Devenv löst ${pkgs...} automatisch zu den absoluten /nix/store/... Pfaden auf
    env.QMLLS_BUILD_DIRS = "${pkgs.qt6.qtdeclarative}/lib/qt-6/qml:${pkgs.quickshell}/lib/qt-6/qml";

    # Fallback-Variablen für andere Tools
    env.QML2_IMPORT_PATH = "${pkgs.qt6.qtdeclarative}/lib/qt-6/qml:${pkgs.quickshell}/lib/qt-6/qml";

    # 3. Shell-Hook für dynamische lokale Pfade
    enterShell = ''
      # Setzt das aktuelle Verzeichnis als Import-Pfad (für deine eigenen Komponenten)
      export QML_IMPORT_PATH="$PWD"

      echo "⚡ Quickshell Devenv geladen! Import-Pfade gesetzt."
    '';
}
