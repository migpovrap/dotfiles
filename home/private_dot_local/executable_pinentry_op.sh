#!/bin/sh
# pinentry for gpg-agent: hands the GPG passphrase from 1Password to gpg.
# The op:// reference is a pointer, not a secret, so it is hardcoded on purpose.
# No logging, no temp files, no caching: gpg-agent owns the cache.
set -u

OP_ITEM='op://Personal/GPGKey/password'

OP_BIN=/opt/homebrew/bin/op
if [ ! -x "$OP_BIN" ]; then
  OP_BIN=$(command -v op 2>/dev/null || true)
fi

escape() {
  printf '%s' "$1" | sed -e 's/%/%25/g'
}

printf 'OK Pleased to meet you\n'

while IFS= read -r line; do
  case "${line%% *}" in
    GETPIN)
      if [ -n "$OP_BIN" ] && pin=$("$OP_BIN" read "$OP_ITEM" 2>/dev/null) && [ -n "$pin" ]; then
        printf 'D %s\nOK\n' "$(escape "$pin")"
      else
        printf 'ERR 83886179 Operation cancelled\n'
      fi
      ;;
    BYE)
      printf 'OK\n'
      exit 0
      ;;
    *)
      printf 'OK\n'
      ;;
  esac
done
