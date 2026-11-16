{ inputs, ... }:
{
  dendritic.nixosModules."nixos/services" =
    { pkgs, ... }:
    {
      services = {
        avahi = {
          enable = true;
          nssmdns4 = true;
          nssmdns6 = true;
          openFirewall = true;
        };

        dbus = {
          enable = true;
          implementation = "broker";
        };

        cloudflare-warp.enable = true;
        tailscale.enable = true;

        gvfs.enable = true;
      };

      systemd.services.tailscale-serve-navidrome = {
        description = "Expose Navidrome over the tailnet via Tailscale Serve";

        after = [
          "tailscaled.service"
          "network-online.target"
        ];
        wants = [ "network-online.target" ];
        requires = [ "tailscaled.service" ];

        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;

          # `serve` fails with "unexpected state: NoState" when it races
          # tailscaled restoring its (existing) state after a restart, and a
          # failed oneshot never retries — so retry here for a while.
          ExecStart = pkgs.writeShellScript "tailscale-serve-navidrome" ''
            for i in $(seq 1 30); do
              if ${pkgs.tailscale}/bin/tailscale serve --bg 4533; then
                exit 0
              fi
              sleep 2
            done
            echo "tailscale-serve-navidrome: tailscaled never left NoState" >&2
            exit 1
          '';
        };
      };
    };
}
