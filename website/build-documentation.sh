#!/bin/zsh
OFFLINE=true mkdocs build -d ../Documentation
rm ../Documentation/CNAME
