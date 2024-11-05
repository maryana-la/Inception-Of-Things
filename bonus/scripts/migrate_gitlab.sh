#!/bin/bash

# create user name and root for gitlab
GITLAB_PASS=$(sudo kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 --decode)
sudo echo "machine gitlab.k3d.gitlab.com
login root
password ${GITLAB_PASS}" > ~/.netrc
sudo mv ~/.netrc /root/
sudo chmod 600 /root/.netrc


#### todo project folder name, token as var

#or use token for acces
"PRIVATE-TOKEN: GITLAB_TOKEN" - add token to sh comand
curl --header "PRIVATE-TOKEN: glpat-ZCxTo_4zSycixF-8AZ93" -X POST "http://gitlab.iot.gitlab.com/api/v4/projects" \
  --form "name=bonus" \
  --form "visibility=private"

#Клонируйте репозиторий с GitHub в локальную директорию:
git clone https://github.com/OlgaKush512/okushnir_IoT.git project_folder
cd project_folder

# #Добавьте в качестве удаленного репозитория ваш новый проект в локальном GitLab
# git remote add gitlab git@localhost:root/bonus_2.git
# git remote add gitlab git@http://gitlab.iot.gitlab.com/root/bonus_2git


git config --local user.name "Administrator"
git config --local user.email "rchelsea@student.42.fr"

# option 1: remove git and push a new file
rm -rf .git
git init --initial-branch=main
git remote add origin http://gitlab.iot.gitlab.com/root/bonus_2.git
git add .
git commit -m "Initial commit"
git push --set-upstream origin main


# option 2: keep history and push github repo to gitlab
git remote rename origin old-origin
git remote add origin http://gitlab.iot.gitlab.com/root/bonus_3.git
git push --set-upstream origin --all
git push --set-upstream origin --tags

# use push with token to avoid paasword request:
git push https://root:glpat-ZCxTo_4zSycixF-8AZ93@gitlab.iot.gitlab.com/root/bonus.git

sudo kubectl apply -f ../confs/deploy.yaml

# Warning port-forward
echo "${GREEN}PORT-FORWARD : sudo kubectl port-forward svc/svc-wil -n dev 8888:8080${RESET}"
