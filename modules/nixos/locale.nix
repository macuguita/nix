{ config, ... }:
{
  time = {
    timeZone = "Europe/Madrid";
    hardwareClockInLocalTime = true;
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocales = [
      "es_ES.UTF-8/UTF-8"
    ];
  };
}
