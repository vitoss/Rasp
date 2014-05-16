#!/bin/sh
#  Build the doxygen documentation for the project and load the docset into Xcode.

#  Use the following to adjust the value of the $DOXYGEN_PATH User-Defined Setting:
#    Binary install location: /Applications/Doxygen.app/Contents/Resources/doxygen
#    Source build install location: /usr/local/bin/doxygen

#  Graphical class diagrams require Graphviz.
#  Graphviz.app is available free online
# http://www.graphviz.org/Download_macos.php

#  If the config file doesn't exist, run 'doxygen -g "${SOURCE_ROOT}/../documentation/doxygen/doxygen touch.config"' to 
#   a get default file.

if ! [ -f "${SOURCE_ROOT}/../documentation/doxygen/doxygen touch.config" ] 
then 
  echo doxygen config file does not exist
  ${DOXYGEN_PATH} -g "${SOURCE_ROOT}/../documentation/doxygen/doxygen touch.config"
fi

#  Run doxygen on the updated config file.
#  Note: doxygen creates a Makefile that does most of the heavy lifting.

${DOXYGEN_PATH} "${SOURCE_ROOT}/../documentation/doxygen/doxygen touch.config"

#  make a copy of the html docs
mkdir -p "${SOURCE_ROOT}/../documentation/html/iOS"
cp -R "${SOURCE_ROOT}/CorePlotTouchDocs.docset/html/" "${SOURCE_ROOT}/../documentation/html/iOS"

#  make will invoke docsetutil. Take a look at the Makefile to see how this is done.

make -C "${SOURCE_ROOT}/CorePlotTouchDocs.docset/html" install

#  add publisher info to the docset

find "/Users/${USER}/Library/Developer/Shared/Documentation/DocSets/com.CorePlotTouch.Framework.docset/Contents/" -type f -name Info.plist | xargs perl -pi -e 's/\<\/dict\>/\t\<key\>DocSetPublisherIdentifier\<\/key\>\n\t\<string\>com.CorePlot.documentation\<\/string\>\n\t\<key\>DocSetPublisherName\<\/key\>\n\t\<string\>Core Plot\<\/string\>\n\t\<key\>NSHumanReadableCopyright\<\/key\>\n\t\<string\>Copyright © 2011 Core Plot. All rights reserved.\<\/string\>\n\<\/dict\>\n/g'

#  Construct a temporary applescript file to tell Xcode to load a docset.

rm -f "${TEMP_DIR}/loadDocSet.scpt"

echo "tell application \"Xcode\"" >> "${TEMP_DIR}/loadDocSet.scpt"
echo "load documentation set with path \"/Users/${USER}/Library/Developer/Shared/Documentation/DocSets/\"" >> "${TEMP_DIR}/loadDocSet.scpt"
echo "end tell" >> "${TEMP_DIR}/loadDocSet.scpt"

#  Run the load-docset applescript command.

osascript "${TEMP_DIR}/loadDocSet.scpt"

exit 0
