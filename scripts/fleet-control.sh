#!/usr/bin/env bash
set -euo pipefail

action="${1:-}"
target="${2:-}"
ami_override="${3:-}"

if [ -z "${action}" ]; then
  echo "Usage: fleet-control.sh <deploy|status> [target] [ami_override]" >&2
  exit 1
fi

api_url_file="/etc/clawdinator/control-api-url"
token_file="/run/agenix/clawdinator-control-token"
access_key_file="/run/agenix/clawdinator-control-aws-access-key-id"
secret_key_file="/run/agenix/clawdinator-control-aws-secret-access-key"
caller_file="/etc/clawdinator/instance-name"

if [ ! -f "${token_file}" ]; then
  echo "Missing control API token: ${token_file}" >&2
  exit 1
fi
if [ ! -f "${access_key_file}" ] || [ ! -f "${secret_key_file}" ]; then
  echo "Missing control AWS credentials in /run/agenix" >&2
  exit 1
fi
if [ ! -f "${caller_file}" ]; then
  echo "Missing instance name: ${caller_file}" >&2
  exit 1
fi

control_token="$(cat "${token_file}")"
caller="$(cat "${caller_file}")"

if [ "${action}" = "deploy" ]; then
  if [ -z "${target}" ]; then
    echo "Target required. Usage: fleet-control.sh deploy <all|clawdinator-2>" >&2
    exit 1
  fi

  if [ "${target}" = "${caller}" ]; then
    echo "Refusing self-deploy for ${caller}." >&2
    exit 1
  fi
fi

payload="$(jq -n \
  --arg action "${action}" \
  --arg target "${target}" \
  --arg caller "${caller}" \
  --arg ami_override "${ami_override}" \
  --arg control_token "${control_token}" \
  '{action: $action, target: $target, caller: $caller, ami_override: $ami_override, control_token: $control_token}')"

region="${AWS_REGION:-eu-central-1}"
export AWS_ACCESS_KEY_ID="$(cat "${access_key_file}")"
export AWS_SECRET_ACCESS_KEY="$(cat "${secret_key_file}")"

response_file="$(mktemp)"
aws lambda invoke \
  --function-name "clawdinator-control-api" \
  --region "${region}" \
  --payload "${payload}" \
  --cli-binary-format raw-in-base64-out \
  "${response_file}" >/dev/null

response="$(cat "${response_file}")"
rm -f "${response_file}"

if [ "${action}" = "status" ]; then
  ok="$(printf '%s' "${response}" | jq -r '.ok')"
  if [ "${ok}" != "true" ]; then
    echo "${response}" >&2
    exit 1
  fi
  echo "Name | InstanceId | State | AMI | Public IP"
  printf '%s' "${response}" | jq -r '.instances[] | "\(.name) | \(.id) | \(.state) | \(.ami) | \(.ip)"'
  exit 0
fi

echo "${response}"
