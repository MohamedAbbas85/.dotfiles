#! /bin/bash
# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh

wget -O ~/git-prompt.sh  https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

grep -qxF "source ~/git-prompt.sh" ~/.bashrc || echo "source ~/git-prompt.sh" >> ~/.bashrc
grep -qxF "source ~/scripts/git-prompt-config.sh" ~/.bashrc || echo "source ~/scripts/git-prompt-config.sh" >> ~/.bashrc



