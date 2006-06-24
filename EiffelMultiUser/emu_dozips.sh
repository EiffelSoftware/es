#Dieses Skript generiert in ./.. ein windows und ein linux zip
#ohne die Diagramm und Eifgen Ordner. Die Zipfiles sind in ./..
#Es werden keine Abfragen gemacht, ob das Tempverzeichnis oder die zips
#schon existieren, sondern diese würden einfach überschrieben!


#any name which doesn't exists so far and it appears in the zip
TEMPDIR=source_emu
TEMPDIR_SCHRAEG=$TEMPDIR-0293875

#Create the tempdir 
if [ -d ../$TEMPDIR ]; then
	echo 'Directory ../'$TEMPDIR' exists allready. Renamed (Will be renamed back at the end'
	mv ../$TEMPDIR ../$TEMPDIR_SCHRAEG
fi
mkdir ../$TEMPDIR

#Copy all into the temp_directory without EIFGEN and Diagrams (you could add more here, just email me please
echo 'Kopiere in Tempverzeichnis'
rsync -Cavz --exclude EIFGEN/ --exclude Diagrams . ../$TEMPDIR/ > /dev/null

cd ..

#Makes a zip
DATUM=`date +%Y-%m-%d`
NAME='source_emu_linux-'$DATUM'_'$USER
echo $NAME
zip -r $NAME $TEMPDIR/ > /dev/null
echo 'created linux.zip in:'
pwd
echo
#Change the / to  \ for windows style and some libraries (you could add more, just email me please)

#To avoid doing the win-changes on wrong subdirectories
cd $TEMPDIR

find . -name "*.ace" -print | while read filename
do
        mv -f $filename $filename.out
        sed -r 's/\//\\/g' $filename.out > $filename.2
        sed -r 's/libmtnet.a/mtnet.lib/g' $filename.2 > $filename.3
	sed -r 's/ISE_PLATFORM/ISE_C_COMPILER/g' $filename.3 > $filename
        rm -f $filename.3
        rm -f $filename.2
        rm -f $filename.out
done

cd ..


echo 'Done changes for windows'
#Makes a zip

NAME='source_emu_win-'$DATUM' '$USER
zip -r $NAME $TEMPDIR/ > /dev/null
echo 'Created windows.zip in:'
pwd
echo

rm -r $TEMPDIR
echo 'Done removing Tempdir (hope not a wrong one ;-))'

# Question: schroeder@gmx.ch

if [ -d ./$TEMPDIR_SCHRAEG ]; then
        echo 'Directory ../'$TEMPDIR': back again'
        mv ./$TEMPDIR_SCHRAEG ./$TEMPDIR
fi

