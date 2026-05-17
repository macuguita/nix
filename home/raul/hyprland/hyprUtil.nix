{ lib, ... }:
{
  lua = lib.generators.mkLuaInline;

  mkBezier = name: p1: p2: {
    _args = [
      name
      (lib.generators.mkLuaInline ''
        { type = "bezier", points = { {${toString (builtins.elemAt p1 0)}, ${toString (builtins.elemAt p1 1)}}, {${toString (builtins.elemAt p2 0)}, ${toString (builtins.elemAt p2 1)}} } }
      '')
    ];
  };
  mkSpring =
    name:
    {
      mass,
      stiffness,
      dampening,
    }:
    {
      _args = [
        name
        {
          type = "spring";
          inherit mass stiffness dampening;
        }
      ];
    };
  mkAnimation =
    {
      leaf,
      enabled ? true,
      speed,
      bezier ? null,
      spring ? null,
      style ? null,
    }:
    {
      _args = [
        {
          inherit leaf enabled speed;
          ${if bezier != null then "bezier" else null} = if bezier != null then bezier else null;
          ${if spring != null then "spring" else null} = if spring != null then spring else null;
          ${if style != null then "style" else null} = if style != null then style else null;
        }
      ];
    };

  mkBind =
    {
      key,
      action,
      opts ? { },
    }:
    {
      _args = [
        key
        action
      ]
      ++ lib.optional (opts != { }) opts;
    };

  dsp = {
    exec = cmd: lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${cmd}")'';

    close = lib.generators.mkLuaInline "hl.dsp.window.close()";

    toggleFloat = lib.generators.mkLuaInline ''hl.dsp.window.float({ action = "toggle" })'';

    toggleSplit = lib.generators.mkLuaInline ''hl.dsp.layout("togglesplit")'';

    workspace = ws: lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = "${toString ws}" })'';

    moveToWorkspace =
      ws: lib.generators.mkLuaInline ''hl.dsp.window.move({ workspace = "${toString ws}" })'';

    special = name: lib.generators.mkLuaInline ''hl.dsp.workspace.toggle_special("${name}")'';
  };

  mkWindowRule =
    {
      name,
      match ? { },
      ...
    }@rule:

    {
      _args = [
        (
          {
            inherit name match;
          }
          // removeAttrs rule [
            "name"
            "match"
          ]
        )
      ];
    };
}
