en=$1
buildNumber=$2
planName=$3

FROM="Deployment Release Notes<DO-NOT-REPLY@anthem.com>"
TO="koteswara.samsani@anthem.com, hemanth.karumuri@anthem.com, dl-wgspegadesktop-appdev@anthem.com, dl-wgspega-desktoptesting@anthem.com, dl-solutioncentralscrummasters@anthem.com, marcy.hall@anthem.com"
SUBJECT="${en} Deployment Release Notes Build : ${buildNumber}"
ATTACH="/local_home/srcwgspg/DevOPS/Report/Build_${buildNumber}/ReleaseNotes_${en}.xls"
MAILPART="==".$(date +%d%S)."===" ## Generates Unique ID
(
echo "From: $FROM"
echo "To: $TO"
echo "Subject: $SUBJECT"
echo "MIME-Version: 1.0"
echo "Content-Type: multipart/mixed; boundary=\"$MAILPART\""
echo ""
echo "--$MAILPART"
echo "Content-Type: text/html"
echo "Content-Disposition: inline"
echo ""
echo "<b>Build Plan : ${planName}</b>"
echo "<br>"
echo "<b>Build Number : ${buildNumber}</b>"
echo "<br>"
echo "<br>"
echo "<b><font color=#333FFF>Microsoft Excel displays a warning \"The file format and extension don't match\" on opening the Release Notes attachment. Click 'Yes' to open the Release Notes.</font></b>"
echo "<br>"
echo "<br>"
echo "<b>PS: Please do not reply to this email.</b>"
echo ""
echo "--$MAILPART"
echo "Content-Type: application/vnd.ms-excel"
echo "Content-Disposition: attachment; filename=\"$(basename $ATTACH)\""
echo ""
cat $ATTACH
echo ""
echo "--$MAILPART--"
) | sendmail -t
