{
  lib,
  osConfig,
  ...
}:
let
  inherit (lib.attrsets)
    genAttrs
    mergeAttrsList
    ;
in
{
  programs.vesktop = {
    enable = osConfig.macuguita.profiles.graphical.enable;

    settings = {
      discordBranch = "canary";
      spellCheckLanguages = [
        "en-US"
        "en"
        "es-ES"
        "es"
      ];
      minimizeToTray = true;
      arRPC = true;
      hardwareAcceleration = false;
    };

    vencord = {
      themes = {
        font = ''
          :root {
            --font-code: monospace !important;
          }
        '';
      };

      settings = {
        enabledThemes = [ "font.css" ];
        plugins =
          [
            {
              FakeNitro = {
                enabled = true;
                enableEmojiBypass = true;
                enableStickerBypass = true;
                enableStreamQualityBypass = true;
                transformStickers = true;
                transformEmojis = true;
                transformCompoundSentence = true;
                emojiSize = 48;
                stickerSize = 160;
                hyperLinkText = "{{NAME}}";
                useHyperLinks = true;
                disableEmbedPermissionCheck = false;
              };
            }
            (genAttrs
              [
                "BetterUploadButton"
                "BiggerStreamPreview"
                "BlurNSFW"
                "CallTimer"
                "ClearURLs"
                "CopyFileContents"
                "CrashHandler"
                "Decor"
                "DontRoundMyTimestamps"
                "ExpressionCloner"
                "FakeProfileThemes"
                "FavoriteEmojiFirst"
                "FixCodeblockGap"
                "FixYoutubeEmbeds"
                "FixSpotifyEmbeds"
                "ForceOwnerCrown"
                "GameActivityToggle"
                "LoadingQuotes"
                "MentionAvatars"
                "NoDevtoolsWarning"
                "NoOnboardingDelay"
                "NormalizeMessageLinks"
                "NoTypingAnimation"
                "NoUnblockToJunp"
                "OpenInApp"
                "PermissionFreeWill"
                "PictureInPicture"
                "ReviewDB"
                "RoleColorEverywhere"
                "ShikiCodeblocks"
                "ThemeAttributes"
                "TypingIndicator"
                "TypingTweaks"
                "Unindent"
                "USRBG"
                "ValidUser"
                "ViewRaw"
                "VoiceDownload"
                "VoiceMessages"
                "VolumeBooster"
                "WebKeybinds"
                "WebScreenShareFixes"
                "WhoReacted"
                "YoutubeAdblock"
              ]
              (x: {
                enabled = true;
              })
            )
          ]
          |> mergeAttrsList;
        themeLinks = [
          "https://catppuccin.github.io/discord/dist/catppuccin-mocha-blue.theme.css"
          "https://codeberg.org/ridge/Discord-Adblock/raw/branch/main/discord-adblock.css"
          "https://raw.githubusercontent.com/Tnixc/discord-css/refs/heads/main/quickCss.css"
        ];
      };
    };
  };

  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/discord" = "vesktop.desktop";
  };
}
