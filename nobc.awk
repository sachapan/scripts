# Sacha Panasuik
# sachapan@gmail.com
# This script removes blank lines and lines that begin with #
# October 19, 2021

awk '/^$/ {next} $1 !~ /#/ { print}'
