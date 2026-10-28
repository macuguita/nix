{ inputs, ... }:
{
  dendritic.homeModules."home/raul/programs/vscode" =
    {
      pkgs,
      lib,
      ...
    }:
    let
      inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;

      vscodium = pkgs.vscode-with-extensions.override {
        vscode = pkgs.vscodium;
        vscodeExtensions =
          (with pkgs.vscode-extensions; [
            jnoortheen.nix-ide
            mkhl.direnv
            ms-python.python
            rust-lang.rust-analyzer
            github.vscode-github-actions
            ms-vscode.hexeditor
            esbenp.prettier-vscode
            svelte.svelte-vscode
          ])
          ++ (with pkgs.open-vsx; [
            theqtcompany.qt-qml
            theqtcompany.qt-core
            slevesque.shader
          ]);
      };

      userSettings = {
        "files.autoSave" = "afterDelay";
        "files.autoSaveDelay" = 1000;

        "editor.minimap.enabled" = false;

        "workbench.productIconTheme" = "fluent-icons";
        "workbench.tree.indent" = 16;

        "editor.selectionHighlight" = false;
        "editor.occurrencesHighlight" = "off";

        "editor.cursorSmoothCaretAnimation" = "on";
        "editor.smoothScrolling" = true;

        "editor.formatOnSave" = true;

        "editor.fontFamily" = "'Maple Mono NL NF', 'Cartograph CF', 'Symbols Nerd Font Mono'";
        "editor.fontSize" = 15;
        "editor.lineHeight" = 1.5;
        "editor.fontLigatures" = true;

        "explorer.confirmDelete" = false;

        "nix.serverPath" = "nixd";
        "nix.enableLanguageServer" = true;

        "qt-qml.qmlls.customExePath" = "${pkgs.kdePackages.qtdeclarative}/bin/qmlls";
        "qt-qml.qmlls.useQmlImportPathEnvVar" = true;
        "qt-qml.doNotAskForQmllsDownload" = true;

        "workbench.editorAssociations" = {
          "{hexdiff}:/**/*.*" = "hexEditor.hexedit";
          "*.qrc" = "qt-core.qrcEditor";
        };
        "[typescript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };

        "chat.disableAIFeatures" = "true";
      };

      settingsFile = {
        generator = (pkgs.formats.json { }).generate "vscodium-settings.json";
        value = userSettings;
      };
    in
    {
      packages = [ vscodium ];

      xdg.config.files = lib.mkIf isLinux {
        "VSCodium/User/settings.json" = settingsFile;
      };

      files = lib.mkIf isDarwin {
        "Library/Application Support/VSCodium/User/settings.json" = settingsFile;
      };
    };
}
