目錄結構：


/home/tcffm/logger                  原始碼所在地

/home/tcffm/logs                    記錄檔位置

/var/www/irclog/tcffm               記錄檔位置（在 web server 底下的位置，是從 /home/tcffm/logs soft link 過來的）

/var/www/irclog/indexes             索引檔所在目錄

/var/www/irclog/indexes/tcffm       給 search.pl 使用的索引檔（search.pl 並不是直接從原始記錄檔去搜尋，而是事先從 cron 去建立索引檔，然後 search.pl 直接從索引檔搜尋）

/var/www/style/                     css style 目錄

/var/www/style/stylesheet.css       css style 檔案（從原作者網頁抓回來的）

/var/www/style/old.css              css style 檔案（從原作者網頁抓回來的）

/var/www/images/rdf.png             rdf png 圖檔（從原作者網頁抓回來的）




安裝步驟：


新增一個 tcffm 使用者:

$ adduser tcffm


切換到 tcffm 使用者身份:

$ sudo su - tcffm


從 github 下載原始碼:

$ git clone https://github.com/louie23/logger

$ cd logger


建立 tcffm branch:

$ git checkout -b tcffm


取回 tcffm branch 原始碼:

$ git pull origin tcffm


建立記錄檔的目錄：

$ mkdir /home/tcffm/logs/irc.freenode.net:6667/tcffm/


並將記錄檔目錄的最下層連結到 web server 底下：

$ cd /var/www

$ sudo mkdir irclog

$ cd irclog

$ sudo ln -sf /home/tcffm/logs/irc.freenode.net:6667/tcffm/  .



這時可以啟動 logger:

$ /home/tcffm/logger/bin/start-logger.sh


停止 logger: (這檔案和 start-logger.sh 是一模一樣的，靠檔名分辨啟動或停止)

$ /home/tcffm/logger/bin/stop-logger.sh


執行 indexly (將 html 轉成比較容易閱讀格式，放在 cron 每5分鐘跑一次):

$ /home/tcffm/logger/bin/indexly --all


建立年份及月份的索引頁面：（放在 cron 每5分鐘跑一次):

$ /home/tcffm/logger/bin/rebuild-indexes /var/www/irclog/tcffm/ https://tcffm.rr.nu:4443/irclog/tcffm


建立搜尋索引: (建立好的索引提供 search.pl 使用，放在 cron 每天跑一次）

$ sudo mkdir /var/www/irclog/indexes

$ sudo chown tcffm /var/www/irclog/indexes

$ build-search-indexes tcffm

產生索引資料檔（索引中只有今天之前，但不包含今天的資料）

/var/www/irclog/indexes/tcffm


將 search.pl 就定位：（並改名成 search)

$ sudo cp -p search.pl /usr/lib/cgi-bin/search


可以開啟瀏覽器來測試搜尋功能：

$ firefox https://your.site/cgi-bin/search




底下是所有必需要放在 cron 中執行的指令：


$ sudo vi /etc/cron.d/logger

*/5 * * * *      tcffm    /home/tcffm/logger/bin/indexly --all 2> /home/tcffm/logs/indexly.cron.log

6 0 * * *      tcffm    /home/tcffm/logger/bin/build-search-indexes tcffm

*/5 0 * * *      tcffm    /home/tcffm/logger/bin/rebuild-indexes /var/www/irclog/tcffm/ https://tcffm.rr.nu:4443/irclog/tcffm 2> /home/tcffm/logs/rebuild-index.cron.log

*/5 * * * *      tcffm    /home/tcffm/start-link-latest-html
