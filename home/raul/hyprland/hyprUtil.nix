# hyprUtil.nix
{ lib }:
let
  mkLua = lib.generators.mkLuaInline;
  # Helper to strip null-valued keys from an attrset
  compactAttrs = lib.filterAttrs (_: v: v != null);
  # Wrap _args consistently
  mkArgs = args: { _args = args; };
in
{
  inherit mkLua;

  # --- Curves ---
  # Both bezier and spring now take a name + attrset, unified shape
  mkBezier =
    name: p1: p2:
    let
      x1 = builtins.elemAt p1 0;
      y1 = builtins.elemAt p1 1;
      x2 = builtins.elemAt p2 0;
      y2 = builtins.elemAt p2 1;
    in
    mkArgs [
      name
      (mkLua ''{ type = "bezier", points = { {${toString x1}, ${toString y1}}, {${toString x2}, ${toString y2}} } }'')
    ];

  mkSpring =
    name:
    {
      mass,
      stiffness,
      dampening,
    }:
    mkArgs [
      name
      {
        type = "spring";
        inherit mass stiffness dampening;
      }
    ];

  # --- Animations ---
  # Use compactAttrs to drop nulls naturally instead of the ugly conditional keys
  mkAnimation =
    {
      leaf,
      enabled ? true,
      speed,
      bezier ? null,
      spring ? null,
      style ? null,
    }:
    mkArgs [
      (compactAttrs {
        inherit
          leaf
          enabled
          speed
          bezier
          spring
          style
          ;
      })
    ];

  mkAnimations = anims: map (a: mkArgs [ (compactAttrs a) ]) anims;

  # --- Binds ---
  mkBind =
    {
      key,
      action,
      opts ? { },
    }:
    mkArgs (
      [
        key
        action
      ]
      ++ lib.optional (opts != { }) opts
    );

  # --- Window Rules ---
  # Explicit fields instead of passthrough — safer and more readable
  mkWindowRule =
    {
      name,
      match ? { },
      workspace ? null,
      float ? null,
      tile ? null,
      no_focus ? null,
      no_initial_focus ? null,
      suppress_event ? null,
    }:
    mkArgs [
      (compactAttrs {
        inherit
          name
          match
          workspace
          float
          tile
          no_focus
          no_initial_focus
          suppress_event
          ;
      })
    ];

  # --- Dispatcher ---
  # All dsp values are now consistently functions (use dsp.close() if no args needed)
  dsp = {
    exec = cmd: mkLua ''hl.dsp.exec_cmd("${cmd}")'';
    close = mkLua "hl.dsp.window.close()";
    toggleFloat = mkLua ''hl.dsp.window.float({ action = "toggle" })'';
    toggleSplit = mkLua ''hl.dsp.layout("togglesplit")'';
    workspace = ws: mkLua ''hl.dsp.focus({ workspace = "${toString ws}" })'';
    moveToWorkspace = ws: mkLua ''hl.dsp.window.move({ workspace = "${toString ws}" })'';
    special = name: mkLua ''hl.dsp.workspace.toggle_special("${name}")'';
  };
}
