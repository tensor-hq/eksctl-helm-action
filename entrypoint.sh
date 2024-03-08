#!/bin/sh

set -xe

export KUBECONFIG="${PWD}/kubeconfig"
eksctl utils write-kubeconfig --cluster $INPUT_EKS_CLUSTER --kubeconfig $KUBECONFIG
chmod 600 $KUBECONFIG

if [[ -n "${INPUT_PLUGINS// /}" ]]
then
    plugins=$(echo $INPUT_PLUGINS | tr ",")

    for plugin in $plugins
    do
        echo "installing helm plugin: [$plugin]"
        helm plugin install $plugin
    done
fi

echo "running entrypoint command(s)"

response=$(sh -xc "$INPUT_COMMAND")

echo "::set-output name=response::$response"
