#!/bin/bash

TIME="10"
TELEGRAM_USER_ID="-numbers"  # telegram group id
TELEGRAM_BOT_TOKEN="token"

PROJECT=$CI_PROJECT
TEXT1="branch deleted in 3 days"
TEXT2="branch deleted in 1 day "
TEXT3="deleted"
URL="https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage"


for branch in `git branch -r --merged | grep -v HEAD`; do
    if  echo -e `git show --format="%cr %aE" $branch | head -n 1` \\t$branch | grep -v "bot@example.com" | grep -v origin/master | grep -v origin/pre-master | grep -v origin/dev | grep -v origin/lingtest-bot | grep -e '5 days' &>/dev/null; then

	   curl -s --max-time $TIME -d "chat_id=$TELEGRAM_USER_ID&disable_web_page_preview=1&text=$TEXT1 $PROJECT $branch" $URL

    elif  echo -e `git show --format="%cr %aE" $branch | head -n 1` \\t$branch | grep -v "bot@example.com" | grep -v origin/master | grep -v origin/pre-master | grep -v origin/dev | grep -v origin/lingtest-bot | grep -e '7 days' &>/dev/null; then


           curl -s --max-time $TIME -d "chat_id=$TELEGRAM_USER_ID&disable_web_page_preview=1&text=$TEXT2 $PROJECT $branch" $URL
    fi

done


for branch in `git branch -r --merged | grep -v HEAD`; do

    if  echo -e `git show --format="%cr %aE" $branch | head -n 1` \\t$branch | grep -v "bot@example.com" | grep -v origin/master | grep -v origin/pre-master | grep -v origin/dev | grep -v origin/lingtest-bot | grep -e '8 days' &>/dev/null; then

           echo $branch | grep 'origin/' | sed 's/.*origin\///' |  xargs -n 1 git push origin --delete

	   curl -s --max-time $TIME -d "chat_id=$TELEGRAM_USER_ID&disable_web_page_preview=1&text=$TEXT3 $PROJECT $branch" $URL


    fi

done

