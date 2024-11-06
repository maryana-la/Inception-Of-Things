#!/bin/bash

# # create user name and root for gitlab
# GITLAB_PASS=$(sudo kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 --decode)
# sudo echo "machine gitlab.k3d.gitlab.com
# login root
# password ${GITLAB_PASS}" > ~/.netrc
# sudo mv ~/.netrc /root/
# sudo chmod 600 /root/.netrc


#### todo project folder name, token as var

#or use token for acces
"PRIVATE-TOKEN: GITLAB_TOKEN" - add token to sh comand
curl --header "PRIVATE-TOKEN:glpat-4sxpxtP5iN6z2gD8bMZF" -X POST "http://gitlab.iot.gitlab.com/api/v4/projects" \
  --form "name=bonus_rchelsea" \
  --form "visibility=public"

#Клонируйте репозиторий с GitHub в локальную директорию:
git clone https://github.com/maryana-la/IOTbonus_app.git app_temp
cd app_temp


# #Добавьте в качестве удаленного репозитория ваш новый проект в локальном GitLab
# git remote add gitlab git@localhost:root/bonus_2.git
# git remote add gitlab git@http://gitlab.iot.gitlab.com/root/bonus_2git




# option 1: remove git and push a new file
rm -rf .git
git init --initial-branch=main
git config --local user.name "Administrator"
git config --local user.email "rchelsea@student.42.fr"
git remote add origin http://gitlab.iot.gitlab.com/root/bonus_rchelsea.git
git add .
git commit -m "Initial commit"
git push --set-upstream origin main

git remote add origin https://root:glpat-4sxpxtP5iN6z2gD8bMZF@gitlab.iot.gitlab.com/root/bonus_rchelsea.git

git remote set-url origin https://<TOKEN>@github.com/username/repository.git

git push https://gitlab-ci-token:glpat-4sxpxtP5iN6z2gD8bMZF@gitlab.iot.gitlab.com/root/bonus_rchelsea.git main

# option 2: keep history and push github repo to gitlab
git remote rename origin old-origin
git remote add origin http://gitlab.iot.gitlab.com/root/bonus.git
# git push --set-upstream origin --all
# git push --set-upstream origin --tags

# use push with token to avoid paasword request:
git push https://root:glpat-4sxpxtP5iN6z2gD8bMZF@gitlab.iot.gitlab.com/root/bonus_rchelsea.git

sudo kubectl apply -f ../confs/deploy.yaml -n argocd

# Warning port-forward
echo "PORT-FORWARD : sudo kubectl port-forward svc/svc-wil -n dev 8888:8080$"


# Локальный порт 8888: Этот порт будет доступен на вашем локальном компьютере.
# Порт в Kubernetes 8080: Это порт, на котором работает ваше приложение внутри Kubernetes кластера.

echo "PORT-FORWARD : sudo kubectl port-forward svc/svc-wil -n dev 8085:8083$"
