#!/bin/bash

html_email_tmp_file='html_email_'`date +%Y%m%d%m`
echo $html_email_tmp_file
echo "FROM:sameer.samant@org.com" > $html_email_tmp_file
echo "TO:mgctsk@cutradition.com" >> $html_email_tmp_file
echo "Subject: Pull Request Status | `date` " >> $html_email_tmp_file
echo "Content-type: text/html" >> $html_email_tmp_file
echo "<HTML>" >> $html_email_tmp_file
echo "<BODY>" >> $html_email_tmp_file
echo "<TABLE BORDER=1 CELLPADDING=10 CELLSPACING=0>" >> $html_email_tmp_file
echo "<TR BGCOLOR=17202A>" >> $html_email_tmp_file
echo "<TD ALIGN=CENTER CELLPADDING=5><FONT COLOR=WHITE><B>PR NAME</B></FONT></TD>" >> $html_email_tmp_file
echo "<TD ALIGN=CENTER CELLPADDING=5><FONT COLOR=WHITE><B>PR STATUS</B></FONT></TD>" >> $html_email_tmp_file
echo "<TD ALIGN=CENTER CELLPADDING=5><FONT COLOR=WHITE><B>PR URL</B></FONT></TD>" >> $html_email_tmp_file
echo "</TR>" >> $html_email_tmp_file

curl https://api.github.com/repos/thessandman/mycodetest/pulls?state=all > pr_data.json
>pr_data.dat
pr_count=`cat pr_data.json | grep -w 'title' | wc -l`
status=
pr_name=
pr_url=
for ((i=0; i<$pr_count; i++))
do
	cat pr_data.json | jq -r '[.['$i'].title,.['$i'].state,.['$i'].html_url] | @tsv' | tr '\t' '|' >> pr_data.dat	
done

while read line;
do
	pr_name=`echo $line | cut -d "|" -f1`
	status=`echo $line | cut -d "|" -f2`
	pr_url=`echo $line | cut -d "|" -f3`

if [[ $status = "open"  ]];
then
	status_color="RED"
else
	status_color="GREEN"
fi	



	echo "<TR>" >> $html_email_tmp_file
	echo "<TD ALIGN=CENTER>$pr_name</TD>" >> $html_email_tmp_file
	echo "<TD ALIGN=CENTER><FONT COLOR='$status_color'>$status</TD>" >> $html_email_tmp_file
	echo "<TD ALIGN=CENTER>$pr_url</TD>" >> $html_email_tmp_file
	echo "</TR>" >> $html_email_tmp_file

done < pr_data.dat
echo "</TABLE>" >> $html_email_tmp_file
echo "</BODY>" >> $html_email_tmp_file
echo "</HTML>" >> $html_email_tmp_file
cat $html_email_tmp_file | /usr/sbin/sendmail -t
rm $html_email_tmp_file
