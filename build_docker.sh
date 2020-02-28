#!/bin/bash
# set -x
default_value='latest'
image_base='gcr.io/workland-ca/reporting'
function get_branch() {
      git branch --no-color | grep -E '^\*' | awk '{print $2}' \
        || 
        echo "$default_value"
}
branch_name=`get_branch`
tag=`echo ${branch_name}|sed 's#develop#dev#;s#master#prod#;s#^release.+#qa#;s#^feature.*#dev#'`

echo "Updating submodules"
git submodule update --init
git submodule update --remote --merge

echo "building docker image $image_base:$tag"
docker build --tag $image_base:latest --tag $image_base:$tag .

if [ $# -gt 0 ] && [ $1 == "push" ]; then
    echo "Pushing images to Google cloud"
    docker push $image_base:latest
    docker push $image_base:$tag
fi

