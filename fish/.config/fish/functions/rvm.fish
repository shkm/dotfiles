function rvm -d 'Ruby enVironment Manager'
  # set rvm default from ~/.ruby-version
  set -gx rvm_default (cat "$HOME/.ruby-version")

  # run RVM and capture the resulting environment
  set -l env_file (mktemp -t rvm.fish.XXXXXXXXXX)

  bash -c '[ -e ~/.rvm/scripts/rvm ] && source ~/.rvm/scripts/rvm || \
           source /usr/local/rvm/scripts/rvm; rvm "$@"; status=$?; \
           env > "$0"; exit $status' $env_file $argv

  # clear GEM_* variables
  and begin; eval ( printenv | cut -f 1 -d '=' | grep GEM_ | sed -e 's|^\(.*\)|set -ge \1; |' ); end

  # grep the rvm_* *PATH RUBY_* GEM_* variables from the captured environment
  # exclude lines with _clr and _debug
  # apply rvm_* *PATH RUBY_* GEM_* variables from the captured environment
  and eval ( \
    grep '^rvm\|^[^=]*PATH\|^RUBY_\|^GEM_' $env_file | \
    grep -v _clr | grep -v _debug | \
    sed '/^PATH/y/:/ /; s/^/set -xg /; s/=/ /; s/$/ ;/; s/(//; s/)//' \
  )

  # clean up
  rm -f $env_file
end

function __check_rvm --on-variable PWD -d 'Setup rvm on directory change'
  status --is-command-substitution; and return
  set -l git_parent (git rev-parse --show-toplevel ^ /dev/null)

  if [ $git_parent ];
    if test -s "$git_parent/.ruby-version"
      rvm reload > /dev/null
      rvm rvmrc load
    end
  else
    if [ $rvm_default != (string replace 'ruby-' '' $RUBY_VERSION) ]; or string match -r '@' $GEM_HOME
      # current ruby is not default or gemset is selected
      rvm default 1> /dev/null 2>&1
    end
  end
end
