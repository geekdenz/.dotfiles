# Autocompletition for the prodject
p() { cd ~/Projects/$1;  }
_p() { _files -W ~/Projects -/;  }
compdef _p p

# Allows commit message without typing quotes (can't have quotes in the commit msg though).
function gc {
  git commit -m "$*"
}

function gca {
  git commit -am "$*"
}

function ghc {
  REPO=$1
  git clone git@github.com:$REPO.git
}

function gri {
	grep --include=\*.$1 -rin $2 $3
}
