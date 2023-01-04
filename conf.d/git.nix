{ pkgs, lib, ... }:
{
  programs.git = {
    enable = true;
    delta = {
      enable = true;
    };

    userEmail = "jamie@schembri.me";
    userName = "Jamie Schembri";
    extraConfig = {
      core = {
        ignorecase = false;
        filemode = false;
      };
      status = {
        showUntrackedFiles = "all";
      };
      push = {
        default = "current";
        followTags = "true";
        autoSetupRemote = "true";
      };
      pull = {
        default = "current";
        ff = "only";
        rebase = true;
      };
      init = {
        defaultBranch = "main";
      };
      rerere = {
        enabled = true;
      };
    };
    aliases = {
      a = "add";
      aa = "add -A";
      ac = "!git add -A && git commit";
      acm = "!git add -A && git commit -m";
      b = "for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'";
      bd = "branch -d";
      bD = "branch -D";
      bmv = "branch -m";
      c = "commit";
      cm  = "commit -m";
      ca  = "commit --amend";
      can  = "commit --amend --no-edit";
      cl = "clone";
      co = "checkout";
      cob = "checkout -b";
      cobf = "!f() { git checkout -b \"feature/$1\"; }; f";
      cobc = "!f() { git checkout -b \"chore/$1\"; }; f";
      cobb = "!f() { git checkout -b \"bug/$1\"; }; f";
      cf = "!f() { git checkout \"feature/$1\"; }; f";
      cc = "!f() { git checkout \"chore/$1\"; }; f";
      cb = "!f() { git checkout \"bug/$1\"; }; f";
      cp = "cherry-pick";
      d = "diff";
      dc = "diff --cached";
      dh = "diff HEAD";
      d1 = "diff HEAD^";
      d2 = "diff HEAD^^";
      do = "!f() { git remote set-head origin -a && git diff origin/HEAD; }; f";
      dt = "difftool";
      dta = "difftool --dir-diff";
      i  = "init";
      ld = "!f() { BRANCH=$(git rev-parse --abbrev-ref HEAD); git log origin/$BRANCH..$BRANCH --oneline; }; f";
      lf = "log -u";
      lg = "log --stat --color";
      lt = "log --graph --decorate --pretty=oneline --abbrev-commit";
      ll = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all";
      ls = "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
      mt = "mergetool";
      mc = "merge --continue";
      ma = "merge --abort";
      pf = "push -u --force-with-lease";
      pu = "push -u";
      prune = "fetch --prune";
      s = "status -sbu";
      sh = "show";
      staged = "diff --name-only --cached";
      stash-all = "stash save --include-untracked";
      r = "rebase";
      rc = "rebase --continue";
      ra = "rebase --abort";
      rev = "rev-parse HEAD";
      rs   = "reset";
      rs1  = "reset HEAD^";
      rs2  = "reset HEAD^^";
      rsh  = "reset --hard";
      rsh1 = "reset HEAD^ --hard";
      rsh2 = "reset HEAD^^ --hard";
      uncommit = "reset --soft HEAD^";
    };
    ignores = [
      ".secrets"
      "*.gpg"
      ".in"
      "*.com"
      "*.class"
      "*.dll"
      "*.exe"
      "*.o"
      "*.so"
      "*.7z"
      "*.dmg"
      "*.gz"
      "*.iso"
      "*.jar"
      "*.rar"
      "*.tar"
      "*.zip"
      "*.log"
      "*.sublime-project"
      "*.sublime-workspace"
      "*.project"
      "*.idea"
      "*~"
      ".netrwhist"
      "Session.vim"
      ".projectile"
      ".sass-cache"
      ".rubocop-https*yml"
      ".vagrant/"
      ".solargraph.yml"
      "tags"
      "gemtags"
      "TAGS"
      "node_modules"
      "coverage/"
      ".yardoc/"
      ".tool-versions"
      ".solargraph-rails"
      "*.orig"
      ".irb_history"
      ".byebug_history"
      "GPATH"
      "GRTAGS"
      "GTAGS"
      ".DS_Store"
      ".DS_Store?"
      "._*"
      ".Spotlight-V100"
      ".Trashes"
      "Icon"
      "thumbs.db"
      "Thumbs.db"
      ".dropbox"
      ".gems"
      "tasks.json"
      "docker-compose.override.yml"
      ".direnv/"
    ];
  };

  # programs.fish = {
  #   # enable = true;
  #   plugins = with pkgs.fishPlugins; [
  #     fzf-fish
  #     hydro
  #   ];
  # };
}
