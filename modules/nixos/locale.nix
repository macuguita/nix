{ config, ... }:
{
  time = {
    timeZone = "Europe/Madrid";
    hardwareClockInLocalTime = true;
  };

  i18n = {
    defaultLocale = "es_ES.UTF-8";

    extraLocales = [
      "en_US.UTF-8/UTF-8"
    ];

    extraLocaleSettings = {
      LC_MESSAGES = "en_US.UTF-8";
    };
  };
}
