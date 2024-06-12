{ config, pkgs, ... }:
let 
  myAliases ={
    upgrade-system = "sudo nixos-rebuild switch --flake ~/.nixfiles";
    upgrade-home = "home-manager switch --flake ~/.nixfiles";
    update-pkgs = "cd ~/.nixfiles && sudo nix flake update && cd";
    upgrade = "cd ~/.nixfiles && sudo nix flake update && cd && home-manager switch --flake ~/.nixfiles && sudo nixos-rebuild switch --flake ~/.nixfiles";
    clean-home = "nix-collect-garbage -d";
    clean-system = "sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
    psql-u ="sudo -u postgres psql";
    connect-ec2 = "ssh -i ~/.ssh/i-keys.pem ubuntu@ec2-3-76-209-240.eu-central-1.compute.amazonaws.com";
    connect-contabo-prod = "ssh root@144.91.119.192";
    connect-contabo-test = "ssh root@84.247.133.143";
    build-logs-app="npm run build && git add . && git commit -m 'update' && git push && connect-contabo-prod sh update_logger.sh";
  };

in
{

  home.username = "muiga";
  home.homeDirectory = "/home/muiga";
    # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
 
];

  # Home Manager is pretty good at managing nixfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'nixfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = nixfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/muiga/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.git = {
    enable = true;
    userName  = "muiga";
    userEmail = "muigask@gmail.com";
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    dotDir = ".config/zsh";
    shellAliases = myAliases;
    initExtra = '' 
       export PATH=$PATH:${pkgs.oh-my-posh}/bin
       eval "$(oh-my-posh init zsh --config ~/.nixfiles/oh-my-posh/zen.toml)"
    '';
    # histSize = 10000;
    # histFile = "${config.xdg.dataHome}/zsh/history";    
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "24.05"; # Please read the comment before changing.

}
