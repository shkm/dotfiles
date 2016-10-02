# Dotfiles

## Summary

These are my dotfiles. They were created using the [bare git repo method](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/) (though I've opted for ~/.dotfiles over ~/.cfg) in order to sidestep the whole symlink nonsense. 

## Requirements

- git

## Installation

There's a simple init script available for MacOS. I haven't had the chance to test this yet, but it should set up the basics.

```
curl -s https://raw.githubusercontent.com/shkm/dotfiles/master/scripts/init_mac.sh | bash -s
```

## Additional thoughts

- Consider writing a snippet to pull these down for the first time, as described in the article above.
- An init script can still be useful, particularly for default OS settings. Perhaps that's something for another repo, though?

