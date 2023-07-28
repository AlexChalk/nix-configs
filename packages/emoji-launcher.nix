{ pkgs, stdenv }:
let
  gemoji = pkgs.buildRubyGem {
    pname = "gemoji";
    gemName = "gemoji";
    source.sha256 = "sha256-c0Q0Agy+lk6p0ZCGeYeXpH0joXCJLeDOVbdKpl0t3Bo=";
    type = "gem";
    version = "4.1.0";
  };
  emoji_list = stdenv.mkDerivation {
    name = "emoji_list";
    buildInputs = [ pkgs.ruby gemoji ];
    unpackPhase = "true";
    buildPhase = ''
      cat > extract_emoji.rb <<HERE
      require 'emoji'
      File.open('emoji_list.txt', 'w') do |f|
        Emoji.all.each do |e|
          f.puts(" #{e.raw} #{e.name} — #{e.description}#{(" (" + e.tags.join(", ") + ")") if e.tags.any?} #{e.category}")
        end
      end
      HERE
      ruby extract_emoji.rb
    '';
    installPhase = ''
      cp emoji_list.txt $out
    '';
  };
in
pkgs.writeScriptBin "emoji_launcher" ''
  #!${pkgs.zsh}/bin/zsh

  emoji_options() {
    cat ${emoji_list}
  }

  emoji() {
    char=$(echo -n "$1" | sed "s/^\([^ ]*\) .*/\1/")
    ${pkgs.sway}/bin/swaymsg exec -- "echo -n $char | ${pkgs.wl-clipboard}/bin/wl-copy --foreground"
  }

  CHOSEN=$(cat <(emoji_options) | ${pkgs.fzy}/bin/fzy --lines 36 | tail -n1)

  if [ -n "$CHOSEN" ]
  then
    WORD=$(echo $CHOSEN | sed "s/^[^ ]* \(.*\)/\1/g")

    emoji $WORD
  fi
''
