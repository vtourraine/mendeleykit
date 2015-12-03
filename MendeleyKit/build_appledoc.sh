#!/bin/bash

# remove previous generated documentation
if [ -d MendeleyKitHelp ]; then
  rm -R MendeleyKitHelp
fi

# create directory
mkdir MendeleyKitHelp

# Build documentation if appledoc is installed
if type -p appledoc &>/dev/null; then
    appledoc --project-name MendeleyKit --project-company "Mendeley" --company-id com.mendeley --output MendeleyKitHelp --keep-intermediate-files --exit-threshold 2 --ignore .m --ignore MendeleyKitTests --ignore MendeleyKitiOSTests --ignore MendeleyKitExample . 
else
    echo "appledoc executable can not be found, you can find installation instuctions at https://github.com/tomaz/appledoc"
fi
