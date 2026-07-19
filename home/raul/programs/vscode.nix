{
  pkgs,
  osConfig,
  ...
}:
{
  programs.vscodium = {
    enable = osConfig.macuguita.profiles.graphical.enable;
    package = pkgs.vscodium;

    profiles.default = {
      extensions =
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

        "editor.fontFamily" = "'Cartograph CF', 'Symbols Nerd Font Mono'";
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
        # TODO: figure this out
        # "nix.serverSettings" = {
        #   "nixd" = {
        #     "nixos" = {
        #       "expr" = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.echoslaptop.options";
        #     };
        #     "home-manager" = {
        #       "expr" =
        #         "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.echoslaptop.options.home-manager.users.type.getSubOptions []";
        #     };
        #   };
        # };
      };
    };
  };
}
