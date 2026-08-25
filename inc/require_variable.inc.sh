function require_variable { VAR_NAME="$1"
  VAL="${!VAR_NAME}"

  if [[ -z "$VAL" ]]; then
    echoerr "Error: please set required variable:"
    echoerr
    echoerr "$VAR_NAME="
    exit 1
  fi
}
