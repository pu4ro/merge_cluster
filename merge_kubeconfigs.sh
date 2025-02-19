#!/bin/bash

# 사용법: ./merge_kubeconfigs.sh [kubeconfig 파일1] [kubeconfig 파일2] ... [kubeconfig 파일N]
# 예: ./merge_kubeconfigs.sh ~/.kube/config ~/.kube/config_cluster2

# 인자가 하나도 없으면 사용법을 출력하고 종료
if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <kubeconfig1> [kubeconfig2 ... kubeconfigN]"
  exit 1
fi

# 임시 KUBECONFIG 변수에 모든 인자들을 콜론(:)으로 연결하여 저장
export KUBECONFIG=$(printf ":%s" "$@")
# 앞에 붙은 ':' 제거
export KUBECONFIG=${KUBECONFIG:1}

# 병합된 kubeconfig를 저장할 파일 경로
MERGED_CONFIG_FILE="${HOME}/.kube/merged_config"

echo "Merging kubeconfig files: $KUBECONFIG"
echo "Merged file will be saved to: ${MERGED_CONFIG_FILE}"

# kubeconfig 파일 병합
kubectl config view --merge --flatten > "${MERGED_CONFIG_FILE}"

if [ $? -eq 0 ]; then
  echo "Successfully merged kubeconfig files into ${MERGED_CONFIG_FILE}"
else
  echo "Failed to merge kubeconfig files" >&2
  exit 1
fi
