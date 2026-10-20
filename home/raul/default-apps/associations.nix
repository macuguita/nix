# Default application associations, grouped per application.
#
# `macUtis`/`macExtensions` key the macOS handler per UTI or filename extension,
# `linux` per MIME type, `desktop` is the Linux .desktop entry id and `macApp`
# the app bundle name under ~/Applications/Home Manager Apps.
{
  apps = {
    emacs = {
      bundleId = "com.macuguita.emacs-client";
      macApp = "Emacs Client.app";
      desktop = "emacsclient.desktop";

      macUtis = [
        "public.plain-text"
        "public.utf8-plain-text"
        "public.text"
        "public.source-code"
        "public.script"
        "public.shell-script"
        "public.c-source"
        "public.c-plus-plus-source"
        "public.objc-source"
        "public.python-script"
        "public.ruby-script"
        "public.perl-script"
        "public.lex-source"
        "public.yacc-source"
        "com.microsoft.bat"
        "public.json"
        "public.xml"
        "public.yaml"
        "public.comma-separated-values-text"
        "net.daringfireball.markdown"
      ];

      macExtensions = [
        # config / data
        "toml"
        "cfg"
        "conf"
        "ini"
        "env"
        "properties"
        "log"
        "csv"
        "tsv"
        # code
        "lua"
        "rs"
        "go"
        "ts"
        "tsx"
        "sql"
        "diff"
        "patch"
        "tex"
        "py"
        "rb"
        "pl"
        "php"
        "c"
        "h"
        "cc"
        "cpp"
        "cxx"
        "hpp"
        "hh"
        "m"
        "mm"
        "l"
        "lex"
        "flex"
        "y"
        "yacc"
        "yy"
        "cs"
        "swift"
        "sh"
        "bash"
        "zsh"
        "fish"
        "ps1"
        "bat"
        "r"
        "vim"
        "el"
        "lisp"
        "clj"
        "cljs"
        "ex"
        "exs"
        "erl"
        "hrl"
        "hs"
        "ml"
        "mli"
        "fs"
        "fsx"
        "dart"
        "vue"
        "svelte"
        "astro"
        "zig"
        "nim"
        "jl"
        "proto"
        "graphql"
        "gql"
        "tf"
        "hcl"
        "nix"
        "cmake"
        # markup / docs
        "md"
        "markdown"
        "txt"
        "rst"
        "org"
        "adoc"
        "textile"
        # structured data
        "json"
        "jsonc"
        "json5"
        "xml"
        "yaml"
        "yml"
        # Minecraft
        "nbt"
        "dat"
        "dat_old"
        "mcfunction"
        "mcmeta"
      ];

      linux = [
        "text/plain"
        "text/markdown"
        "text/x-log"
        "text/csv"
        "text/tab-separated-values"
        "text/x-lua"
        "text/rust"
        "text/x-go"
        "text/x-patch"
        "text/x-tex"
        "text/x-python"
        "text/x-python2"
        "text/x-python3"
        "text/x-csrc"
        "text/x-chdr"
        "text/x-c++src"
        "text/x-c++hdr"
        "text/x-matlab"
        "text/x-objcsrc"
        "text/x-objc++src"
        "text/x-csharp"
        "text/x-lex"
        "text/x-yacc"
        "text/x-shellscript"
        "text/x-emacs-lisp"
        "text/x-common-lisp"
        "text/x-elixir"
        "text/x-erlang"
        "text/x-haskell"
        "text/x-ocaml"
        "text/x-nim"
        "text/julia"
        "text/x-nix"
        "text/x-cmake"
        "text/x-rst"
        "text/org"
        "application/toml"
        "application/typescript"
        "application/sql"
        "application/x-ruby"
        "application/x-perl"
        "application/x-php"
        "application/x-fishscript"
        "application/x-powershell"
        "application/x-bat"
        "application/vnd.dart"
        "application/json"
        "application/json5"
        "application/xml"
        "application/yaml"
        "application/x-minecraft-nbt"
      ];
    };

    intellij = {
      bundleId = "com.jetbrains.intellij";
      macApp = "IntelliJ IDEA.app";
      desktop = "intellij-idea.desktop";

      # JVM languages (Minecraft modding).
      macExtensions = [
        "java"
        "kt"
        "kts"
        "scala"
        "gradle"
        "groovy"
      ];

      linux = [
        "text/x-java"
        "text/x-kotlin"
        "text/x-scala"
        "text/x-gradle"
        "text/x-groovy"
      ];
    };

    mpv = {
      bundleId = "io.mpv";
      macApp = "mpv.app";
      desktop = "mpv.desktop";

      macUtis = [
        "public.movie"
        "public.mpeg-4"
        "public.mpeg"
        "public.avi"
        "com.apple.quicktime-movie"
        "org.matroska.mkv"
        "org.webmproject.webm"
        "com.microsoft.windows-media-wmv"
      ];
      macExtensions = [
        "mp4"
        "m4v"
        "mkv"
        "webm"
        "avi"
        "mov"
        "flv"
        "wmv"
        "mpg"
        "mpeg"
        "m2ts"
        "ogv"
        "3gp"
        "vob"
      ];

      linux = [ "video/*" ];
    };
  };

  # Linux-only: shared-mime-info has no type for these extensions, so declare
  # them (installed via home.packages so `xdg.mime.enable` picks them up), and
  # XDG can then associate the files.
  linuxExtraMime = [
    {
      mimeType = "application/x-minecraft-nbt";
      comment = "Minecraft NBT data";
      extensions = [
        "nbt"
        "dat"
        "dat_old"
      ];
    }
    {
      mimeType = "text/x-kotlin";
      comment = "Kotlin source";
      extensions = [ "kts" ];
    }
    {
      mimeType = "text/x-lex";
      comment = "Lex/Flex source";
      extensions = [
        "l"
        "lex"
        "flex"
      ];
    }
    {
      mimeType = "text/x-yacc";
      comment = "Yacc/Bison source";
      extensions = [
        "y"
        "yacc"
        "yy"
      ];
    }
    {
      mimeType = "text/plain";
      comment = "Plain text";
      extensions = [
        "cfg"
        "conf"
        "ini"
        "env"
        "properties"
        "swift"
        "bash"
        "zsh"
        "r"
        "vim"
        "clj"
        "cljs"
        "hrl"
        "fs"
        "fsx"
        "vue"
        "svelte"
        "astro"
        "zig"
        "proto"
        "graphql"
        "gql"
        "tf"
        "hcl"
        "adoc"
        "textile"
        "jsonc"
        "tsx"
        "mcfunction"
        "mcmeta"
      ];
    }
  ];
}
