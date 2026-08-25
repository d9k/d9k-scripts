# https://stackoverflow.com/questions/70597365/require-once-for-bash-but-how-to-for-older-bash-and-posix-shell/70610357#70610357
if [[ -z "${SOURCE_ONCE_INC_LOADED}" ]]; then
    SOURCE_ONCE_INC_LOADED=1

    source_once() {
        local SCRIPT CANONICAL VARNAME VAL
        for SCRIPT in "$@"; do
            if CANONICAL=$(readlink -f -- "$SCRIPT") && [[ -r "$CANONICAL" ]]; then
                VARNAME=$(printf '__REQUIRED__%s' "${CANONICAL//[^[:alnum:]]/__}")
                VAL=$(eval "echo \$$VARNAME")
                if [[ -z $VAL ]]; then
                    eval "$VARNAME=1"
                    . "$CANONICAL"
                else
                    :
                    # echo "\"$CANONICAL\" Already included" >&2
                fi
            fi
        done
    }
else
    :
    # echo "inc/source_once.inc.sh Already included" >&2
fi
