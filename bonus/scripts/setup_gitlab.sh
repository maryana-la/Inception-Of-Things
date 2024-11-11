#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Please provide gitlab token to proceed."
    echo "Usage: ./setup_gitlab.sh <token>"
    exit 1
fi

GIT_PROJECT="bonus_app"
GITLAB_TOKEN=$1

response=$(curl --write-out "%{http_code}" --silent --output /dev/null \
  --header "PRIVATE-TOKEN:$GITLAB_TOKEN" -X POST "http://gitlab.iot.com/api/v4/projects" \
  --form "name=$GIT_PROJECT" \
  --form "visibility=public")

if [ "$response" -ne 201 ]; then
  echo "Failed to create project on gitlab. Response code: $response"
  exit 1
fi

git clone https://github.com/maryana-la/okushnir_IoT.git app_temp

if [ $? -ne 0 ]; then
  echo "Failed to clone repository."
  exit 1
fi

cd app_temp
git config --local user.name "Administrator"
git config --local user.email "rchelsea@student.42.fr"
git remote rename origin old-origin
git remote add origin http://gitlab.iot.com/root/$GIT_PROJECT.git
git add .
git commit -m "Initial commit"
git push --set-upstream origin --all
git push --set-upstream origin --tags
cd ..
rm -rf app_temp

sudo kubectl apply -f ../confs/deploy.yaml -n argocd
