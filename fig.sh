#!/usr/bin/env bash

if ([[ -d /Applications/Fig.app ]] || [[ -d ~/Applications/Fig.app ]]) \
  && [[ ! "${TERMINAL_EMULATOR}" = JetBrains-JediTerm ]] \
  && command -v fig 1> /dev/null 2> /dev/null; then

  if [[ -t 1 ]] && ([[ -z "${FIG_ENV_VAR}" ]] \
            || [[ -n "${TMUX}" ]] \
            || [[ "${TERM_PROGRAM}" = vscode ]]); then
    export FIG_ENV_VAR=1

    # Gives fig context for cwd in each window
    export TTY=$(tty)
    fig bg:init "$$" "$TTY"

    # Check for prompts or onboarding must be last, so Fig has context for
    # onboarding!
    [[ -s ~/.fig/tools/prompts.sh ]] && source ~/.fig/tools/prompts.sh
  fi

  # We use a shell variable to make sure this doesn't load twice
  if [[ -z "${FIG_SHELL_VAR}" ]]; then
    source ~/.fig/shell/post.sh
    FIG_SHELL_VAR=1
  fi

  # todo: Add a check to confirm "add-zle-hook-widget" facility exists
  # Not included in fig.zsh, because should be run last
  if [[ -n "${ZSH_NAME}" ]]; then
    source ~/.fig/shell/zle.zsh
  fi
fi
