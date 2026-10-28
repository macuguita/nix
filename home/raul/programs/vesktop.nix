{ inputs, ... }:
{
  dendritic.homeModules."home/raul/programs/vesktop" =
    {
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib.attrsets) genAttrs mergeAttrsList;

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

      vencordSettings = {
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
              (_: {
                enabled = true;
              })
            )
          ]
          |> mergeAttrsList;
        themeLinks = [
          "https://codeberg.org/ridge/Discord-Adblock/raw/branch/main/discord-adblock.css"
          "https://raw.githubusercontent.com/Tnixc/discord-css/refs/heads/main/quickCss.css"
        ];
      };

      jsonFormat = pkgs.formats.json { };
    in
    {
      packages = [ pkgs.vesktop ];

      xdg.config.files = {
        "vesktop/settings.json" = {
          generator = jsonFormat.generate "vesktop-settings.json";
          value = settings;
        };

        "vesktop/settings/settings.json" = {
          generator = jsonFormat.generate "vencord-settings.json";
          value = vencordSettings;
        };

        "vesktop/themes/font.css".text = ''
          :root {
            --font-code: monospace !important;
          }
        '';
      };
    };
}
