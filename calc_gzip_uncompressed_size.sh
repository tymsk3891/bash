#!/bin/bash

set -ue

gzip_file=$1

if [ -e ${gzip_file} ]; then
	compressed_size=$(gzip -l ${gzip_file} | awk '{print $1}' | tail -1)
	uncompressed_size=$(gzip -dc ${gzip_file} | wc -c)
	raito=$(awk -v comp=${compressed_size} -v uncomp=${uncompressed_size} 'BEGIN{print 1-(comp/uncomp)}')
	uncompressed_name=$(echo ${gzip_file} | sed -e 's/.gz//g')
	echo -e "compressed\tuncompressed\tratio\tuncompressed_name"
	echo -e "${compressed_size}\t${uncompressed_size}\t${raito}\t${uncompressed_name}"
fi

