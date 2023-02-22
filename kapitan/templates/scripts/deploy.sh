#!/usr/bin/env bash
{% set i = inventory.parameters %}
# colors
NORMAL=$(tput sgr0)
GREEN=$(tput setaf 2; tput bold)
RED=$(tput setaf 1; tput bold)

printf '%s\n' "${RED}[DEBUG]${NORMAL} Calling deploy.sh with these arguments:
RELEASE: {{ i.charts.gitlab.name }}
CHART: {{ i.charts.gitlab.name }}
VERSION: {{ i.charts.gitlab.version }}
CHART_REPO: {{ i.charts.gitlab.repo }}"

printf '%s\n' "${GREEN}[INFO]${NORMAL} Deploying to environment: {{ i.target_name }}"
helm upgrade \
    {{ i.charts.gitlab.name }} \
    {{ i.charts.gitlab.name }} \
    --install \
    --wait \
    --version {{ i.charts.gitlab.version }} \
    --kubeconfig $K8S_STG_SERVER_KUBECONFIG \
    --namespace {{ i.charts.gitlab.namespace }} \
    --repo {{ i.charts.gitlab.repo }} \
    --values compiled/{{ i.target_name }}/{{ i.charts.gitlab.name }}/{{ i.charts.gitlab.name }}-values.yaml
