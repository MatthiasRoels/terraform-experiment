# README

In this demo, we will deploy an MLflow tracking server on Google Kubernetes Engine (GKE). We will expose the service with Cloud Load Balancer (CLB) and will use IAP for security. We will use Terraform to provision the required infrastructure and cloud shell to execute Terraform.

## prerequisites

For this tutorial, we asume the the following is already set:

- a GCP account
- a billing account
- a GCP project (although this can also be provisioned with Terraform)

## Architecture

As mentioned in the introduction, we will use GKE to deploy our MLflow tracking server. To increase security, we will use a private GKE cluster with a master node without a publicly-reachable endpoint. We will therefore also put in place a small VM inside the VPC so that we can interact with the GKE cluster from that VM.
