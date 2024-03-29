{ config, pkgs, ... }:

{
  users.mutableUsers = false;
  users.users.root.hashedPassword = null;
  users.users.duponin = {
    hashedPassword = "$6$rounds=1000000$zAHPVBW6.Thy4QDB$tIerV7h.tue8K/TiSJWZMi2tD51uVGsg3NQW0DKKS8RiSdBVJJpSfhmR9diX3kWlbM8V/hSwKj2ZfZLYXuaVt0";
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Duponin";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJh6W2o61dlOIcBXeWRhXWSYD/W8FDVf3/p4FNfL2L6p duponin@rilakkuma"
    ];
    packages = with pkgs; [
      firefox
      vim
      vscodium
      tdesktop
      element-desktop
      evolution

      cura
      freecad

      # Doom Emacs
      ripgrep coreutils fd clang python3
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.duponin = {
      home.stateVersion = "22.05";
        programs.emacs.enable = true;
        services.emacs = {
          enable = true;
          defaultEditor = false;
          client.enable = true;
        };
        programs.git = {
          enable = true;
          package = pkgs.gitFull;
          userName = "duponin";
          userEmail = "duponin@locahlo.st";
          delta.enable = true;
          extraConfig.pull.ff = "only";
        };
        programs.direnv = {
          enable = true;
          nix-direnv.enable = true;
        };
        programs.zsh = {
          enable = true;
          enableAutosuggestions = true;
          enableCompletion = true;
          enableSyntaxHighlighting = true;
          autocd = true;

          history.extended = true;

          oh-my-zsh.enable = true;
          oh-my-zsh.theme = "ys";

          shellAliases = {
            ":q" = "echo 'You are not in Vim, you stupid...'";
            df = "df -h";
            du = "du -h";
            ezsh = "echo 'Reloading ZSH...' && exec zsh";
            free = "free -h";
            history = "history -i";
            meteo = "curl http://wttr.in/$CITY";
            meteoo = "curl http://v2.wttr.in/$CITY";
            miex = "iex -S mix";
            mips = "mix phx.server";
            mpnv = "mpv --no-video";
            nsl = "nix-shell";
            ssh-proxy = "ssh -D 1080 -q -C -N";
          };
          envExtra = ''
            COMPLETION_WAITING_DOTS="true"
            ENABLE_CORRECTION="true"
            ERL_AFLAGS="-kernel shell_history enabled"
            OPENER=$EDITOR
          '';
          initExtra = ''
            #if [[ "$(ssh-add -l)" = "The agent has no identities." ]]; then ssh-add; fi

            mkcd ()
            {
                mkdir -p $1 && cd $1
            }
          '';
        };
        programs.tmux.enable = true;
        programs.neovim = {
          enable = true;
          viAlias = true;
          vimAlias = true;
          vimdiffAlias = true;
        };
     };
  };
}
