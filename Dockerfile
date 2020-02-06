FROM alpine:3.11

MAINTAINER  Charles Sibbald <charles@georgiapipeline.io>


RUN apk add --update ca-certificates \
 && apk add --update -t deps curl  \
 && apk add --update gettext tar gzip

#  K8S_VERSION=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/kubernetes/kubernetes/releases/latest | cut -d '/' -f 8)
ENV K8S_VERSION="v1.15.9"
# HELM_VERSION=$(curl -Ls https://github.com/helm/helm/releases | grep "/helm/helm/releases/tag/v3" | head -n 1 | sed 's/[^"]*"\([^"]*\)"[^"]*/\1/g' | cut -d '/' -f 6)
ENV HELM_VERSION="v3.0.3"

ENV HELM_FILENAME=helm-${HELM_VERSION}-linux-amd64.tar.gz

RUN curl -L https://storage.googleapis.com/kubernetes-release/release/${K8S_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
 && curl -L https://get.helm.sh/${HELM_FILENAME} | tar xz && mv linux-amd64/helm /bin/helm && rm -rf linux-amd64 \
 && chmod +x /usr/local/bin/kubectl

RUN apk del --purge deps \
 && rm /var/cache/apk/*


CMD ["helm"]
