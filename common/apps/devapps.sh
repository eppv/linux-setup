# dev

## zed
curl -f https://zed.dev/install.sh | sh
echo "export PATH=$HOME/.local/bin:$PATH" >> $HOME/.bashrc
echo "export PATH=$HOME/.local/bin:$PATH" >> $HOME/.zshrc

## uv
curl -LsSf https://astral.sh/uv/install.sh | sh

## rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

## oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

## oh-my-zsh-plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# TODO: add plugins to .zshrc

## powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
# TODO: install fonts
# TODO: set theme in .zshrc
