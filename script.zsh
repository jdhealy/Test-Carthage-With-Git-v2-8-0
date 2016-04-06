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
# Modify Formula to have `brew` replace `script/bootstrap`.
local carthage_formula="$(curl https://raw.githubusercontent.com/Homebrew/homebrew-core/34f5ceb96bc2c1e13ab04911bfb5927d902b6054/Formula/carthage.rb)"
{
	for line in ${(f)carthage_formula}; do
		[[ ${line} =~ 'prefix_install' ]] &&
		cat <<-EOF
			File.open('script/bootstrap', 'w') do |out|
				out << ("#!/bin/bash\n" + "git submodule update --init --recursive")
			end
		EOF

		print -r ${line}
	done
} | tee ${here}/carthage.rb

brew install --verbose --build-from-source --HEAD ${here}/carthage.rb

# - - -

unset ERR_RETURN

which git
git --version

which carthage
carthage version

echo 'github "jdhealy/PrettyColors" == 3.0.2' >! Cartfile
carthage bootstrap --no-build || carthage bootstrap --verbose --no-build
