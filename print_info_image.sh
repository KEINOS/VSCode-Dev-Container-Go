#!/bin/bash
# =============================================================================
#  This script simply prints the information of the image
# =============================================================================

echo '==============================================================================='
echo ' OS Info'
echo '==============================================================================='
cat /etc/os-release

echo '==============================================================================='
echo ' Program Lang Info'
echo '==============================================================================='
go version
python --version
python3 --version
echo -n "node.js " && node --version
perl -e 'print "Perl version : $V\n"'

echo '==============================================================================='
echo ' Installed Go packages'
echo '==============================================================================='
ls -1A "/go/bin"

echo '==============================================================================='
echo ' Installed apt packages'
echo '==============================================================================='
result="$(sudo dpkg -l)"
echo "$result" | tail -n +4
