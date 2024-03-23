is_installed() {
  type "$1" > /dev/null 2>&1
  return $?
}

function php-cs-fixer() {
  if [ -f ./vendor/bin/php-cs-fixer ]; then
    ./vendor/bin/php-cs-fixer $@
  else
    ~/.dotfiles/composer/vendor/bin/php-cs-fixer
  fi
}

function phpunit() {
  if [ -f ./vendor/bin/phpunit ]; then
    ./vendor/bin/php-cs-fixer $@
  else
    ~/.dotfiles/composer/vendor/bin/phpunit
  fi
}

# Aliases.
alias l='ls -alF'

alias dotfiles='cd ~/.dotfiles'

# git
alias gc!='git commit --amend'
alias gc='git commit'
alias gca!='git commit -a --amend'
alias gca='git commit -a'
alias gcav='git commit -av'
alias gcob='git checkout -b'
alias gdc='gd --cached'
alias gdc='git diff --cached'
alias gp='git push origin'
alias gpm='git push origin master'
alias gl='git log'
is_installed current_branch && alias gp='git push origin `current_branch`'
is_installed current_branch && alias gpr='git pull --rebase origin `current_branch`'
alias gpr='git pull --rebase origin'
alias gprm='git pull --rebase origin master'
alias gpu='git pull'
alias gs='git status -s'
alias gpusham='git push && pushd docroot/app-page && git push && popd && pushd docroot/single-page && git push && popd'
#alias gpush='git checkout build && git merge master && git push origin build && git checkout master'

# capistrano
alias cpd='cap production deploy'
alias csd='cap staging deploy'

# zsh
alias -s php=vim #opens php files in vim
alias -s rb=vim
alias -s ts=vim
alias -s js=vim
alias -s c=vim
alias -s cpp=vim
alias -s java=vim
alias -s gradle=vim
# $ foo.rb 
# vim => foo.rb
alias -g gp='| grep -i' #creates a global alias for grep
# $ ps ax gp ruby
# (all ruby process will be displayed)

# php
alias phpunit='./vendor/bin/phpunit'
alias behat='./vendor/bin/behat'
alias phpmd='./vendor/bin/phpmd'
alias t='[[ -f tests/phpunit.xml && ! -f phpunit.xml ]] && phpunit -c tests/phpunit.xml || phpunit'

# ruby
alias carrasco='bundle exec carrasco'
alias cap='bundle exec cap'

alias ag=$(which ag)

# conditional alias
is_installed vim.gnome && alias vim=vim.gnome
is_installed mvim      && alias vim='mvim -v'
is_installed mvim      && alias gvim='mvim -v'
is_installed gvim      && alias vim='gvim -v'
is_installed gvim      && alias gvim='gvim -v'
is_installed nvim      && alias vim=nvim

#custom individual aliases
alias py=python3
alias gpp='git pull && git push'
alias vh='vagrant halt'
#alias gri='grep --include=\*.$1 -rin $2'
function gft {
	grep -rn --include=\*.$1 $2 $3 $4 $5
}
alias ed='code .'
alias e='code'
alias flushdns='sudo systemd-resolve --flush-caches'
alias po=poweroff
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias vi=vim
alias v=vim
alias sus='systemctl suspend'
alias ls='exa'
alias l='exa -la'
alias ll='exa -l'
# alias idea=~/bin/idea
alias sail='vendor/bin/sail'
alias ghcs='gh copilot suggest -s'
