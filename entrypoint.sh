#!/bin/sh

set -e

# ------------------------
#  Args
# ------------------------
FILE=$1
OUTPUT=$2
POLICY=$3
TRACE=$4
UPDATE=$5
COMMENT=$6
GITHUB_TOKEN=$7

# ------------------------
# Vars
# ------------------------
SUCCESS=0
GIT_COMMENT=""

# ------------------------
#  Main
# ------------------------
cd ${GITHUB_WORKSPACE}/${WORKING_DIR}

set +e

if [ ${UPDATE} != "" ]; then
	# Use "/.policy" for download directory (ignore user setting)
	POLICY="/.policy"
	# Add --update args
	UPDATE="--update ${UPDATE}"
fi

# exec conftest
CMD="/usr/local/bin/conftest test --no-color -p ${POLICY} -o ${OUTPUT} --trace=${TRACE} ${UPDATE} ${FILE}"
OUTPUT=$(sh -c "${CMD}" 2>&1)
SUCCESS=$?

set -e

# let's log command
echo "--- file ---"
ls -l ${FILE}
echo "------"
echo "executed: $CMD"
echo "return code: ${SUCCESS}"

if [ ${SUCCESS} -eq 0 ]; then
	echo "Validate success!"
	exit 0
fi

# Make validation details for the github comment (filter "PASS" line)
GIT_COMMENT="## ⚠ [conftest] Validation Failed
<details><summary><code>detail</code></summary>

\`\`\`
$(echo "${OUTPUT}")
\`\`\`
</details>

"

# comment to github
if [ "${COMMENT}" = "true" ];then
	PAYLOAD=$(echo '{}' | jq --arg body "${GIT_COMMENT}" '.body = $body')
	COMMENTS_URL=$(cat ${GITHUB_EVENT_PATH} | jq -r .pull_request.comments_url)
	curl -sS -H "Authorization: token ${GITHUB_TOKEN}" --header "Content-Type: application/json" --data "${PAYLOAD}" "${COMMENTS_URL}" >/dev/null
fi

exit ${SUCCESS}

