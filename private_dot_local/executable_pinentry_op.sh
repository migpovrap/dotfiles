#!/bin/sh
COMMAND="op read $OP_PIN_ITEM"

echo "OK"
while read cmd rest; do
  echo "cmd=$cmd rest=$rest" >&2
  echo "cmd=$cmd rest=$rest" >> $LOG
  case "$cmd" in
    \#*)
      echo "OK"
      ;;
    GETPIN)
      PASSPHRASE=${PASSPHRASE-`$COMMAND`}
      echo "D ${PASSPHRASE}"
      echo "OK"
      ;;
    BYE)
      echo "OK"
      exit 0
      ;;
    *)
      echo "OK"
      ;;
  esac
done
