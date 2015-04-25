#!/bin/sh
#set -e
# do not use that! handle errors by yourself.


#
# user set variables
#

USER=agiz
# remote username

PRIVATE="true"
# private repository by default

REPO="${PWD##*/}"
# extracts name of the project from path
# ~/foo/bar/prjectname => REPO == projectname

PROVIDER=""
# provider name

PROVIDER_URL=""
# remote provider

PROVIDER_ORIGIN=""
# remote provider origin

PROVIDER_ORIGIN_1="git@bitbucket.org:${USER}/${REPO}.git"
PROVIDER_ORIGIN_2="git@github.com:${USER}/${REPO}.git"
# origin of remote provider


#
# single exit - return with error
#

err_ret() {
  cd -
  # back to initial directory

  exit ${1}
  #return with error code
}


#
# parse input arguments
#

if [ "$#" -eq "0" ]; then
  PROVIDER="bitbucket"
  PROVIDER_ORIGIN="${PROVIDER_ORIGIN_1}"
  PROVIDER_URL="https://api.bitbucket.org/1.0/repositories -d name=${REPO}&is_private=${PRIVATE}"
else
  PROVIDER="${1}"
  case "${PROVIDER}" in
    "bitbucket")
      PROVIDER_ORIGIN="${PROVIDER_ORIGIN_1}"
      PROVIDER_URL="https://api.bitbucket.org/1.0/repositories -d name=${REPO}&is_private=${PRIVATE}" ;;
    "github")
      PRIVATE="false"
      PROVIDER_ORIGIN="${PROVIDER_ORIGIN_2}"
      PROVIDER_URL="https://api.github.com/user/repos -d {\"name\":\"${REPO}\"}" ;;
    *)
      echo "ERROR: Unknown provider - ${PROVIDER}."
      echo "Usage: Navigate to the project, execute: $0 <bitbucket|github>"
      err_ret 1 ;;
  esac
fi

echo "Creating ${REPO} on ${PROVIDER} as [PRIVATE=${PRIVATE}]."
echo ""

cd "${PWD}"
# move to project's directory

git status >/dev/null 2>&1
# check if this project already has it's repository

if [ "$?" -eq "0" ]; then
  echo "This project already has repository!"
  err_ret 1
fi

DATA=`curl -k -X POST --user ${USER} ${PROVIDER_URL}`
# create repository (needs user input for password)

if [[ "${DATA}" != *"\"name\": \"${REPO}\""* ]]; then
  # both bitbucket and github share "name": "REPO" string in the output.
  echo "ERROR: Something went wrong."
  echo "Check your password or make sure remote repository with that name does not exist."
  err_ret 1
fi

echo "Initializing repository..."
git init
echo ""

echo "Adding remote repository..."
git remote add origin "${PROVIDER_ORIGIN}"
echo ""

echo "Adding all files..."
git add .
echo ""

echo "Commiting changes..."
git commit -a -m 'Initial commit.'
echo ""

echo "Pushing project to remote repository..."
git push -u origin master
echo ""

cd -
# back to initial directory

