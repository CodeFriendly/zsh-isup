Installation
============
### Antigen
Add `rummik/zsh-isup` to your bundles

###
```sh
mkdir -p ~ZSH_CUSTOM/plugins
cd ~ZSH_CUSTOM/plugins
git clone git://github.com/rummik/zsh-isup.git isup
```

Optionally edit your `~/.zshrc` manually to load `isup`, or with:
```sh
sed -i 's/^plugins=(/plugins=(isup /' ~/.zshrc
```
