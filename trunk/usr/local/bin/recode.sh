#!/bin/bash
# outils pour transformer le contenu des fichiers d'un dossier en UTF-8 s'il ne le sont pas

REP=$1
MOI=$0

rm -f /tmp/$MOI.* 2>/dev/null

file $REP/*  | sed 's/: */:/g' | grep text | grep -v "ML document"| grep -v "UTF-8 Unicode text" > /tmp/$MOI.bdd

grep "ISO-8859 text" /tmp/$MOI.bdd > /tmp/$MOI.iso8859
grep -v "ISO-8859 text" /tmp/$MOI.bdd | cut -d":" -f1 > /tmp/$MOI.bdd.tmp

echo "entre dans la boucle1"

cat /tmp/$MOI.bdd.tmp | while read FIC
do
  tail -`expr \`cat $FIC |wc -l\` - 1` $FIC > /tmp/$MOI.tmp
  echo $FIC
  file /tmp/$MOI.tmp
  TYPE=`file  /tmp/$MOI.tmp | sed 's/: */:/g'| cut -d: -f2`
  if [ "$TYPE" = "ISO-8859 text" ]
    then
      echo "$FIC:ISO-8859 text" >> /tmp/$MOI.iso8859
    fi
done

echo "entre dans la boucle2"

cut -d":" -f1 /tmp/$MOI.iso8859  | while read FIC
do
  echo recode $FIC
  recode iso8859-15..utf8 $FIC
done

rm -f /tmp/$MOI.* 2>/dev/null
