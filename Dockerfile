# Adapted from https://github.com/koslib/helm-eks-action to authenticate using eksctl.

FROM alpine:3.13

ARG KUBECTL_VERSION="1.21.2"
ARG TARGETARCH

RUN apk add py-pip curl wget ca-certificates git bash jq gcc alpine-sdk
RUN pip install 'awscli==1.22.26'
RUN set -x echo ${TARGETARCH}
RUN curl -L -o /usr/bin/kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/${TARGETARCH}/kubectl
RUN chmod +x /usr/bin/kubectl

RUN curl -o /usr/bin/aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/${TARGETARCH}/aws-iam-authenticator
RUN chmod +x /usr/bin/aws-iam-authenticator

RUN wget https://get.helm.sh/helm-v3.8.0-linux-${TARGETARCH}.tar.gz -O - | tar -xzO linux-${TARGETARCH}/helm > /usr/local/bin/helm
RUN chmod +x /usr/local/bin/helm

RUN wget "https://github.com/weaveworks/eksctl/releases/download/v0.147.0/eksctl_$(uname -s)_${TARGETARCH}.tar.gz" -O - | tar -xz -C /usr/local/bin

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]:
