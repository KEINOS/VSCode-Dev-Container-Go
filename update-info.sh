#!/bin/bash
# =============================================================================
#  イメージに含まれているパッケージなどの情報をファイルに出力します。
# =============================================================================

NAME_TAG_IMG='test:local'
NAME_FILE_INFO='image_info.txt'
PATH_FILE_INFO="./${NAME_FILE_INFO}"

docker build -t "$NAME_TAG_IMG" .

# 初期化
rm -f "$PATH_FILE_INFO"

result=$(docker run --rm "$NAME_TAG_IMG" /bin/bash -c 'ls -1A "/go/bin"')
echo '===============================================================================' >> "$PATH_FILE_INFO"
echo ' Installed go packages' >> "$PATH_FILE_INFO"
echo '===============================================================================' >> "$PATH_FILE_INFO"
echo "$result" >> "$PATH_FILE_INFO"
echo >> "$PATH_FILE_INFO"

result=$(docker run --rm "$NAME_TAG_IMG" /bin/bash -c "sudo dpkg -l")
echo '===============================================================================' >> "$PATH_FILE_INFO"
echo ' Installed apt packages' >> "$PATH_FILE_INFO"
echo '===============================================================================' >> "$PATH_FILE_INFO"
echo "$result" | tail -n +4 >> "$PATH_FILE_INFO"
echo >> "$PATH_FILE_INFO"
