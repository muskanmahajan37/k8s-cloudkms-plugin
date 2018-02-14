# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM golang
LABEL maintainer="alextc@google.com"

# Entry Point
COPY k8s-cloud-kms-plugin /

# Integration test
COPY plugin.test /

RUN mkdir /socket
ENTRYPOINT ["/k8s-cloud-kms-plugin", "--project-id=cloud-kms-lab", "--location-id=us-central1", "--key-ring-id=ring-01", "--key-id=my-key", "--path-to-unix-socket=/tmp/kms-plugin.socket"]

# Uncomment lines below only if testing in docker locally (not on GCE, GKE)
# This will allow application default credentails to be loaded from an exported service account key-file.
# On GKE credentials will be automatically provided via metadata server.
# see: https://cloud.google.com/docs/authentication/production#auth-cloud-implicit-go
# Fore details on how to export service account keys, see https://cloud.google.com/iam/docs/creating-managing-service-account-keys
# The service account should be granted Cloud KMS CryptoKey Encrypter/Decrypter IAM Permission.

# RUN mkdir /adc
# COPY cloud-kms-lab-svc.json /adc
# ENV GOOGLE_APPLICATION_CREDENTIALS=/adc/cloud-kms-lab-svc.json