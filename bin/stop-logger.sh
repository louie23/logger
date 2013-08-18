#!/bin/sh
#
# logger bot start script
#
#   This program is free software; you can redistribute it and/or
#   modify it under the terms of the GNU General Public License
#   as published by the Free Software Foundation; either version 2
#   of the License, or (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
#
# See http://www.gnu.org/copyleft/gpl.html

baseDir=/home/tcffm/logger
botName=tcffm_logger_bot
admin_password=change-to-your-admin-password
channel_URI=irc://irc.freenode.net/tcffm
channel_title="TCFFM"
logDir=$baseDir/logs/
log_URI=https://tcffm.rr.nu:4443/irclog/tcffm/

start() {
	mkdir -p $logDir
	$baseDir/bin/logger -html --nick $botName $admin_password $channel_URI $channel_title $logDir $log_URI > $logDir/logger-out.log 2> $logDir/logger-err.log &
}

stop() {
	kill $(cat $logDir/logger-tcffm.pid)
}

action=$(basename $0 | awk -F"-" '{print $1}')

case $action in
	start)
		start
		;;
	stop)
		stop
		;;
esac
