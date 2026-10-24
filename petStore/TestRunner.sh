#!/usr/bin/env bash
set -euo pipefail
#####################################################################
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
: "${generate_only:=false}"
dir_generated="${SCRIPTPATH}/generated"

echo -e "\n\n- 1. Generate the postman collection and environment file \n"
echo -e "\nDir for generated files: \n\t ${dir_generated}"

rm -rf -- "${dir_generated}"
mkdir -pv -- "${dir_generated}"
file_collection="${dir_generated}/petStore.postman_collection.json"
sed \
 -e "" \
  "${SCRIPTPATH}/template.postman_collection.json" > "${file_collection}"
echo "generated the collection ${file_collection}"

file_env="${dir_generated}/environment.postman_environment.json"
sed \
 -e "" \
  "${SCRIPTPATH}/template.postman_environment.json" > "${file_env}"
echo "generated the environment file ${file_env}"

if [ "${generate_only}" = "true" ]; then
  exit 0
fi

#####################################################################
echo -e "\n\n- 2. Execution in progress \n"
cd "${SCRIPTPATH}"
# npm ci installs exactly what package-lock.json pins (no silent upgrades);
# no dependency needs lifecycle scripts, so don't run any.
npm ci --ignore-scripts --no-audit --no-fund
file_collection="${file_collection}" file_env="${file_env}" npm run test
