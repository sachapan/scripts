#!/bin/bash
curl --data-binary '{ "jsonrpc": "2.0", "method": "VideoLibrary.Scan", "id": "mybash"}' -H 'content-type: application/json;' http://kodo:kodi@kodi-db:8080/jsonrpc
telegram-send "Updating kodi video library."
