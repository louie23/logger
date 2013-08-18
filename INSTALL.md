directory structure:


/home/tcffm/logger                  logger source code

/home/tcffm/logs                    log dir

/var/www/irclog/tcffm               log dir in web server, soft linked from log dir

/var/www/irclog/indexes             index dir, for search.pl

/var/www/irclog/indexes/tcffm       index file, for search.pl

/var/www/style/                     css style dir

/var/www/style/stylesheet.css       css style file, stolen from the author

/var/www/style/old.css              css style file, stolen from the author

/var/www/images/rdf.png             rdf png file, stolen from the author




start installation:


add a tcffm user:

$ adduser tcffm


switch to tcffm user:

$ sudo su - tcffm


grab source code from github:

$ git clone https://github.com/louie23/logger

$ cd logger


create tcffm branch:

$ git checkout -b tcffm


grab tcffm branch code:

$ git pull origin tcffm


prepare log dir:

$ mkdir /home/tcffm/logs/irc.freenode.net:6667/tcffm/


$ cd /var/www

$ sudo mkdir irclog

$ cd irclog

$ sudo ln -sf /home/tcffm/logs/irc.freenode.net:6667/tcffm/  .



you can now start logger:

$ /home/tcffm/logger/bin/start-logger.sh


stop logger: (the file is identical to start-logger.sh)

$ /home/tcffm/logger/bin/stop-logger.sh


run indexly (convert html file to easy reading one, in cron every 5 minutes):

$ /home/tcffm/logger/bin/indexly --all


rebuild year and month page index:

$ /home/tcffm/logger/bin/rebuild-indexes /var/www/irclog/tcffm/ https://tcffm.rr.nu:4443/irclog/tcffm


build search indexes: (for search.pl searching keyword, in cron once a day):

$ sudo mkdir /var/www/irclog/indexes

$ sudo chown tcffm /var/www/irclog/indexes


$ build-search-indexes tcffm

will generate file: (but no today's data)

/var/www/irclog/indexes/tcffm


then prepare search.pl:

$ sudo cp -p search.pl /usr/lib/cgi-bin/search


you can test with url:

$ firefox https://your.site/cgi-bin/search




run from cron:


$ sudo vi /etc/cron.d/logger

*/5 * * * *      tcffm    /home/tcffm/logger/bin/indexly --all 2> /home/tcffm/logs/indexly.cron.log

6 0 * * *      tcffm    /home/tcffm/logger/bin/build-search-indexes tcffm

*/5 0 * * *      tcffm    /home/tcffm/logger/bin/rebuild-indexes /var/www/irclog/tcffm/ https://tcffm.rr.nu:4443/irclog/tcffm 2> /home/tcffm/logs/rebuild-index.cron.log

*/5 * * * *      tcffm    /home/tcffm/start-link-latest-html
