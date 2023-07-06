#!/usr/bin/env bash

cd /tmp/deployment/cloud-native-deployment-strategies

argocd login --core
oc project openshift-gitops
argocd app delete argo-rollouts -y
argocd app delete shop -y

oc delete project gitops

oc delete -f canary-argo-rollouts/application-shop-canary-rollouts.yaml

oc delete -f canary-argo-rollouts/application-cluster-config.yaml

oc delete subscription openshift-pipelines-operator-rh -n openshift-operators
oc delete clusterserviceversion openshift-pipelines-operator-rh.v1.10.0 -n openshift-operators


if [ ${1:-no} = "no" ]
then
    oc delete -f gitops/gitops-operator.yaml
    oc delete subscription openshift-gitops-operator -n openshift-operators
    oc delete clusterserviceversion openshift-gitops-operator.v1.9.0 -n openshift-operators
fi

git checkout main
git branch -d canary
git push origin --delete canary


