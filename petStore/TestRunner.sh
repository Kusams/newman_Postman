#!/bin/bash -e
#####################################################################
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
echo -e "\n\n- 1. Generate the postman collection and environment file \n"
echo -e "\nDir for generated files: \n\t ${dir_generated}"
 : generate_only=${generate_only:=false}
dir_generated=${SCRIPTPATH}/generated

rm -rf ${dir_generated}
mkdir -pv ${dir_generated}
file_collection=${dir_generated}\/petStore.postman_collection.json
sed \
 -e ""\
  ${SCRIPTPATH}/template.postman_collection.json > ${file_collection}
echo "generated the collection ${file_collection}"

file_env=${dir_generated}\/environment.postman_environment.json
sed \
 -e ""\
  ${SCRIPTPATH}/template.postman_environment.json > ${file_env}
echo "generated the environment file ${file_env}"

#####################################################################
echo -e "\n\n- 2. Execution in progress \n"
rm -rf ${SCRIPTPATH}/node_modules
npm i && file_collection=${file_collection} file_env=${file_env} npm run test
