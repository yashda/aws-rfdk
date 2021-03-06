#!/bin/bash
#
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

set -euo pipefail

COMPONENT_NAME=${1:-undefined}
OPTION=${2:-undefined}

if [[ $(basename $(pwd)) != $COMPONENT_NAME ]]; then
  echo "ERROR: Script must be run from top directory of test component"
  exit 1
fi

SKIP_TEST_CHECK=\$SKIP_${COMPONENT_NAME}_TEST
SKIP_TEST_CHECK=$(eval "echo $SKIP_TEST_CHECK" 2> /dev/null) || SKIP_TEST_CHECK=false
if [[ ! "${SKIP_TEST_CHECK}" = "true" ]]; then

  # Load utility functions
  source "../common/scripts/bash/deploy-utils.sh"

  if [[ $OPTION != '--destroy-only' ]]; then
    deploy_component_stacks $COMPONENT_NAME
    execute_component_test $COMPONENT_NAME
  fi
  if [[ $OPTION != '--deploy-and-test-only' ]]; then
    destroy_component_stacks $COMPONENT_NAME
  fi
fi

exit 0
