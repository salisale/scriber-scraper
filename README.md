# scriber-scraper

Scrape all articles by a contributor from the subscription-only archive of a certain popular Publisher. Valid input is contributor's *homepage URL*, not, for example, a search result page of the contributor's name in the archive.

Output is a folder with:
- Index.html which is the contributor's homepage - a duplicate of its online counterpart - the broken article links in each html file are made to work (contributor's articles only; other links are broken; bright side is no animated Publisher's ads to distract!).
- Downloaded articles in html format

Run
```
$ sh grabcontributor.sh homepage-url
```
