#!/bin/bash
#Author: Poul Serek - https://odd-one-out.serek.eu/piwigo-thumbnail-generation-script/

shopt -s globstar

echo "Starting Piwigo thumbnail generation"

#Remember a trailing '/'
sourceDir="/media/15a238b7-31c3-4a2e-a21a-b9bad3354359/Foto"
destDir="/media/15a238b7-31c3-4a2e-a21a-b9bad3354359/piwigo/_data/i/galleries/"

counter=0
fnNoExt=""
fnExt=""
fnPath=""

STARTTIME=$(date +%s)

for file in "$sourceDir"/**/*.{jpg,JPG,jpeg,JPEG}
do
        if [[ ! -f "$file" ]]
        then
                continue
        fi

        fnNoExt="${file%.*}"
        fnExt="${file##*.}"
        fnPath="${file%/*}"
        fnPath="${fnPath#$sourceDir}"
        fnNoExt="${fnNoExt#$sourceDir}"

        echo "${fnNoExt}"

        mkdir -p "${destDir}${fnPath}"

        #Error checking
        result=$(jpeginfo -c "$file")
        if [[ $result != *"[OK]"* ]]
        then
                echo $result
        fi

        #If the medium thumbnail exists we assume that the rest also exists and skip this image
        if [ ! -f "${destDir}${fnNoExt}-me.${fnExt}" ]; then
                #echo "MISSING! ${destDir}${fnNoExt}-me.${fnExt}"
                #Store correctly oriented base image (medium) in memory. All other thumbnails are created from this
                convert "${file}" -auto-orient -resize 792x594 -write mpr:baseline +delete \
                mpr:baseline -write "${destDir}${fnNoExt}-me.${fnExt}" +delete \
                mpr:baseline -resize 144x144 -write "${destDir}${fnNoExt}-th.${fnExt}" +delete \
                mpr:baseline -resize 240x240 -write "${destDir}${fnNoExt}-2s.${fnExt}" +delete \
                mpr:baseline -resize 576x432 -write "${destDir}${fnNoExt}-sm.${fnExt}" +delete \
                mpr:baseline -define jpeg:size=144x144 -thumbnail 120x120^ -gravity center -extent 120x120 "${destDir}${fnNoExt}-sq.${fnExt}"
        fi
        counter=$[$counter +1]
        if [ $(($counter%100)) -eq 0 ]; then
                ENDTIME=$(date +%s)
                echo "Processed: ${counter} - Executing for $((($ENDTIME - $STARTTIME)/60)) minutes"
        fi
done

ENDTIME=$(date +%s)
echo "It took $((($ENDTIME - $STARTTIME)/60)) minutes to complete this task..."
