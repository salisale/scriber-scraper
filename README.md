# Scriber Scraper

### grabcontributor.sh

Scrape all articles by a contributor from the subscription-only archive of a certain popular Publisher. Valid input is contributor's *homepage URL*, not, for example, a search result page of the contributor's name in the archive.

Output is a folder with:
- Index.html which is the contributor's homepage - a duplicate of its online counterpart - the broken article links in each html file are made to work (contributor's articles only; other links are broken; bright side is no animated Publisher's ads to distract!).
- Downloaded articles in html format

Run
```
$ sh grabcontributor.sh homepage-url
```



### graball.sh (UPDATE: June 14, 2019)

To download the entire archive, place both scripts in the same folder and simply run:
```
$ sh graball.sh
```

Output File Structure
```

|
└──graball.sh
└──grabcontributor.sh
└──archive
   │   contributors.html # archive by contributors homepage
   │   all_contributors.txt # relative links to their homepage    
   │ 
   └───A
   │   │
   │   └───aaron-aloman
   │   |    │   Index.html # their homepage
   │   |    │   xx/xx/aaron-aloman/article-one.html
   │   |    │   xx/xx/aaron-aloman/article-two.html
   │   |    │   ...
   │   └───aj-ayer
   │   |    │   Index.html # their homepage
   │   |    │   xx/xx/aj-ayer/article-one.html
   │   |    │   ...
   └───B
   │   └───alan-blowhard
   │   |    │   Index.html # their homepage
   │   |    │   ...
```

Note that 
- downloading the entire archive takes roughly 8.30 hours and takes up ~900 MB of space
- there are <10 html files from a few contributors with "deformed" url; do whatever you wish with these
- not all the embedded links work (the side panels or menu bars), but it is serviceable and the pages sufficiently navigable
