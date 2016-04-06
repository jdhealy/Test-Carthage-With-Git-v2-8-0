#!/usr/bin/env zsh

set ERR_RETURN

local here=$(dirname $0)

preexec-print() { print -n '• '; print $2 }
autoload -U add-zsh-hook
add-zsh-hook preexec preexec-print # print all our commands from here-on-out

# - - -

brew uninstall --force `# uninstall multiple versions` git
# download Formula for Git 2.8.0
curl https://raw.githubusercontent.com/Homebrew/homebrew-core/a128b97c6e57e62ca7281043e6b37d88c8250730/Formula/git.rb >! ${here}/git.rb
brew install ${here}/git.rb # install from bottle

brew uninstall --force `# uninstall multiple versions` carthage
# download Formula for Carthage tag `v0.15.2`
curl https://raw.githubusercontent.com/Homebrew/homebrew-core/34f5ceb96bc2c1e13ab04911bfb5927d902b6054/Formula/carthage.rb >! ${here}/carthage.rb
brew install --verbose --build-from-source --HEAD ${here}/carthage.rb

# - - -

unset ERR_RETURN

which git
git --version

which carthage
carthage version

echo 'github "jdhealy/PrettyColors" == 3.0.2' >! Cartfile
carthage bootstrap --no-build || carthage bootstrap --verbose --no-build
