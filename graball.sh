#!/bin/bash

siteURL='https://www.lrb.co.uk'
indexURL="${siteURL}/contributors"
folder='archive'
contributor_index='contributors_broken.html' 
contributor_index_final='contributors.html'
contributor_file='all_contributors.txt' # all links to download

######### GET CONTRIBUTORS ##########	

mkdir -pv -m 777 $folder
cd $folder

curl $indexURL > $contributor_index # get contributors' page

# grab all links to contributor's homepage [A-Z]
cat $contributor_index | grep -E "^<li><a href=\"/contributors.*$" | cut -d'"' -f2 > $contributor_file

############ DOWNLOAD ############

for link in `cat $contributor_file` ; do # this takes about 8.30 hours
	echo "articles in ${link} are being downloaded..."
	sh "../grabcontributor.sh" "${siteURL}${link}" # download
done

######### ORGANISE FOLDERS ##########

for x in {a..z} ; do
	upperx=$(echo ${x} | tr '[:lower:]' '[:upper:]') # make uppercase
	mkdir $upperx # make folders A-Z
done

for folder_name in `ls -d */`; do
	if [ ${#folder_name} -ge 2 ]; then # target folders to move
		lname_letter=$(echo ${folder_name} | cut -d'-' -f2 | cut -c1 | tr a-z A-Z)
		mv ${folder_name} ${lname_letter}/${folder_name} 
		echo "moving ${folder_name} to ${lname_letter}"
	fi
done 

##### FIX LINKS IN CONTRIBUTORS ARCHIVE PAGE #####

patternfile='patterns.sed'

echo "replacing broken links in contributor index..."

for line in `cat $contributor_index| grep -E "^<li><a href=\"\/contributors.*$" | cut -d '"' -f 2` ; do
	prefix="$(echo $line | cut -d'/' -f3 | cut -d'-' -f2 | cut -c1 | tr a-z A-Z)"
	to_replace="$(echo ${line} | cut -d'/' -f3 | sed -e 's/$/\\\/Index.html/' | sed -e "s|^|.\\\/${prefix}\\\/|")"
	found="$(echo $line | sed 's|/|\\\/|g')"
	echo "s/${found}/${to_replace}/" >> $patternfile
done

sed -f $patternfile $contributor_index > $contributor_index_final # replace and write to new file

rm -f $contributor_index # delete temp index file
rm -f $patternfile # delete pattern file

echo "done ya."
