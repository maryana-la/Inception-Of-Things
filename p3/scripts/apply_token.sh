#!/bin/bash


kubectl create secret generic github-cred \
  --from-literal=username=OlgaKush512 \
  --from-literal=password=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 \
  -n argocd