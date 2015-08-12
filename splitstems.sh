#!/bin/bash

if [[ "$@" = "" ]]; then
    echo "Please specify an .mp4 file to split."
    exit 1
fi

for FILENAME in "$@"
do
    # Only convert .mp4 files
    if [[ ! $FILENAME =~ \.[Mm][Pp]4$ ]]; then
        echo "  Error: This script only works on .mp4 Stems files."
        continue
    fi

    # Only convert if there are exactly 5 tracks
    TRACKCOUNT=`afinfo "${FILENAME}" | grep "Track ID:" | wc -l`
    if [ ! $TRACKCOUNT -eq 5 ]; then
        echo "  Error: There must be exactly 5 tracks in the .mp4 file."
        continue
    fi

    BASENAME=`basename "${FILENAME}" | sed -E 's/\.[Mm][Pp]4$//'`
    DIRNAME=`echo "${FILENAME}" | sed -E 's/\.[Mm][Pp]4$/.stems/'`

    if [ -d "${DIRNAME}" ]; then
        rm -rf "${DIRNAME}"
    fi

    if [ ! -d "${DIRNAME}" ]; then
        mkdir -p "${DIRNAME}"
    fi

    for TRACK in 1 2 3 4 5
    do
        NUM=`expr $TRACK - 1`
        TRACKFILE="${DIRNAME}/${BASENAME} (Stem $NUM).mp4"

        # Only output file if it doesn't already exist
        if [ ! -f "${TRACKFILE}" ]; then
            afconvert -d 0 --read-track $NUM "${FILENAME}" "${TRACKFILE}"
        fi
    done
done
