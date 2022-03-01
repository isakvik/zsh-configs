# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source ~/powerlevel10k/powerlevel10k.zsh-theme


source ~/.antigen/antigen.zsh

antigen bundle zsh-users/zsh-autosuggestions
antigen apply


zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

source ~/.zsh/aliases.zsh
source ~/.zsh/history.zsh
source ~/.zsh/input.zsh
source ~/.zsh/lazygit.zsh

export PATH=$HOME/bin:$PATH
export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"
