#!/bin/bash

set -ue

THRESHOLD=60000

ddbjnew_gz_file=$1
tempfile_name=$(date +%Y%m%d%H%M%S)
tempfile=$(mktemp "$0.${tempfile_name}.XXX")
output_tsv="$0.${tempfile_name}.tsv"

zcat ${ddbjnew_gz_file} | awk -v filename=${ddbjnew_gz_file} \
	'BEGIN{acc=""; bp=0; date=""; ver=""; print "ファイル名\tアクセッション番号\t配列長\t公開日\tバージョン"} \
	/^LOCUS/ {acc=$2; bp=$3; date=$NF} \
	/^VERSION/ {ver=$2} \
	/^\/\// {print filename"\t"acc"\t"bp"\t"date"\t"ver}' \
	> ${tempfile}

count_line=$(wc -l ${tempfile} | awk '{print $1}')
if [ $count_line -eq 1 ]; then
	echo "使い方： $0 <DDBJ 公開形式 (Flat file) のgzip圧縮ファイル>"
	rm ${tempfile}
	exit 1
fi

tempfile_over_threshold="${tempfile}_over_threshold"
awk -v threshold=${THRESHOLD} '{if($3 >= threshold){print $0}}' ${tempfile} > ${tempfile_over_threshold}
count_over_threshold=$(wc -l ${tempfile_over_threshold} | awk '{print $1}')
if [ ${count_over_threshold} -eq 1 ]; then
	echo "配列長が ${THRESHOLD} 以上のエントリはありません。"
else
	cat ${tempfile_over_threshold} 
fi

mv ${tempfile} ${output_tsv}
echo "配列長一覧ファイルが作成されました。ファイル名：${output_tsv}"

rm ${tempfile_over_threshold}

