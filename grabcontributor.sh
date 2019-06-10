#!/bin/bash

linkfile='links.txt' # temp file; grab article links
indexfile='Index_broken.html' # temp file; with broken article links
patternfile='patterns.sed' # temp file; sed pattern file
outfile='Index.html' # with working links



if [ -z "$1" ] ; then
    echo "please enter a valid URL to/of the contributor's homepage"
    echo "example: 'sh grabcontributor.sh https://xxxxxxxx' "
    exit 1
fi

folder=$(echo $1 | cut -d'/' -f5)

mkdir -pv -m 777 $folder

cd $folder

if curl $1 > $indexfile; then # curl contributor's homepage
	echo "request to contributor's page successful"
else
	echo "request unsuccessful... is the input URL valid?"
	exit 1
fi

# grab listed links
cat $indexfile | grep -E "^<h2><a href=\"\/v.*$" | cut -d '"' -f 2 >> $linkfile

for line in `cat $linkfile` ; do
	outfname="$(cut -d '/' -f2,3,4,5 <<< ${line} | tr '/' '.')"
	echo "downloading $line"
    curl "https://www.lrb.co.uk${line}" > "${outfname}.html"
    #sleep 1
done



# start replacing broken links to address to local html files
# this replaces only article links by the contributor #

if [ -f "$patternfile" ]; then
	rm -rf $patternfile
	echo "delete existing 'patterns.sed'"
else
	echo "# sed file \n# to replace in Index.html\n" > $patternfile
fi 

echo "replacing broken links in homepage..."

for line in `cat $indexfile | grep -E "^<h2><a href=\"\/v.*$" | cut -d '"' -f 2` ; do
	to_replace="$(echo ${line} | sed 's/\///' | tr '/' '.' | sed -e 's/$/.html/')"
	#echo $line # v09/n09/john-lanchester/as-a-returning-lord
	#echo $to_replace # v09.n09.john-lanchester.as-a-returning-lord.html
	found="$(echo $line | sed 's|/|\\\/|g')"
	#echo $found # \/v09\/n09\/john-lanchester\/as-a-returning-lord
	echo "s/${found}/${to_replace}/" >> $patternfile
done

sed -f $patternfile $indexfile > $outfile # replace and write to new file

rm -f $indexfile # delete temp index file
rm -f $patternfile # delete pattern file
rm -f $linkfile # delete links file

echo "done."
