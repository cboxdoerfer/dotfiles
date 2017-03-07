alias u 'pacaur -Syu'
alias pac 'pacaur'

#alias ag 'ag --color-match "1;31"'

alias tm 'tmux -2 attach'

alias ag 'rg -S'

function ff
    find -maxdepth 1 -iname '*'$argv[1]'*'
end
