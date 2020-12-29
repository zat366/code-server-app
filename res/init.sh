#!/bin/env bash
cd /root/code-server

find code-server/src/ -name "*.js" | xargs -I {} cp -r --parents {} vsApp/www/
find code-server/src/ -name "*.js.*" | xargs -I {} cp -r --parents {} vsApp/www/
find code-server/dist/ -name "*.js" | xargs -I {} cp -r --parents {} vsApp/www/
find code-server/dist/ -name "*.js.*" | xargs -I {} cp -r --parents {} vsApp/www/
find code-server/lib -name "*.js" | xargs -I {} cp -r --parents {} vsApp/www/
find code-server/lib -name "*.js.*" | xargs -I {} cp --parents {} vsApp/www/
