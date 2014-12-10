#!/bin/bash
#-----------------------
# Scriptps for
#
while :
do
#
Timetemp='%H%M%S'
Time=$(date +"${Timetemp}")
DATE=$(date +"%d-%m-%Y")
Now=$(date +"%y%m%d")
Num=0
Path="/opt/autoban"
MAILMESSAGE="/tmp/ip_block_temp.txt"
MAILTO="admin@domain.com"
SUBJECT="Blocked IP"
IPT=`which iptables`
SPAMLIST="blockedip"
SPAMDROPMSG3="AUTO BLOCKED IP"
blocklist="$Path/blacklist.txt"
whitelist="$Path/whitelistips.txt"
logfile=/var/log/nginx/access.log
rule1="signature 1"
rule2="signature 1"
maxconn=1
numlinelog=100

if [ ! -f /tmp/ip_block_temp.txt ]
then
touch /tmp/ip_block_temp.txt
fi

[ -f $blocklist ] && BADIPS=$(egrep -v -E "^#|^$" $blocklist)
[ -f $whitelist ] && ALLOWIPS=$(egrep -v -E "^#|^$" $whitelist)

#remove duplicate IP
sort $blocklist| uniq -c|sort -n|awk {'print $2'} > $blocklist.temp; cat $blocklist.temp > $blocklist

if [ ! -d $Path/$Now ]
   then
   mkdir $Path/$Now
fi

tail -$numlinelog $logfile |grep "$rule1"|grep "$rule2"| awk {'print $1'}|sort| uniq -c|sort -n > $Path/$Now/$Time.txt

while IFS=" " read -r f1 f2
do
        if [ $f1 -gt $maxconn ]
        then

                for ip in $BADIPS
                do
                    if [ "$ip" = "$f2" ]
                    then
                        Num=1
                        break
                    else
                        for ip2 in $ALLOWIPS
                        do
                            if [ "$ip2" = "$f2" ]
                            then
                                Num=1
                                break
                            fi
                        done
                    fi
                                    done
                    if [ $Num -eq 0 ]
                    then
                        echo "" > $MAILMESSAGE
                        echo "date & time : $DATE & $Time" >> $MAILMESSAGE
                        echo "IP $f2 is blocked" >> $MAILMESSAGE
                        /bin/mail -s "$SUBJECT" "$MAILTO" < $MAILMESSAGE
                        echo $f2 >> $blocklist # Save to blacklist
                        # block ip with iptables
                        $IPT -A $SPAMLIST -s $f2 -j LOG --log-prefix "$SPAMDROPMSG"
                        $IPT -A $SPAMLIST -s $f2 -j DROP
                    fi
        fi

done < "$Path/$Now/$Time.txt"
sleep 5

done
