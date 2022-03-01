# zsh configs

zsh configs i want to keep around. included:

- input configs to make the terminal editor act more like a modern text editor (applied from [here](https://stackoverflow.com/a/68987551))
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [lazygit lg()](https://github.com/jesseduffield/lazygit#changing-directory-on-exit)

requires [antigen](https://github.com/zsh-users/antigen/) and [powerlevel10k](https://github.com/romkatv/powerlevel10k).

since i'd rather use ctrl+c as a hotkey for copying, ctrl+c can be rebound using this command in .bashrc (fails in .zshrc):

> stty intr \\^d

pbcopy/pbpaste for WSL: [Link](https://www.techtronic.us/pbcopy-pbpaste-for-wsl/)

