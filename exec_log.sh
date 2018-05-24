#!/bin/bash


log_file="`basename $0 .sh`.log"
err_file="`basename $0 .sh`.err"

exec 1> $log_file
exec 2> $err_file

echo "LOG"
echo 
echo "ERROR" >&2
echo 

exit 0
