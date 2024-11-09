#!/bin/bash

# # create user name and root for gitlab


if [ $# -ne 1 ]; then
    echo "Please provide gitlab token to proceed."
    echo "Usage: ./setup_gitlab.sh <token>"
    exit 1
fi
#### todo project folder name, token as var

#or use token for access
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
# curl --header "PRIVATE-TOKEN:$GITLAB_TOKEN" -X POST "http://gitlab.iot.gitlab.com/api/v4/projects" \
#   --form "name=$GIT_PROJECT" \
#   --form "visibility=public"

 
#  GITLAB_PASS=$(sudo kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 --decode)
#  sudo echo " gitlab.iot.gitlab.com
#  login root
#  password ${GITLAB_PASS}" > ~/.netrc
#  sudo cp ~/.netrc /root/
#  sudo chmod 600 /root/.netrc ~/.netrc
#  sudo chmod ~/.netrc


#Клонируйте репозиторий с GitHub в локальную директорию:
git clone https://github.com/maryana-la/IOTbonus_app.git app_temp

if [ $? -ne 0 ]; then
  echo "Failed to clone repository."
  exit 1
fi

cd app_temp


# #Добавьте в качестве удаленного репозитория ваш новый проект в локальном GitLab
# git remote add gitlab git@localhost:root/bonus_2.git
# git remote add gitlab git@http://gitlab.iot.gitlab.com/root/bonus_2git




# option 1: remove git and push a new file
rm -rf .git
git init --initial-branch=main
git config --local user.name "Administrator"
git config --local user.email "rchelsea@student.42.fr"
git remote add origin http://gitlab.iot.com/root/$GIT_PROJECT.git
git add .
git commit -m "Initial commit"

#git push --set-upstream origin main
#
#git remote add origin https://root:$GITLAB_TOKEN@gitlab.iot.gitlab.com/root/$GIT_PROJECT.git
#
#git remote set-url origin https://$GITLAB_TOKEN@github.com/username/$GIT_GIT_PROJECT.git
#
#git push https://gitlab-ci-token:$1@gitlab.iot.gitlab.com/root/$GIT_GIT_PROJECT.git main

## option 2: keep history and push github repo to gitlab
#git remote rename origin old-origin
#git remote add origin http://gitlab.iot.gitlab.com/root/$GIT_PROJECT.git
 git push --set-upstream origin --all
 git push --set-upstream origin --tags
 cd ..
 rm -rf app_temp

# use push with token to avoid paasword request:
#git push https://root:$GITLAB_TOKEN@gitlab.iot.gitlab.com/root/$GIT_GIT_PROJECT.git

sudo kubectl apply -f ../confs/deploy.yaml -n argocd

# Warning port-forward
# echo "PORT-FORWARD : sudo kubectl port-forward svc/svc-wil -n dev 8888:8080$"


# Локальный порт 8888: Этот порт будет доступен на вашем локальном компьютере.
# Порт в Kubernetes 8080: Это порт, на котором работает ваше приложение внутри Kubernetes кластера.
# 
# echo "PORT-FORWARD : sudo kubectl port-forward svc/svc-wil-playground -n dev 8090:8085$"
# Локальный порт 8090: Этот порт будет доступен на вашем локальном компьютере.
# Порт в Kubernetes 8085: Это порт, на котором работает ваше приложение внутри Kubernetes кластера.