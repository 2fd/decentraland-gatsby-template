#!/bin/bash

OFF='\033[0m'
GREEN='\033[0;32m'
GREY='\033[0;90m'

## Title
echo "";
echo "Decentraland Gatsby Template for Projects";
echo "";

## Ask for project type
PROJECT_TYPE_RETTRY=0
while [[ $PROJECT_TYPE != "worker" && $PROJECT_TYPE != "docker" && $PROJECT_TYPE != "static" ]]; do
  if [[ $PROJECT_TYPE_RETTRY == 0 ]]; then
    read -p "$(echo -e ${GREEN}~ Enter template type ${GREY}\(static\|worker\|docker\): ${OFF})" PROJECT_TYPE
  else
    read -p "$(echo -e ${GREEN}~ Please enter valid template type ${GREY}\(static\|worker\|docker\): ${OFF})" PROJECT_TYPE
  fi

  PROJECT_TYPE_RETTRY=$PROJECT_TYPE_RETTRY+1
done

## Ask for project name
PROJECT_NAME_RETTRY=0
while [[ $PROJECT_NAME == "" ]]; do
  if [[ $PROJECT_NAME_RETTRY == 0 ]]; then
    read -p "$(echo -e ${GREEN}~ Enter project name: ${OFF})" PROJECT_NAME
  else
    read -p "$(echo -e ${GREEN}~ Plese enter project name: ${OFF})" PROJECT_NAME
  fi

  PROJECT_NAME_RETTRY=$PROJECT_NAME_RETTRY+1
done

if [[ $PROJECT_TYPE == "static" ]]; then
  echo -e "${GREEN}~ Creating: ${GREY}.github/workflows/pull-request.yml${OFF}";
  rm ".github/workflows/pull-request.yml";
  mv ".github/workflows/pull-request_static.yml.example" ".github/workflows/pull-request.yml";
  rm ".github/workflows/pull-request_worker.yml.example";
  rm ".github/workflows/pull-request_docker.yml.example";
  rm ".github/workflows/deploy_master.yml.example";
  rm ".github/workflows/deploy_manual.yml.example";
  rm -Rf "src/worker";
  rm -f "src/_workers.ts";
  rm -f "src/server.ts";
  rm -f "_headers";
  rm -f "_redirects";
  rm -f "_routes.json";
  rm -f "wrangler.toml";

fi

if [[ $PROJECT_TYPE == "worker" ]]; then
  echo -e "${GREEN}~ Creating: ${GREY}.github/workflows/pull-request.yml${OFF}";
  rm ".github/workflows/pull-request.yml";
  mv ".github/workflows/pull-request_worker.yml.example" ".github/workflows/pull-request.yml";
  rm ".github/workflows/pull-request_docker.yml.example";
  rm ".github/workflows/deploy_master.yml.example";
  rm ".github/workflows/deploy_manual.yml.example";
  rm -f "src/server.ts";
  sed -i "" -e "s/{{project_name}}/$PROJECT_NAME/g" "wrangler.toml";
fi

if [[ $PROJECT_TYPE == "docker" ]]; then

  echo -e "${GREEN}~ Creating: ${GREY}.github/workflows/deploy_master.yml${OFF}"
  echo -e "${GREEN}~ Creating: ${GREY}.github/workflows/deploy_manual.yml${OFF}"

  rm ".github/workflows/pull-request.yml";
  mv ".github/workflows/pull-request_docker.yml.example" ".github/workflows/pull-request.yml";
  mv ".github/workflows/deploy_master.yml.example" ".github/workflows/deploy_master.yml";
  mv ".github/workflows/deploy_manual.yml.example" ".github/workflows/deploy_manual.yml";
  rm ".github/workflows/pull-request_worker.yml.example";
  mkdir "src/entities"
  rm -Rf "src/worker";
  rm -f "src/_workers.ts";
  rm -f "_headers";
  rm -f "_redirects";
  rm -f "_routes.json";
  rm -f "wrangler.toml";
  sed -i "" -e "s/{{project_name}}/$PROJECT_NAME/g" ".github/workflows/pull-request.yml";
  sed -i "" -e "s/{{project_name}}/$PROJECT_NAME/g" ".github/workflows/deploy_master.yml";
  sed -i "" -e "s/#//g" ".github/workflows/deploy_master.yml";
  sed -i "" -e "s/{{project_name}}/$PROJECT_NAME/g" ".github/workflows/deploy_manual.yml";
fi

sed -i "" -e "s/{{project_name}}/$PROJECT_NAME/g" "gatsby-browser.js";
sed -i "" -e "s/{{project_name}}/$PROJECT_NAME/g" "gatsby-config.js";
sed -i "" -e "s/Decentraland Gatsby Template for Projects/$PROJECT_NAME/g" "README.md";
sed -i "" -e '97d' "package.json";

echo -e "${GREEN}~ Removing: ${GREY}start.sh${OFF}"
rm start.sh

echo -e "${GREEN}~ Installing dependencies...${OFF}"
npm ci

echo -e "${GREEN}~ Restarting GIT...${OFF}"
rm -Rf .git && \
  git init && \
  git add . && \
  git commit -m "feat: initial commit"

echo -e "${GREEN}~ Done!${OFF}"