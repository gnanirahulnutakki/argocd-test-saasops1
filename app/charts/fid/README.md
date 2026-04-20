# IDDM

![Version: 1.2.2](https://img.shields.io/badge/Version-1.2.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 8.2.2](https://img.shields.io/badge/AppVersion-8.2.2-informational?style=flat-square)

This repository contains Helm charts for deploying RadiantLogic Identity Data Management (IDDM) platform on Kubernetes.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Installation](#installation)
  - [Using helm --set values](#using-helm---set-values)
  - [Using values file](#using-values-file)
  - [Using Argo CD](#using-argo-cd)
- [Operations](#operations)
  - [List Releases](#list-releases)
  - [Test Release](#test-release)
  - [Upgrade Release](#upgrade-release)
- [Clean Up](#clean-up)
- [Global Settings](#global-settings)
- [Secrets Management](#secrets-management)
- [Image Credentials](#image-credentials)
- [Service Account](#service-account)
- [Dependencies Configuration](#dependencies-configuration)
  - [Overview](#overview-3)
  - [Available Dependencies](#available-dependencies)
  - [Dependency Configuration](#dependency-configuration)
  - [ZooKeeper Dependency](#zookeeper-dependency)
  - [Fluent Bit Dependency](#fluent-bit-dependency)
  - [Common Library Dependency](#common-library-dependency)
  - [Dependency Management Commands](#dependency-management-commands)
  - [Configuration Precedence](#configuration-precedence)
  - [Best Practices](#best-practices-3)
- [Persistence](#persistence)
- [Environment Variables Configuration](#environment-variables-configuration)
  - [Overview](#overview-4)
  - [Configuration Methods](#configuration-methods)
  - [Direct Values (env)](#direct-values-env)
  - [Value References (envValueFrom)](#value-references-envvaluefrom)
  - [Secret References (envFromSecret)](#secret-references-envfromsecret)
  - [Generated Secrets (envRenderSecret)](#generated-secrets-envrendersecret)
  - [Multiple Secrets (envFromSecrets)](#multiple-secrets-envfromsecrets)
  - [ConfigMap References (envFromConfigMaps)](#configmap-references-envfromconfigmaps)
  - [FID-Specific Environment Variables](#fid-specific-environment-variables)
  - [Configuration Precedence](#configuration-precedence-1)
  - [Best Practices](#best-practices-4)
  - [Troubleshooting](#troubleshooting-3)
- [Volume Management Configuration](#volume-management-configuration)
  - [Overview](#overview-5)
  - [Default Volumes](#default-volumes)
  - [Extra Volumes (extraVolumes)](#extra-volumes-extravolumes)
  - [Volume Mounts (extraVolumeMounts)](#volume-mounts-extravolumemounts)
  - [Container Volumes (extraContainerVolumes)](#container-volumes-extracontainervolumes)
  - [Sidecar Containers (sidecars)](#sidecar-containers-sidecars)
  - [Special Purpose Volumes](#special-purpose-volumes)
  - [Volume Configuration Examples](#volume-configuration-examples)
  - [Best Practices](#best-practices-5)
  - [Troubleshooting](#troubleshooting-4)
- [Lifecycle Hook Scripts](#lifecycle-hook-scripts)
  - [Overview](#overview-6)
  - [Hook Types](#hook-types)
  - [Pre-Install Hook](#pre-install-hook)
  - [Pre-Start Hook](#pre-start-hook)
  - [Post-Install Hook](#post-install-hook)
  - [Post-Start Hook](#post-start-hook)
  - [Kubernetes Lifecycle Hooks](#kubernetes-lifecycle-hooks)
  - [Execution Flow](#execution-flow)
  - [Configuration Examples](#configuration-examples)
  - [Best Practices](#best-practices-6)
  - [Troubleshooting](#troubleshooting-5)
- [Resource Management](#resource-management)
- [Probes](#probes)
- [Security Context](#security-context)
- [Migration](#migration)
  - [Legacy mode](#legacy-mode)
  - [Advanced mode](#advanced-mode)
  - [Examples](#examples)
  - [Precedence and compatibility](#precedence-and-compatibility)
  - [Service account and cloud identity](#service-account-and-cloud-identity)
- [Migration and Lifecycle Management](#migration-and-lifecycle-management)
  - [Overview](#overview-2)
  - [Migration CronJob](#migration-cronjob)
  - [Configuration](#configuration-1)
  - [Examples](#examples-1)
  - [S3 Bucket Configuration](#s3-bucket-configuration)
  - [Schedule Patterns](#schedule-patterns)
  - [Security Considerations](#security-considerations)
  - [Monitoring and Troubleshooting](#monitoring-and-troubleshooting)
  - [Known Limitations](#known-limitations)
  - [Best Practices](#best-practices-2)
- [Fluent Bit Integration](#fluent-bit-integration)
  - [Configuration](#configuration)
  - [Supported Outputs](#supported-outputs)
  - [Migration from Legacy Format](#migration-from-legacy-format)
  - [Troubleshooting](#troubleshooting-1)
- [Logging Configuration (Fluentd Sidecar)](#logging-configuration-fluentd-sidecar)
  - [Key Features](#key-features)
  - [Basic Configuration](#basic-configuration)
  - [Aggregator Types](#aggregator-types)
  - [Elasticsearch Curator Configuration](#elasticsearch-curator-configuration)
  - [Kibana Index Pattern Creation](#kibana-index-pattern-creation)
  - [Metrics Exporter Integration](#metrics-exporter-integration)
  - [Advanced Use Cases](#advanced-use-cases)
  - [Notes on Configuration](#notes-on-configuration)
  - [Troubleshooting Fluentd](#troubleshooting-fluentd)
  - [Comparison: Fluentd vs Fluent Bit](#comparison-fluentd-vs-fluent-bit)
  - [Best Practices for Fluentd Configuration](#best-practices-for-fluentd-configuration)
  - [When to Use Fluentd Sidecar](#when-to-use-fluentd-sidecar)
- [Metrics Configuration](#metrics-configuration)
  - [Overview](#overview-1)
  - [Architecture Comparison](#architecture-comparison)
  - [FID Exporter (metrics section)](#fid-exporter-metrics-section)
  - [Metrics Service (metricsService section)](#metrics-service-metricsservice-section)
  - [Combined Usage Example](#combined-usage-example)
  - [Use Case Scenarios](#use-case-scenarios)
  - [Troubleshooting](#troubleshooting-2)
  - [Migration Notes](#migration-notes)
  - [Best Practices](#best-practices-1)
  - [Metrics Reference](#metrics-reference)
  - [Integration Examples](#integration-examples)

---

## Prerequisites
* Kubernetes 1.24+
* Helm 3
* [Helm](https://helm.sh) must be installed to use the charts. Please refer to Helm's [documentation](https://helm.sh/docs) to get started.

## Quick Start

```console
helm install fid oci://ghcr.io/radiantlogic-devops/helm-v8/fid --version 1.2.2 \
--set fid.license=<license> \
```
**NOTE**
* Only 8.1.x versions are supported for this Helm deployment

---

## Installation

### Using helm --set values

To install the helm chart, run the following command:

```console
helm upgrade --install --namespace=<name space> <release name> oci://ghcr.io/radiantlogic-devops/helm-v8/fid --version 1.2.2 \
--set zk.clusterName=my-demo-cluster \
--set fid.license="<license key>" \
--set fid.rootPassword="test1234" \
```
---
**NOTE**
* Curly brackets in the license must be escaped --set fid.license="{rlib}xxx"

---

### Using values file

Create a file with these contents and save it as fid_values.yaml

```yaml
fid:
  rootPassword: "test1234"
  license: "<license key>"
zk:
  clusterName: "my-demo-cluster"
```
Run the following command
```console
helm upgrade --install --namespace=<name space> <release name> oci://ghcr.io/radiantlogic-devops/helm-v8/fid --version 1.2.2 \
--values fid_values.yaml
```

### Using Argo CD

For installation using Argo CD see this link - https://github.com/radiantlogic-devops/radiantone-argocd-helm

## Operations

### List Releases
```console
helm list --namespace=<name space>
```

### Test Release
```console
helm test <release name> --namespace=<name space>
```

### Upgrade Release
---
**NOTE**
* Upgrade can only be performed to a higher version

---

* Using --set values - set image.tag value
```console
helm upgrade --install --namespace=<name space> <release name> oci://ghcr.io/radiantlogic-devops/helm-v8/fid --version 1.2.2 \
--set image.tag=8.2.3 --reuse-values
```
* Using values file - update the values file with the newer version tag.
```yaml
image:
  tag: "8.2.3"
fid:
  rootPassword: "test1234"
  license: "<license key>"
zk:
  cluserName: "my-demo-cluster"
```

```console
helm upgrade --install --namespace=<name space> <release name> oci://ghcr.io/radiantlogic-devops/helm-v8/fid --version 1.2.2 --values fid_values.yaml --reuse-values
```

## Clean Up
* Delete FID release

```console
helm uninstall --namespace=<name space> <release name>
```
---
**NOTE**
* Does not delete the persistent volumes

---

## Global Settings

This section describes the global parameters that can be used to configure the behavior of the entire application.

### `eoc`

Controls Environment Operational Centre, control mode across services. When `true`, it enables enterprise-specific features and behaviors.

### `env`

A map of global environment variables passed to all deployment pods.

*Example:*

```yaml
global:
  env:
    AWS_REGION: us-east-1
```

### `compatibility`

This section allows for platform-specific adaptations, particularly for OpenShift.

*   **`openshift.adaptSecurityContext`**: Modifies security contexts to work with restricted SCCs.
    *   **`auto`**: Automatically detect and adapt.
    *   **`force`**: Always apply OpenShift adaptations.
    *   **`disabled`** or empty: No platform-specific changes.

### `hibernate`

If set to `true`, this will hibernate the application by scaling down pods to zero. The default value is `false`.

**Implementation Details:**

This value is used in the `templates/statefulset.yaml` file to control the number of replicas for the FID instance. When `global.hibernate` is set to `true`, the `replicas` field in the `StatefulSet` is set to `0`. This effectively scales down the application to zero pods, which can be useful for maintenance or to reduce resource consumption in non-production environments.

A non-technical user can think of this as a switch to turn the application off without deleting it.

### `nodeSelector`

Influences pod placement, which can affect performance and resource utilization.

**Implementation Details:**

The `nodeSelector` field in the `StatefulSet` definition in `templates/statefulset.yaml` is populated from `global.nodeSelector`. This allows you to control which nodes the FID pods are scheduled on. For example, you can use this to schedule pods on nodes with specific hardware or in a particular availability zone.

For a non-technical user, this is like assigning the application to run on a specific computer or group of computers in the cluster.

### `tolerations`

Tolerations allow the scheduler to schedule pods with matching taints.

**Implementation Details:**

The `tolerations` field in the `StatefulSet` definition in `templates/statefulset.yaml` is populated from `global.tolerations`. This is an advanced scheduling feature that allows you to schedule pods on nodes that have been "tainted" to repel other pods.

For a non-technical user, this is like giving the application a special permission to run on computers that are otherwise reserved for specific tasks.

### `affinity`

Node affinity is conceptually similar to `nodeSelector`, allowing you to constrain which nodes your Pod can be scheduled on based on node labels.

**Implementation Details:**

The `affinity` field in the `StatefulSet` definition in `templates/statefulset.yaml` is populated from `global.affinity`. This provides more advanced control over pod scheduling than `nodeSelector`, allowing you to specify rules based on node labels, pod labels, and other criteria.

For a non-technical user, this provides a more flexible way to assign the application to run on specific computers, for example, by saying "run on any computer in this group, but prefer computers in that group".

---

## Secrets Management

This section describes how secrets are managed in the FID deployment.

### `mountSecrets`

The `mountSecrets` parameter controls how secrets are exposed to the FID pods. This setting requires FID version 8.0.0 or newer.

*   **`mountSecrets: true`** (Default): When set to `true`, secrets are mounted as files into the pod's filesystem at `/etc/secrets/`. This is the recommended approach for modern deployments as it allows for hot-reloading of secrets without restarting the pod and is generally more secure.

*   **`mountSecrets: false`**: When set to `false`, secrets are exposed as environment variables to the FID pods. This is the legacy method and is required for FID versions older than 8.0.0.

**Important Considerations:**

*   For FID versions **older than 8.0.0**, you **must** set `mountSecrets: false`.
*   When `mountSecrets` is `true`, your application needs to be able to read secrets from the filesystem. When `false`, it will read them from environment variables.
*   Switching between these modes may require changes to your application's configuration.

**Implementation Details:**

The `mountSecrets` value determines how the `rootcreds-{{ template "fid.fullname" . }}` secret (defined in `templates/secret.yaml`) is used by the `StatefulSet` (defined in `templates/statefulset.yaml`).

*   When `mountSecrets: true`, the `rootcreds` secret is mounted as a volume at `/var/secrets` inside the FID container. The application can then read the secret values from files in this directory (e.g., `/var/secrets/fid-root-password`).

*   When `mountSecrets: false`, the values from the `rootcreds` secret are exposed as environment variables to the FID container (e.g., `FID_PASSWORD`, `ZK_PASSWORD`).

For a non-technical user, this setting controls whether the application reads its passwords from a secure file or from its environment.

---

## Image Credentials

This section explains how to configure credentials for pulling container images from private registries.

There are two ways to provide image pull credentials:

1.  **Using `imagePullSecrets`**: This is the recommended and most secure method. It involves creating a Kubernetes secret with your registry credentials and then referencing that secret in the `values.yaml` file.

2.  **Using `imageCredentials`**: This method involves putting your registry credentials directly in the `values.yaml` file. It is less secure and should only be used in development or testing environments.

### `imagePullSecrets`

The `imagePullSecrets` parameter is a list of Kubernetes secrets that contain credentials for pulling images from a private registry.

**Steps to use `imagePullSecrets`:**

1.  **Create a Kubernetes secret:**
    You can create a secret using `kubectl`:
    ```console
    kubectl create secret docker-registry <secret-name> --docker-server=<your-registry-server> --docker-username=<your-username> --docker-password=<your-password> --docker-email=<your-email>
    ```
    Replace `<secret-name>`, `<your-registry-server>`, `<your-username>`, `<your-password>`, and `<your-email>` with your actual credentials.

2.  **Reference the secret in `values.yaml`:**
    ```yaml
    imagePullSecrets:
      - name: <secret-name>
    ```

**Example:**

1.  Create the secret:
    ```console
    kubectl create secret docker-registry regcred --docker-server=docker.io --docker-username=myuser --docker-password=mypassword --docker-email=myuser@example.com
    ```

2.  Update `values.yaml`:
    ```yaml
    imagePullSecrets:
      - name: regcred
    ```

### `imageCredentials`

The `imageCredentials` parameter allows you to specify your registry credentials directly in the `values.yaml` file.

**Warning:** This method is not recommended for production environments as it exposes your credentials in plain text in the `values.yaml` file.

To use `imageCredentials`, you need to set `enabled` to `true` and provide your registry, username, and password.

```yaml
imageCredentials:
  enabled: true
  registry: docker.io
  username: myuser
  password: mypassword
  email: myuser@example.com
```

**Implementation Details:**

When `imageCredentials.enabled` is `true`, the `templates/imagepullsecrets.yaml` file is used to create a Kubernetes secret named `regcred` of type `kubernetes.io/dockerconfigjson`. This secret is then automatically referenced by the `StatefulSet` in `templates/statefulset.yaml` in the `imagePullSecrets` field. This allows the Kubernetes nodes to authenticate with your private registry and pull the FID image.

For a non-technical user, this is like providing a username and password for a private software repository so that the system can download the necessary files.

**Security Considerations:**

*   **Protect registry credentials**: Avoid committing `values.yaml` files with plain-text credentials to version control.
*   **Use minimal-privilege accounts**: The credentials you use should only have permission to pull images, not push or delete them.
*   **Regular credential rotation**: Regularly rotate your registry credentials to minimize the risk of them being compromised.
*   **Consider using external secrets**: For production environments, consider using a tool like HashiCorp Vault or AWS Secrets Manager to manage your secrets and inject them into your cluster.

---

## Service Account

This section explains how to configure the Kubernetes Service Account for the FID deployment. A Service Account provides an identity for processes that run in a Pod.

### `serviceAccount.create`

This boolean value determines whether a dedicated Service Account should be created for the FID deployment.

*   **`serviceAccount.create: true`**: A new Service Account will be created with the name defined by the fullname template (e.g., `<release-name>-fid`) or by the `serviceAccount.name` parameter.
*   **`serviceAccount.create: false`** (Default): No new Service Account is created. The deployment will use the default Service Account of the namespace.

**Implementation Details:**

The `serviceAccount.create` value controls whether the `templates/serviceaccount.yaml` file is rendered. When set to `true`, a `ServiceAccount` manifest is generated. The `StatefulSet` in `templates/statefulset.yaml` is then configured to use this Service Account by setting the `serviceAccountName` field in the pod's spec.

For a non-technical user, creating a Service Account is like creating a specific user account for the application to interact with the system, which is more secure than using a shared, default account.

### `serviceAccount.annotations`

This allows you to add custom annotations to the Service Account. Annotations are key-value pairs that can be used to attach arbitrary non-identifying metadata to objects.

**Example:**

A common use case for annotations is to associate an IAM role with the Service Account for accessing cloud provider resources (e.g., AWS S3, GCS buckets).

```yaml
serviceAccount:
  create: true
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::123456789012:role/MyFidRole
```

**Implementation Details:**

The annotations provided in `serviceAccount.annotations` are added to the `metadata.annotations` field of the `ServiceAccount` manifest in `templates/serviceaccount.yaml`.

For a non-technical user, annotations are like adding labels or tags to the application's user account that can grant it special permissions to access other services.

### `serviceAccount.name`

This allows you to specify a custom name for the Service Account.

*   If a name is provided, it will be used for the created Service Account.
*   If no name is provided, a name will be generated using the fullname template (e.g., `<release-name>-fid`).

**Example:**

```yaml
serviceAccount:
  create: true
  name: my-fid-service-account
```

**Implementation Details:**

The `serviceAccount.name` value is used in `templates/serviceaccount.yaml` to set the `metadata.name` of the `ServiceAccount`. It is also used in `templates/statefulset.yaml` to set the `serviceAccountName` for the pods. This is useful if you want to use a pre-existing Service Account or if you have specific naming conventions.

For a non-technical user, this is like giving a custom username to the application's account.

---

## Dependencies Configuration

### Overview

The FID Helm chart uses a dependency management system to include and configure external charts required for the application to function. Dependencies provide essential services like distributed coordination (ZooKeeper), log aggregation (Fluent Bit), and common Helm utilities.

**Key Concepts:**
- **Chart Dependencies**: External Helm charts that are packaged with your main chart
- **Conditional Dependencies**: Dependencies that can be enabled or disabled based on your needs
- **Configuration Inheritance**: Values passed down from parent chart to dependency charts
- **Version Locking**: Specific versions ensure compatibility and stability

### Available Dependencies

Based on `Chart.yaml`, this chart includes three dependencies:

| Dependency | Alias | Version | Repository | Purpose | Condition |
|------------|-------|---------|------------|---------|-----------|
| zookeeper-helm | zookeeper | 0.1.6 | oci://registry-1.docker.io/radiantone | Distributed coordination service | `dependencies.zookeeper.enabled` |
| fluent-bit | fluent-bit | 0.39.0 | https://fluent.github.io/helm-charts | Log collector and forwarder | `fluent-bit.enabled` |
| common | common | 2.x.x | https://charts.bitnami.com/bitnami | Bitnami common library functions | Always enabled |

### Dependency Configuration

Dependencies are configured through two main sections in `values.yaml`:

#### 1. Dependency Enablement
Controls whether a dependency chart should be installed:

```yaml
dependencies:
  zookeeper:
    enabled: true  # Set to false to use external ZooKeeper
```

#### 2. Dependency Values
Provides configuration values to the dependency chart:

```yaml
# Values passed to the zookeeper dependency chart
zookeeper:
  fullnameOverride: zookeeper
  alternateName: fid
  replicaCount: 3
  persistence:
    enabled: false
    storageClass: ""

# Values passed to the fluent-bit dependency chart
fluent-bit:
  enabled: false
  hotReload:
    enabled: true
  # ... additional fluent-bit configuration
```

### ZooKeeper Dependency

ZooKeeper provides distributed coordination for FID cluster management. It can be deployed in two modes:

#### Internal ZooKeeper (Managed)
When `dependencies.zookeeper.enabled: true`, the chart deploys its own ZooKeeper cluster:

```yaml
dependencies:
  zookeeper:
    enabled: true

zookeeper:
  fullnameOverride: zookeeper  # Sets the service name to 'zookeeper'
  alternateName: fid           # Additional naming context
  replicaCount: 3              # Number of ZooKeeper nodes
  persistence:
    enabled: true               # Enable persistent storage
    storageClass: "gp3"        # Storage class to use
    size: 10Gi                 # Storage size per node
  resources:
    requests:
      memory: "256Mi"
      cpu: "250m"
    limits:
      memory: "512Mi"
      cpu: "500m"
```

**Connection Details:**
- Service Name: `zookeeper-app` (constructed from fullnameOverride + "-app")
- Port: 2181 (ZooKeeper client port)
- Connection String: `zookeeper-app:2181`

#### External ZooKeeper
When using an existing ZooKeeper cluster:

```yaml
dependencies:
  zookeeper:
    enabled: false  # Don't deploy ZooKeeper

zk:
  external: true
  connectionString: "external-zk-1:2181,external-zk-2:2181,external-zk-3:2181"
  clusterName: "fid-cluster"
```

**Template Behavior:**
- When `zk.external: true`, StatefulSet adds an initContainer to check ZooKeeper connectivity
- The `ZK_CONN_STR` ConfigMap entry uses the provided connection string
- No ZooKeeper pods are created by this chart

### Fluent Bit Dependency

Fluent Bit provides log collection and forwarding as a DaemonSet. It's configured through the `fluent-bit` values section:

```yaml
fluent-bit:
  enabled: true  # Deploy Fluent Bit DaemonSet

  # Hot reload support for configuration changes
  hotReload:
    enabled: true
    image:
      repository: ghcr.io/jimmidyson/configmap-reload
      tag: v0.11.1
    resources:
      limits:
        cpu: 100m
        memory: 128Mi

  # Fluent Bit configuration
  flush: 1
  logLevel: info
  metricsPort: 2020

  # Service configuration
  service:
    type: ClusterIP
    port: 2020
    labels: {}
    annotations: {}

  # DaemonSet pod configuration
  tolerations:
    - key: node-role.kubernetes.io/master
      operator: Exists
      effect: NoSchedule
```

**Integration with FID:**
- Custom ConfigMap (`fluent-bit-config`) created when enabled
- Automatic log parsing and forwarding based on `logs` and `aggregators` configuration
- Supports both legacy and multi-aggregator configurations

### Common Library Dependency

The Bitnami common library provides reusable Helm template functions used throughout the chart:

**Functions Used:**
- `common.labels`: Generates standard Kubernetes labels
- `common.selectorLabels`: Generates selector labels for services and deployments
- `common.compatibility.renderSecurityContext`: Handles security context rendering for different Kubernetes versions and platforms (especially OpenShift)

**Usage Example from Templates:**
```yaml
metadata:
  labels:
    {{- include "common.labels" . | nindent 4 }}
```

This dependency is always included and doesn't require explicit enablement. It provides:
- Consistent labeling across all resources
- Platform compatibility helpers
- Security context adaptations
- Version compatibility utilities

### Dependency Management Commands

#### Download Dependencies
Before installing the chart, download dependencies:
```bash
helm dependency update ./charts/fid
```

#### List Dependencies
View chart dependencies and their status:
```bash
helm dependency list ./charts/fid
```

#### Build Dependencies
Package dependencies into the charts/ directory:
```bash
helm dependency build ./charts/fid
```

#### Installing with Dependencies
Install the chart with all enabled dependencies:
```bash
helm install fid ./charts/fid \
  --set dependencies.zookeeper.enabled=true \
  --set zookeeper.replicaCount=3 \
  --set fluent-bit.enabled=true
```

#### Upgrading Dependencies
To upgrade to newer dependency versions:
1. Update versions in `Chart.yaml`
2. Run `helm dependency update`
3. Test the chart with new dependencies
4. Upgrade existing releases

### Configuration Precedence

Understanding how values are passed to dependencies:

1. **Default Values**: Each dependency chart has its own `values.yaml`
2. **Parent Override**: Values from the parent chart's `values.yaml` under the dependency name
3. **User Override**: Values provided via `--set` or `-f values.yaml` during install/upgrade

**Example Precedence:**
```yaml
# 1. ZooKeeper chart's default: replicaCount: 1
# 2. FID chart's values.yaml:
zookeeper:
  replicaCount: 3  # Overrides default
# 3. User command:
--set zookeeper.replicaCount=5  # Final value used
```

### Best Practices

1. **Version Pinning**: Always specify exact versions in `Chart.yaml` for production
   ```yaml
   dependencies:
     - name: zookeeper-helm
       version: "0.1.6"  # Not "^0.1.6" or "~0.1.6"
   ```

2. **Resource Limits**: Configure resource limits for all dependencies
   ```yaml
   zookeeper:
     resources:
       limits:
         memory: "512Mi"
         cpu: "500m"
   ```

3. **Persistence Configuration**: Enable persistence for stateful dependencies
   ```yaml
   zookeeper:
     persistence:
       enabled: true
       storageClass: "fast-ssd"
       size: 20Gi
   ```

4. **Network Policies**: Consider network policies when using dependencies
   ```yaml
   zookeeper:
     networkPolicy:
       enabled: true
       allowExternal: false
   ```

5. **Monitoring Integration**: Configure metrics exposure for dependencies
   ```yaml
   fluent-bit:
     metrics:
       enabled: true
       serviceMonitor:
         enabled: true
   ```

6. **Conditional Logic in Templates**: Check dependency status in templates
   ```yaml
   {{- if .Values.dependencies.zookeeper.enabled }}
   # Use internal ZooKeeper service
   {{- else }}
   # Use external connection string
   {{- end }}
   ```

7. **Documentation**: Document any custom dependency configurations in your values files
   ```yaml
   # Custom ZooKeeper configuration for production environment
   # Requires minimum 3 nodes for quorum
   zookeeper:
     replicaCount: 3  # DO NOT change in production
   ```

8. **Testing**: Test chart with dependencies both enabled and disabled
   ```bash
   # Test with internal ZooKeeper
   helm install --dry-run --debug fid ./charts/fid

   # Test with external ZooKeeper
   helm install --dry-run --debug fid ./charts/fid \
     --set dependencies.zookeeper.enabled=false \
     --set zk.external=true
   ```

---

## Persistence

This section describes the parameters for configuring persistent storage for the FID deployment. Persistent storage is used to store data that needs to survive pod restarts.

### `persistence.enabled`

This boolean value determines whether to use a `PersistentVolumeClaim` to provision persistent storage for FID.

*   **`persistence.enabled: true`** (Default): A `PersistentVolumeClaim` is created, and the data directory (`/opt/radiantone/vds`) is mounted to the persistent volume.
*   **`persistence.enabled: false`**: An `emptyDir` volume is used, which means that all data will be lost when the pod is deleted. This is not recommended for production environments.

**Implementation Details:**

The `persistence.enabled` value controls whether a `volumeClaimTemplates` section is added to the `StatefulSet` definition in `templates/statefulset.yaml`. When `true`, a `PersistentVolumeClaim` is created for each pod in the `StatefulSet`.

For a non-technical user, enabling persistence is like giving the application a dedicated hard drive to store its data so that it doesn't get lost if the application is restarted.

### `persistence.annotations`

This allows you to add custom annotations to the `PersistentVolumeClaim`.

**Example:**

```yaml
persistence:
  annotations:
    volume.beta.kubernetes.io/storage-provisioner: "kubernetes.io/aws-ebs"
```

### `persistence.accessModes`

This specifies the access modes for the persistent volume. The default is `[ReadWriteOnce]`.

**Example:**

```yaml
persistence:
  accessModes:
    - ReadWriteOnce
```

### `persistence.size`

This specifies the size of the persistent volume.

**Example:**

```yaml
persistence:
  size: 10Gi
```

### `persistence.storageClass`

This specifies the `storageClassName` for the `PersistentVolumeClaim`. If not specified, the default `StorageClass` is used.

**Example:**

```yaml
persistence:
  storageClass: "gp2"
```

**Implementation Details:**

The `persistence` values are used in the `volumeClaimTemplates` section of the `StatefulSet` in `templates/statefulset.yaml` to define the `PersistentVolumeClaim` for the FID data.

For a non-technical user, these settings control the size and type of the dedicated hard drive that the application uses to store its data.

---

## Environment Variables Configuration

### Overview

The FID Helm chart provides a comprehensive environment variable configuration system that supports multiple sources and security levels. This flexible system allows you to configure application behavior through various methods, from simple key-value pairs to complex secret references.

**Key Features:**
- Multiple configuration methods (direct values, secrets, ConfigMaps)
- Template support for dynamic values
- Security-focused design with secret management
- Hierarchical configuration with precedence rules
- Support for both individual and bulk environment variables

**Implementation Context:**
Based on the provided `install.sh` script, FID uses environment variables to configure critical settings during initialization, including:
- License configuration (`LICENSE`)
- Cluster settings (`CLUSTER`, `NODE_TYPE`)
- ZooKeeper configuration (`ZK_CONN_STR`, `ZK_CLUSTER`)
- Authentication credentials (`FID_ROOT_USER`, `FID_PASSWORD`)
- Network ports (LDAP, HTTP/HTTPS, Admin)
- Security settings (`PBE_ENABLED`)

### Configuration Methods

The chart supports six different methods for configuring environment variables, each suited for different use cases:

| Method | Purpose | Security Level | Use Case |
|--------|---------|---------------|----------|
| `env` | Direct key-value pairs | Low | Non-sensitive configuration |
| `envValueFrom` | Reference ConfigMaps/Secrets | Medium | Dynamic configuration |
| `envFromSecret` | Load entire Secret | High | Bulk sensitive data |
| `envRenderSecret` | Generate new Secret | High | Template-based secrets |
| `envFromSecrets` | Multiple Secrets | High | Modular secret management |
| `envFromConfigMaps` | Multiple ConfigMaps | Low | Modular configuration |

### Direct Values (env)

Simple key-value environment variables injected directly into pods.

**Configuration:**
```yaml
env:
  LOG_LEVEL: "debug"
  ENABLE_METRICS: "true"
  CACHE_SIZE: "1024"
  API_TIMEOUT: "30s"
```

**Template Implementation:**
```yaml
# In statefulset.yaml
env:
{{- range $key, $value := .Values.env }}
  - name: "{{ tpl $key $ }}"
    value: "{{ tpl (print $value) $ }}"
{{- end }}
```

**Features:**
- Supports templating for both keys and values
- Immediate availability in pod environment
- Best for non-sensitive configuration

**Real Example from FID:**
```yaml
env:
  CLUSTER: "new"              # Cluster initialization mode
  NODE_TYPE: "core"           # Node type (core/follower)
  INSTALL_SAMPLES: "false"    # Whether to install sample data
  PBE_ENABLED: "false"        # Password-based encryption
  DEBUG: "true"               # Enable debug logging
```

### Value References (envValueFrom)

Reference specific keys from existing ConfigMaps or Secrets.

**Note:** This feature is defined in `values.yaml` but not currently implemented in the templates. To use it, you would need to add the implementation.

**Intended Configuration:**
```yaml
envValueFrom:
  DATABASE_URL:
    secretKeyRef:
      name: database-credentials
      key: connection-string

  API_ENDPOINT:
    configMapKeyRef:
      name: app-config
      key: api-url

  AWS_REGION:
    configMapKeyRef:
      name: cloud-config
      key: region
```

**Expected Template Implementation:**
```yaml
# Would render as:
env:
  - name: DATABASE_URL
    valueFrom:
      secretKeyRef:
        name: database-credentials
        key: connection-string
  - name: API_ENDPOINT
    valueFrom:
      configMapKeyRef:
        name: app-config
        key: api-url
```

### Secret References (envFromSecret)

Load all key-value pairs from an existing Secret as environment variables.

**Configuration:**
```yaml
envFromSecret: "my-app-secrets"
```

**Template Implementation:**
```yaml
# In statefulset.yaml
envFrom:
{{- if .Values.envFromSecret }}
  - secretRef:
      name: {{ tpl .Values.envFromSecret . }}
{{- end }}
```

**Example Secret Creation:**
```bash
kubectl create secret generic my-app-secrets \
  --from-literal=DB_PASSWORD=secretpass \
  --from-literal=API_KEY=myapikey \
  --from-literal=JWT_SECRET=jwtsecret
```

**Use Case Example:**
```yaml
# External secret with all FID credentials
envFromSecret: "fid-credentials"

# The secret might contain:
# FID_PASSWORD: <encrypted>
# ZK_PASSWORD: <encrypted>
# LICENSE: {rlib}xxxxx...
# AS_PASSWORD: <encrypted>
```

### Generated Secrets (envRenderSecret)

Create a new Secret from templated values defined in the chart.

**Note:** While referenced in `statefulset.yaml`, there's no template that creates this secret. This would need to be implemented.

**Intended Configuration:**
```yaml
envRenderSecret:
  API_TOKEN: "{{ randAlphaNum 32 }}"
  SESSION_SECRET: "{{ randAlphaNum 64 }}"
  ENCRYPTION_KEY: "{{ .Values.global.encryptionKey | b64enc }}"
```

**Expected Secret Generation:**
```yaml
# Would create a secret named: <release>-fid-env
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "fid.fullname" . }}-env
type: Opaque
data:
  API_TOKEN: <base64-encoded-random-32-chars>
  SESSION_SECRET: <base64-encoded-random-64-chars>
  ENCRYPTION_KEY: <base64-encoded-encryption-key>
```

### Multiple Secrets (envFromSecrets)

Load environment variables from multiple Secrets with optional flags.

**Configuration:**
```yaml
envFromSecrets:
  - name: database-secrets
    optional: false  # Pod fails if secret doesn't exist

  - name: feature-flags
    optional: true   # Pod starts even if secret is missing

  - name: "{{ .Release.Name }}-credentials"  # Templated name
    optional: false
```

**Template Implementation:**
```yaml
# In statefulset.yaml
envFrom:
{{- range .Values.envFromSecrets }}
  - secretRef:
      name: {{ tpl .name $ }}
      {{- if .optional }}
      optional: {{ .optional }}
      {{- end }}
{{- end }}
```

**Real-World Scenario:**
```yaml
envFromSecrets:
  # Required secrets for core functionality
  - name: fid-core-secrets
    optional: false

  # Optional integration credentials
  - name: ldap-sync-credentials
    optional: true

  # Environment-specific secrets
  - name: "{{ .Values.environment }}-secrets"
    optional: false
```

### ConfigMap References (envFromConfigMaps)

Load environment variables from multiple ConfigMaps.

**Configuration:**
```yaml
envFromConfigMaps:
  - name: app-config
    optional: false

  - name: feature-toggles
    optional: true

  - name: "{{ .Release.Name }}-config"
    optional: false
```

**Template Implementation:**
```yaml
# In statefulset.yaml
envFrom:
{{- range .Values.envFromConfigMaps }}
  - configMapRef:
      name: {{ tpl .name $ }}
      {{- if .optional }}
      optional: {{ .optional }}
      {{- end }}
{{- end }}
```

**Example ConfigMap:**
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  LOG_FORMAT: "json"
  CACHE_ENABLED: "true"
  MAX_CONNECTIONS: "100"
  TIMEOUT_SECONDS: "30"
```

### FID-Specific Environment Variables

Based on the `install.sh` script analysis, here are the critical FID environment variables:

#### Core Configuration
| Variable | Default | Description | Source |
|----------|---------|-------------|--------|
| `LICENSE` | Required | FID license key | Secret/env |
| `CLUSTER` | "new" | Cluster mode (new/join) | ConfigMap |
| `NODE_TYPE` | "core" | Node type (core/follower) | ConfigMap |
| `ZK` | "local" | ZooKeeper mode (local/external) | ConfigMap |

#### Authentication & Security
```yaml
# Automatically injected from secrets when mountSecrets: false
env:
  # These are set via secretKeyRef in the template
  FID_ROOT_USER: "cn=Directory Manager"  # From rootcreds secret
  FID_PASSWORD: "<from-secret>"          # From rootcreds secret
  ZK_USER: "admin"                        # From rootcreds secret
  ZK_PASSWORD: "<from-secret>"           # From rootcreds secret
  AS_LOGIN: "admin"                       # Application server login
  AS_PASSWORD: "<from-secret>"           # Application server password
```

#### Network Ports
```yaml
env:
  # LDAP Ports
  FID_LDAP_PORT: "2389"
  FID_LDAPS_PORT: "2636"

  # HTTP/HTTPS Ports
  FID_HTTP_PORT: "8089"
  FID_HTTPS_PORT: "8090"

  # Admin Ports
  FID_ADMIN_HTTP_PORT: "9100"
  FID_ADMIN_HTTPS_PORT: "9101"

  # Control Panel Ports
  CP_HTTP_PORT: "7070"
  CP_HTTPS_PORT: "7171"

  # Other Service Ports
  SCHEDULER_PORT: "1099"
  AS_ADMIN_PORT: "4848"
  AS_JMX_PORT: "8686"

  # ZooKeeper Ports
  ZK_CLIENT_PORT: "2181"
  ZK_LEADER_PORT: "3888"
  ZK_ENSEMBLE_PORT: "2888"
  ZK_JMX_PORT: "2182"
```

#### Feature Flags
```yaml
env:
  INSTALL_SAMPLES: "false"    # Install sample data
  PBE_ENABLED: "false"        # Password-based encryption
  DEBUG: "false"              # Debug mode
```

### Configuration Precedence

Environment variables are applied in the following order (later overrides earlier):

1. **ConfigMap from template** (`configmap.yaml`)
   - Base configuration like `ZK_CONN_STR`, `ZK_CLUSTER`

2. **envFromConfigMaps** (if configured)
   - Bulk ConfigMap imports

3. **envFromSecret** (single secret reference)
   - Single secret import

4. **envRenderSecret** (generated secret)
   - Dynamically generated secret values

5. **envFromSecrets** (multiple secrets)
   - Multiple secret imports

6. **Secret-based env vars** (automatic)
   - FID credentials from `rootcreds-<release>` secret

7. **Direct env values**
   - Highest precedence, overwrites all others

**Example Precedence:**
```yaml
# 1. ConfigMap sets: LOG_LEVEL=info
# 2. envFromSecret has: LOG_LEVEL=warning
# 3. env has: LOG_LEVEL=debug
# Result: LOG_LEVEL=debug (env wins)
```

### Best Practices

1. **Security First**
   ```yaml
   # DON'T: Put secrets in env
   env:
     PASSWORD: "mysecret"  # Bad!

   # DO: Use secrets
   envFromSecret: "app-secrets"
   ```

2. **Use Appropriate Methods**
   ```yaml
   # Non-sensitive: Use env or ConfigMaps
   env:
     LOG_LEVEL: "info"
     FEATURE_FLAG: "true"

   # Sensitive: Use Secrets
   envFromSecrets:
     - name: database-credentials
       optional: false
   ```

3. **Template for Flexibility**
   ```yaml
   env:
     ENVIRONMENT: "{{ .Values.environment }}"
     NAMESPACE: "{{ .Release.Namespace }}"
     VERSION: "{{ .Chart.AppVersion }}"
   ```

4. **Group Related Variables**
   ```yaml
   # Create separate ConfigMaps/Secrets by domain
   envFromConfigMaps:
     - name: network-config      # Ports, endpoints
     - name: feature-config      # Feature flags
     - name: monitoring-config   # Metrics, logging

   envFromSecrets:
     - name: auth-secrets        # Passwords, tokens
     - name: integration-secrets # API keys
   ```

5. **Document Required Variables**
   ```yaml
   # values.yaml
   env:
     # REQUIRED: Set your environment
     ENVIRONMENT: ""  # dev/staging/prod

     # OPTIONAL: Override defaults
     LOG_LEVEL: "info"  # debug/info/warning/error
   ```

6. **Validate Critical Variables**
   ```yaml
   # Use initContainers to validate
   initContainers:
     - name: validate-env
       image: alpine
       command: ["/bin/sh", "-c"]
       args:
         - |
           if [ -z "$LICENSE" ]; then
             echo "ERROR: LICENSE not set"
             exit 1
           fi
   ```

7. **Use Optional Flags Wisely**
   ```yaml
   envFromSecrets:
     # Core functionality - required
     - name: core-secrets
       optional: false

     # Nice to have - optional
     - name: telemetry-secrets
       optional: true
   ```

8. **Avoid Duplication**
   ```yaml
   # DON'T: Define same var multiple times
   env:
     API_URL: "http://api"
   envFromConfigMaps:
     - name: config  # Also has API_URL

   # DO: Use one source of truth
   envFromConfigMaps:
     - name: config  # Single source for API_URL
   ```

### Troubleshooting

#### Check Environment Variables in Running Pod
```bash
# List all env vars
kubectl exec <pod-name> -- env | sort

# Check specific variable
kubectl exec <pod-name> -- printenv LICENSE

# Check if secret is mounted
kubectl get pod <pod-name> -o yaml | grep -A5 envFrom
```

#### Verify Secret/ConfigMap Exists
```bash
# Check secrets
kubectl get secrets
kubectl describe secret <secret-name>

# Check ConfigMaps
kubectl get configmaps
kubectl describe configmap <configmap-name>
```

#### Debug Template Rendering
```bash
# See what env vars will be set
helm template . --values values.yaml | grep -A20 "env:"

# Check for missing values
helm template . --values values.yaml --debug
```

#### Common Issues and Solutions

**Issue: Environment variable not set**
```yaml
# Check precedence - later source might override
# Check if secret/configmap exists
# Verify optional flag isn't hiding errors
```

**Issue: Pod fails to start due to missing secret**
```yaml
envFromSecrets:
  - name: my-secret
    optional: true  # Set to true if secret might not exist
```

**Issue: Special characters in values**
```yaml
env:
  # Use quotes for special characters
  CONNECTION_STRING: "host=db;password=p@ss;port=5432"
  # Or use ||- for multiline
  CERTIFICATE: ||-
    -----BEGIN CERTIFICATE-----
    MIIDtTCCAp2gAwIBAgIJAKg...
    -----END CERTIFICATE-----
```

**Issue: Template not rendering**
```yaml
# Ensure proper templating syntax
env:
  NAMESPACE: "{{ .Release.Namespace }}"  # Correct
  # Not: NAMESPACE: {{ .Release.Namespace }}  # May fail with special chars
```

---

## Volume Management Configuration

### Overview

The FID Helm chart provides a flexible volume management system that allows you to mount additional storage, configuration files, certificates, and other resources into your pods. This system supports various volume types and mount scenarios to meet different operational requirements.

**Key Features:**
- Support for multiple volume types (ConfigMaps, Secrets, PVC, EmptyDir, etc.)
- Flexible volume mounting for main and sidecar containers
- Template support for dynamic volume definitions
- Integration with Kubernetes native volume types
- Special-purpose volumes for migrations and configurations

**Volume Configuration Layers:**
1. **Default Volumes**: Automatically created by the chart
2. **Extra Volumes**: Additional volumes you define
3. **Extra Volume Mounts**: Mount points for extra volumes
4. **Container Volumes**: Additional volume definitions with templating
5. **Sidecar Containers**: Additional containers with their own volumes

### Default Volumes

The chart automatically creates several volumes based on your configuration:

#### 1. Primary Data Volume (`r1-pvc`)
```yaml
# Created when persistence.enabled: true (VolumeClaimTemplate)
# Created when persistence.enabled: false (EmptyDir)
- name: r1-pvc
  mountPath: /opt/radiantone/vds
```

#### 2. Scripts Volume
```yaml
# Always created as EmptyDir for temporary scripts
- name: scripts
  emptyDir: {}
  mountPath: /opt/radiantone/scripts
```

#### 3. Migrations Volume
```yaml
# When migration.file is set (ConfigMap)
- name: migrations
  configMap:
    name: {{ template "fid.fullname" . }}-migration

# Otherwise (EmptyDir)
- name: migrations
  emptyDir: {}
  mountPath: /migrations
```

#### 4. Credentials Volume
```yaml
# When fid.mountSecrets: true
- name: fid-creds
  secret:
    defaultMode: 288  # 0440 in octal
    secretName: rootcreds-{{ template "fid.fullname" . }}
  mountPath: /var/secrets
```

#### 5. Fluentd Configuration Volume
```yaml
# When metrics.fluentd.enabled: true
- name: fluentd-config-volume
  configMap:
    name: fluentd-config
  mountPath: /fluentd/etc
```

#### 6. Auto-Config Promotion Volume
```yaml
# When autoConfigPromotion.enabled: true
- name: {{ include "fid.auto_config.promotion.pvc_name" . }}
  persistentVolumeClaim:
    claimName: {{ include "fid.auto_config.promotion.pvc_name" . }}
  mountPath: {{ .Values.autoConfigPromotion.volumeMountPath }}
```

### Extra Volumes (extraVolumes)

Define additional volumes to be added to the pod specification.

**Configuration:**
```yaml
extraVolumes:
  # Secret volume for certificates
  - name: fid-keystore
    secret:
      defaultMode: 288  # 0440 - read-only for owner/group
      secretName: fid-keystore

  # ConfigMap volume for configuration
  - name: app-config
    configMap:
      name: app-configuration
      defaultMode: 420  # 0644 - standard file permissions

  # PersistentVolumeClaim for shared storage
  - name: shared-data
    persistentVolumeClaim:
      claimName: shared-pvc

  # EmptyDir for temporary data
  - name: temp-storage
    emptyDir:
      sizeLimit: 1Gi

  # HostPath volume (use with caution)
  - name: host-logs
    hostPath:
      path: /var/log/host
      type: DirectoryOrCreate
```

**Template Implementation:**
```yaml
# In statefulset.yaml
volumes:
{{- if .Values.extraVolumes }}
  {{- include "common.tplvalues.render" ( dict "value" .Values.extraVolumes "context" $ ) | nindent 6 }}
{{- end }}
```

### Volume Mounts (extraVolumeMounts)

Define where extra volumes should be mounted in containers.

**Configuration:**
```yaml
extraVolumeMounts:
  # Mount certificates
  - name: fid-keystore
    mountPath: /certs/keystore
    readOnly: true

  # Mount configuration
  - name: app-config
    mountPath: /etc/app-config
    readOnly: true

  # Mount shared data with subPath
  - name: shared-data
    mountPath: /data/shared
    subPath: app-data

  # Mount with specific permissions
  - name: temp-storage
    mountPath: /tmp/processing
    readOnly: false
```

**Template Implementation:**
```yaml
# In statefulset.yaml (main container)
volumeMounts:
{{- if .Values.extraVolumeMounts }}
  {{- include "common.tplvalues.render" ( dict "value" .Values.extraVolumeMounts "context" $ ) | nindent 8 }}
{{- end }}
```

### Container Volumes (extraContainerVolumes)

Alternative method for defining volumes with full template support.

**Configuration:**
```yaml
extraContainerVolumes:
  # Dynamic volume based on release name
  - name: "{{ .Release.Name }}-config"
    configMap:
      name: "{{ .Release.Name }}-configuration"

  # Conditional volume
  {{- if .Values.tlsEnabled }}
  - name: tls-certs
    secret:
      secretName: "{{ .Values.tlsSecretName }}"
  {{- end }}

  # Volume with items selection
  - name: selective-config
    configMap:
      name: full-config
      items:
        - key: app.properties
          path: application.properties
        - key: log4j.xml
          path: logging-config.xml
```

**Template Implementation:**
```yaml
# In statefulset.yaml
volumes:
{{- with .Values.extraContainerVolumes }}
  {{- tpl (toYaml .) $ | nindent 6 }}
{{- end }}
```

### Sidecar Containers (sidecars)

Add additional containers to pods with their own volume mounts.

**Configuration:**
```yaml
sidecars:
  # Logging sidecar
  - name: log-forwarder
    image: fluent/fluent-bit:latest
    imagePullPolicy: Always
    volumeMounts:
      - name: r1-pvc
        mountPath: /logs
        subPath: vds_server/logs
        readOnly: true
      - name: fluent-config
        mountPath: /fluent-bit/etc
    ports:
      - name: metrics
        containerPort: 2020

  # Backup sidecar
  - name: backup-agent
    image: backup-tool:latest
    env:
      - name: BACKUP_SCHEDULE
        value: "0 2 * * *"
    volumeMounts:
      - name: r1-pvc
        mountPath: /data
        readOnly: true
      - name: backup-storage
        mountPath: /backups

  # Monitoring sidecar
  - name: metrics-collector
    image: prom/node-exporter:latest
    args:
      - --path.rootfs=/host
    volumeMounts:
      - name: host-root
        mountPath: /host
        readOnly: true
```

**Template Implementation:**
```yaml
# In statefulset.yaml
containers:
  - name: {{ include "fid.fullname" . }}
    # Main container configuration

{{- if .Values.sidecars }}
  # Sidecar containers
  {{- include "common.tplvalues.render" ( dict "value" .Values.sidecars "context" $ ) | nindent 6 }}
{{- end }}
```

### Special Purpose Volumes

#### Migration Volumes (Advanced)
For advanced migration configurations:

```yaml
# Git repository with SSH authentication
fid:
  migration:
    advanced:
      enabled: true
      source:
        type: git
        git:
          auth:
            sshKeySecretRef:
              name: git-ssh-key
            knownHostsConfigMapRef:
              name: git-known-hosts
              key: known_hosts

# Creates volumes:
# - git-ssh-key (from Secret)
# - git-known-hosts (from ConfigMap)
```

#### GCP Service Account Key Volume
```yaml
# For GCS migration source
fid:
  migration:
    advanced:
      source:
        type: gcs
        gcs:
          auth:
            serviceAccountKeySecretRef:
              name: gcp-sa-key

# Creates volume:
# - gcp-sa-key (from Secret)
```

### Volume Configuration Examples

#### Example 1: TLS/SSL Configuration
```yaml
# Create secrets first
kubectl create secret tls fid-tls \
  --cert=server.crt \
  --key=server.key

kubectl create secret generic fid-truststore \
  --from-file=truststore.jks

# values.yaml
extraVolumes:
  - name: fid-tls
    secret:
      secretName: fid-tls
      defaultMode: 288
  - name: fid-truststore
    secret:
      secretName: fid-truststore
      defaultMode: 288

extraVolumeMounts:
  - name: fid-tls
    mountPath: /opt/radiantone/vds/vds_server/conf/certs
    readOnly: true
  - name: fid-truststore
    mountPath: /opt/radiantone/vds/vds_server/conf/truststore
    readOnly: true
```

#### Example 2: Custom Configuration Files
```yaml
# Create ConfigMap
kubectl create configmap custom-config \
  --from-file=custom.properties \
  --from-file=features.xml

# values.yaml
extraVolumes:
  - name: custom-config
    configMap:
      name: custom-config
      items:
        - key: custom.properties
          path: app.properties
        - key: features.xml
          path: features.xml

extraVolumeMounts:
  - name: custom-config
    mountPath: /opt/radiantone/vds/vds_server/conf/custom
    readOnly: true
```

#### Example 3: Shared Storage Between Containers
```yaml
extraVolumes:
  - name: shared-workspace
    emptyDir:
      sizeLimit: 5Gi

extraVolumeMounts:
  - name: shared-workspace
    mountPath: /workspace

sidecars:
  - name: data-processor
    image: processor:latest
    volumeMounts:
      - name: shared-workspace
        mountPath: /workspace
```

#### Example 4: Log Collection Setup
```yaml
extraVolumes:
  - name: varlog
    hostPath:
      path: /var/log
      type: Directory

sidecars:
  - name: log-collector
    image: elastic/filebeat:7.10.0
    volumeMounts:
      - name: r1-pvc
        mountPath: /logs/fid
        subPath: vds_server/logs
        readOnly: true
      - name: varlog
        mountPath: /var/log
        readOnly: true
    env:
      - name: ELASTICSEARCH_HOST
        value: "elasticsearch.logging:9200"
```

#### Example 5: Cloud Provider Integration
```yaml
# AWS EFS
extraVolumes:
  - name: efs-storage
    persistentVolumeClaim:
      claimName: efs-pvc

# Azure Files
extraVolumes:
  - name: azure-files
    azureFile:
      secretName: azure-secret
      shareName: fid-share
      readOnly: false

# GCP Persistent Disk
extraVolumes:
  - name: gcp-disk
    gcePersistentDisk:
      pdName: fid-disk
      fsType: ext4
```

### Best Practices

1. **Security First**
   ```yaml
   # Use appropriate permissions for sensitive files
   extraVolumes:
     - name: secrets
       secret:
         defaultMode: 256  # 0400 - owner read only
         secretName: sensitive-data
   ```

2. **Use ReadOnly Where Possible**
   ```yaml
   extraVolumeMounts:
     - name: config
       mountPath: /config
       readOnly: true  # Prevent accidental modifications
   ```

3. **Limit Volume Sizes**
   ```yaml
   extraVolumes:
     - name: temp
       emptyDir:
         sizeLimit: 1Gi  # Prevent disk exhaustion
   ```

4. **Use SubPaths for Specific Files**
   ```yaml
   extraVolumeMounts:
     - name: config-volume
       mountPath: /app/config.yaml
       subPath: config.yaml  # Mount only specific file
   ```

5. **Document Volume Purpose**
   ```yaml
   extraVolumes:
     # REQUIRED: TLS certificates for LDAPS
     - name: ldap-certs
       secret:
         secretName: ldap-tls-certs
   ```

6. **Group Related Volumes**
   ```yaml
   # TLS/SSL volumes
   - name: server-cert
   - name: client-cert
   - name: ca-bundle

   # Configuration volumes
   - name: app-config
   - name: logging-config
   ```

7. **Validate Volume Availability**
   ```yaml
   # Use optional for non-critical volumes
   extraVolumes:
     - name: optional-config
       configMap:
         name: extra-settings
         optional: true
   ```

8. **Consider Init Containers for Setup**
   ```yaml
   initContainers:
     - name: volume-permissions
       image: busybox
       command: ['sh', '-c', 'chmod -R 755 /data']
       volumeMounts:
         - name: data-volume
           mountPath: /data
   ```

### Troubleshooting

#### Check Volume Mounts
```bash
# List volumes in pod
kubectl describe pod <pod-name> | grep -A10 "Volumes:"

# Check volume mounts in container
kubectl describe pod <pod-name> | grep -A10 "Mounts:"

# Verify volume contents
kubectl exec <pod-name> -- ls -la /mount/path
```

#### Common Issues

**Issue: Volume mount fails**
```yaml
# Check if volume exists
kubectl get pv,pvc,configmap,secret

# Verify permissions
extraVolumes:
  - name: fix-permissions
    defaultMode: 493  # 0755
```

**Issue: Permission denied**
```yaml
# Adjust security context
securityContext:
  fsGroup: 1000
  runAsUser: 1000
```

**Issue: Volume not found**
```bash
# Ensure resource exists in same namespace
kubectl get configmap <name> -n <namespace>
kubectl get secret <name> -n <namespace>
```

**Issue: SubPath not working**
```yaml
# Ensure parent directory exists
extraVolumeMounts:
  - name: config
    mountPath: /app/config  # Directory must exist
    subPath: settings.yaml  # File from volume
```

---

## Lifecycle Hook Scripts

### Overview

The FID Helm chart provides a comprehensive lifecycle hook system that allows you to execute custom scripts at various stages of the pod lifecycle. These hooks enable customization of the deployment process, initialization tasks, configuration updates, and cleanup operations.

**Key Features:**
- Four distinct lifecycle stages (preInstall, preStart, postInstall, postStart)
- Leader-only execution option for cluster-wide operations
- Integration with Kubernetes native lifecycle hooks
- Detection of new installations vs upgrades
- Full shell scripting support with access to environment variables

**Important Concepts:**
- **Install Hooks**: Run only during initial deployment (detected by absence of `.CURRENT_BUILDID`)
- **Start Hooks**: Run every time a pod starts
- **Leader-Only**: Execute only on the first pod (`<release>-fid-0`)
- **Error Handling**: Script failures can prevent application startup

### Hook Types

| Hook | Timing | Frequency | Use Case |
|------|--------|-----------|----------|
| `preInstall` | Before FID installation | Once per new install | Schema initialization, prerequisite checks |
| `preStart` | Before FID starts | Every pod start | Environment preparation, config validation |
| `postInstall` | After FID installation | Once per new install | Initial data loading, integrations setup |
| `postStart` | After FID starts | Every pod start | Service registration, notifications |

### Pre-Install Hook

Executes before the FID installation process begins, only on new deployments.

**Configuration:**
```yaml
preInstall:
  enabled: true
  leaderOnly: true  # Run only on pod-0
  script: |
    #!/bin/bash
    echo "Preparing for FID installation..."

    # Check prerequisites
    if [ ! -f /opt/radiantone/vds/required-file ]; then
      echo "Creating required configuration..."
      touch /opt/radiantone/vds/required-file
    fi

    # Initialize custom schemas
    echo "Initializing custom schemas..."
    /opt/radiantone/vds/bin/vdsconfig.sh set-property \
      -name customSchema \
      -value "cn=custom,o=config"

    # Set environment-specific configurations
    if [ "$ENVIRONMENT" = "production" ]; then
      echo "Applying production settings..."
      # Production-specific initialization
    fi
```

**Implementation Details:**
- Checks for `.CURRENT_BUILDID` file to detect new installations
- Runs inside the main container before `run.sh`
- Has full access to mounted volumes and environment variables
- Script failures will prevent FID from starting

### Pre-Start Hook

Executes every time before FID starts, useful for runtime preparations.

**Configuration:**
```yaml
preStart:
  enabled: true
  leaderOnly: false  # Run on all pods
  script: |
    #!/bin/bash
    echo "Preparing FID startup..."

    # Clean temporary files
    rm -rf /opt/radiantone/vds/work/temp/*

    # Verify license
    if [ ! -f /opt/radiantone/vds/vds_server/license.lic ]; then
      echo "ERROR: License file not found!"
      exit 1
    fi

    # Start auxiliary services
    echo "Starting Derby database..."
    /opt/radiantone/vds/bin/runDerbyServer.sh &

    # Wait for dependencies
    echo "Waiting for ZooKeeper..."
    while ! nc -z {{ .Values.zk.connectionString | split ":" | first }} 2181; do
      sleep 2
    done

    echo "Pre-start preparations complete"
```

**Use Cases:**
- Starting embedded databases (Derby)
- Cleaning temporary directories
- Validating configuration files
- Checking external dependencies
- Setting up network connections

### Post-Install Hook

Executes after successful FID installation, only on new deployments.

**Configuration:**
```yaml
postInstall:
  enabled: true
  leaderOnly: true  # Usually cluster-wide operations
  script: |
    #!/bin/bash
    echo "Running post-installation tasks..."

    # Wait for FID to be fully ready
    until /opt/radiantone/vds/bin/vdsconfig.sh get-server-status; do
      echo "Waiting for FID to be ready..."
      sleep 5
    done

    # Configure API endpoints
    /opt/radiantone/vds/bin/vdsconfig.sh set-property \
      -name agentsApiServerEndpoint \
      -value "https://api.example.com/agents"

    # Create initial data sources
    echo "Creating LDAP data source..."
    /opt/radiantone/vds/bin/ldap.sh create-datasource \
      -name "corporate-ldap" \
      -host "ldap.company.com" \
      -port 389 \
      -binddn "cn=admin,dc=company,dc=com"

    # Load initial data
    if [ -f /migrations/initial-data.ldif ]; then
      echo "Loading initial data..."
      /opt/radiantone/vds/bin/ldif2vds.sh \
        -f /migrations/initial-data.ldif \
        -b "o=companydirectory"
    fi

    # Configure replication
    if [ "$HOSTNAME" = "{{ .Release.Name }}-fid-0" ]; then
      echo "Setting up replication..."
      /opt/radiantone/vds/bin/replication.sh configure \
        --mode multi-master \
        --peers "fid-1,fid-2"
    fi
```

**Common Tasks:**
- Loading initial data
- Configuring data sources
- Setting up replication
- Creating indexes
- Configuring integrations
- Registering with external services

### Post-Start Hook

Executes after FID successfully starts, runs on every pod startup.

**Configuration:**
```yaml
postStart:
  enabled: true
  leaderOnly: false  # Can run on all pods
  script: |
    #!/bin/bash
    echo "FID started successfully, running post-start tasks..."

    # Register with service discovery
    curl -X POST "http://consul:8500/v1/agent/service/register" \
      -H "Content-Type: application/json" \
      -d '{
        "ID": "'$HOSTNAME'",
        "Name": "fid-ldap",
        "Port": 2389,
        "Check": {
          "TCP": "'$HOSTNAME':2389",
          "Interval": "10s"
        }
      }'

    # Send startup notification
    if [ "$SLACK_WEBHOOK" ]; then
      curl -X POST "$SLACK_WEBHOOK" \
        -H "Content-Type: application/json" \
        -d '{"text":"FID instance '$HOSTNAME' started successfully"}'
    fi

    # Start monitoring
    /opt/radiantone/vds/bin/monitor.sh start \
      --metrics-port 9090 \
      --health-check-interval 30s

    # Warm up caches
    echo "Warming up caches..."
    /opt/radiantone/vds/bin/cache-warmer.sh \
      --cache "o=companydirectory" \
      --max-entries 10000
```

**Common Tasks:**
- Service registration (Consul, Eureka)
- Sending notifications
- Starting monitoring agents
- Cache warming
- Health check registration
- Metrics collection setup

### Kubernetes Lifecycle Hooks

In addition to FID-specific hooks, the chart configures Kubernetes lifecycle hooks:

#### PostStart Hook
```yaml
# Hardcoded in statefulset.yaml
lifecycle:
  postStart:
    exec:
      command: ["/bin/sh", "-c", "echo Hello from the myfid postStart handler > /opt/radiantone/vds/lifecycle.txt"]
```

#### PreStop Hook
```yaml
# Conditional based on fid.detach
lifecycle:
  preStop:
    exec:
      command:
        # If detaching from cluster
        - /opt/radiantone/vds/bin/advanced/cluster.sh
        - detach
        # Or normal shutdown
        - /opt/radiantone/vds/bin/stopVDSServer.sh
```

### Execution Flow

Understanding the complete lifecycle execution sequence:

```mermaid
graph TD
    A[Pod Scheduled] --> B[Init Containers]
    B --> C[Main Container Starts]
    C --> D{New Install?}
    D -->|Yes| E[preInstall Hook]
    D -->|No| F[preStart Hook]
    E --> F
    F --> G[run.sh - FID Installation/Start]
    G --> H{Success?}
    H -->|No| I[Container Exits]
    H -->|Yes| J{New Install?}
    J -->|Yes| K[postInstall Hook]
    J -->|No| L[postStart Hook]
    K --> L
    L --> M[Kubernetes postStart]
    M --> N[Application Running]
    N --> O[PreStop on Termination]
```

### Configuration Examples

#### Example 1: Database Migration on Upgrade
```yaml
preStart:
  enabled: true
  leaderOnly: true
  script: |
    # Check if this is an upgrade
    if [ -f /opt/radiantone/vds/.CURRENT_BUILDID ]; then
      OLD_VERSION=$(cat /opt/radiantone/vds/.CURRENT_BUILDID)
      NEW_VERSION="{{ .Chart.AppVersion }}"

      if [ "$OLD_VERSION" != "$NEW_VERSION" ]; then
        echo "Upgrading from $OLD_VERSION to $NEW_VERSION"

        # Run migration scripts
        /opt/radiantone/vds/bin/migrate.sh \
          --from "$OLD_VERSION" \
          --to "$NEW_VERSION"
      fi
    fi
```

#### Example 2: Environment-Specific Configuration
```yaml
postInstall:
  enabled: true
  leaderOnly: true
  script: |
    case "$ENVIRONMENT" in
      dev)
        echo "Configuring for development..."
        /opt/radiantone/vds/bin/vdsconfig.sh set-property \
          -name logLevel -value DEBUG
        ;;
      staging)
        echo "Configuring for staging..."
        /opt/radiantone/vds/bin/vdsconfig.sh set-property \
          -name logLevel -value INFO
        ;;
      production)
        echo "Configuring for production..."
        /opt/radiantone/vds/bin/vdsconfig.sh set-property \
          -name logLevel -value WARNING
        # Enable audit logging
        /opt/radiantone/vds/bin/audit.sh enable
        ;;
    esac
```

#### Example 3: Integration with External Systems
```yaml
postStart:
  enabled: true
  leaderOnly: false
  script: |
    # Register with API Gateway
    curl -X POST "https://api-gateway.company.com/v1/services" \
      -H "Authorization: Bearer $API_GATEWAY_TOKEN" \
      -H "Content-Type: application/json" \
      -d '{
        "name": "fid-'$HOSTNAME'",
        "url": "ldaps://'$HOSTNAME':2636",
        "healthCheck": "/health",
        "tags": ["ldap", "identity", "'$ENVIRONMENT'"]
      }'

    # Configure monitoring
    if [ "$DATADOG_ENABLED" = "true" ]; then
      /opt/radiantone/vds/bin/dd-agent.sh configure \
        --api-key "$DD_API_KEY" \
        --tags "env:$ENVIRONMENT,service:fid"
    fi
```

#### Example 4: Conditional Features Based on License
```yaml
postInstall:
  enabled: true
  leaderOnly: true
  script: |
    # Check license features
    LICENSE_INFO=$(/opt/radiantone/vds/bin/license.sh info)

    if echo "$LICENSE_INFO" | grep -q "FEATURE_SYNC"; then
      echo "Enabling synchronization features..."
      /opt/radiantone/vds/bin/sync.sh enable
    fi

    if echo "$LICENSE_INFO" | grep -q "FEATURE_ICS"; then
      echo "Enabling ICS features..."
      /opt/radiantone/vds/bin/ics.sh configure \
        --cache-size 10000 \
        --refresh-interval 300
    fi
```

### Best Practices

1. **Idempotent Scripts**
   ```bash
   # Check before creating
   if ! /opt/radiantone/vds/bin/vdsconfig.sh get-property -name myProperty; then
     /opt/radiantone/vds/bin/vdsconfig.sh set-property \
       -name myProperty -value "myValue"
   fi
   ```

2. **Error Handling**
   ```bash
   set -e  # Exit on error
   set -o pipefail  # Pipe failures cause exit

   # Trap errors
   trap 'echo "Error on line $LINENO"' ERR
   ```

3. **Logging**
   ```bash
   # Log to file
   LOG_FILE="/opt/radiantone/vds/logs/lifecycle-$(date +%Y%m%d).log"
   exec 1> >(tee -a "$LOG_FILE")
   exec 2>&1

   echo "[$(date)] Starting postInstall hook..."
   ```

4. **Wait for Services**
   ```bash
   # Wait with timeout
   TIMEOUT=300
   ELAPSED=0

   while ! /opt/radiantone/vds/bin/vdsconfig.sh ping; do
     if [ $ELAPSED -ge $TIMEOUT ]; then
       echo "ERROR: Timeout waiting for FID"
       exit 1
     fi
     sleep 5
     ELAPSED=$((ELAPSED + 5))
   done
   ```

5. **Leader Election**
   ```bash
   # Ensure only one pod performs cluster operations
   if [ "$HOSTNAME" = "{{ .Release.Name }}-fid-0" ]; then
     echo "Running as leader..."
     # Cluster-wide operations
   else
     echo "Running as follower, skipping cluster operations"
   fi
   ```

6. **Version Detection**
   ```bash
   # Detect new install vs upgrade
   if [ -f /opt/radiantone/vds/.CURRENT_BUILDID ]; then
     echo "Upgrade detected"
     OLD_VERSION=$(cat /opt/radiantone/vds/.CURRENT_BUILDID)
   else
     echo "New installation detected"
   fi
   ```

7. **Resource Cleanup**
   ```bash
   # Clean up on exit
   cleanup() {
     echo "Cleaning up temporary resources..."
     rm -f /tmp/lifecycle-*.tmp
   }
   trap cleanup EXIT
   ```

8. **Secrets Management**
   ```bash
   # Don't log sensitive data
   if [ "$DEBUG" != "true" ]; then
     set +x  # Disable command echoing
   fi

   # Use environment variables for secrets
   export LDAP_PASSWORD="${LDAP_PASSWORD:-$(cat /var/secrets/ldap-password)}"
   ```

### Troubleshooting

#### Check Hook Execution
```bash
# View pod logs
kubectl logs <pod-name> -c <container-name>

# Check for hook output
kubectl exec <pod-name> -- cat /opt/radiantone/vds/logs/vds_server.log | grep -A10 "Running.*script"

# Verify script execution
kubectl exec <pod-name> -- ls -la /opt/radiantone/vds/lifecycle.txt
```

#### Debug Hook Scripts
```yaml
# Enable debug mode
preStart:
  enabled: true
  script: |
    set -x  # Enable debug output
    echo "Debug: HOSTNAME=$HOSTNAME"
    echo "Debug: Environment variables:"
    env | sort

    # Your script here
    set +x  # Disable debug output
```

#### Common Issues

**Issue: Script not executing**
```yaml
# Check enabled flag
postInstall:
  enabled: true  # Must be true
  script: |
    echo "This will run"
```

**Issue: Leader-only not working**
```yaml
# Verify hostname matching
postInstall:
  leaderOnly: true
  script: |
    echo "Current hostname: $HOSTNAME"
    echo "Expected: {{ .Release.Name }}-fid-0"
```

**Issue: Script fails silently**
```bash
# Add error handling
set -e
trap 'echo "Failed at line $LINENO with exit code $?"' ERR

# Add explicit exit codes
if ! command; then
  echo "ERROR: Command failed"
  exit 1
fi
```

**Issue: Timing problems**
```bash
# Wait for services to be ready
for i in {1..60}; do
  if /opt/radiantone/vds/bin/vdsconfig.sh ping; then
    break
  fi
  echo "Attempt $i/60: Waiting for FID..."
  sleep 5
done
```

**Issue: Permission denied**
```bash
# Check file permissions
ls -la /opt/radiantone/vds/bin/

# Make scripts executable if needed
chmod +x /opt/radiantone/vds/bin/custom-script.sh
```

---

## Resource Management

This section describes the parameters for configuring resource requests and limits for the FID container. These settings are crucial for ensuring stable performance and resource allocation in a Kubernetes cluster.

### `resources.requests`

This specifies the minimum amount of resources that the container needs. Kubernetes will guarantee that the container has at least this much resource available.

*   **`memory`**: The amount of memory requested (e.g., `256Mi`, `1Gi`).
*   **`cpu`**: The amount of CPU requested (e.g., `250m`, `1`).

### `resources.limits`

This specifies the maximum amount of resources that the container can use. If the container tries to exceed these limits, it may be throttled (for CPU) or terminated (for memory).

*   **`memory`**: The maximum amount of memory the container can use.
*   **`cpu`**: The maximum amount of CPU the container can use.

**Example:**

```yaml
resources:
  requests:
    memory: "4Gi"
    cpu: "1"
  limits:
    memory: "8Gi"
    cpu: "2"
```

**Implementation Details:**

The `resources` values are used in the `containers` section of the `StatefulSet` in `templates/statefulset.yaml`. The `resources` block is directly populated from the values provided.

For a non-technical user, setting resource requests and limits is like telling the system how much computing power and memory the application needs to run smoothly, and what the maximum amount it is allowed to use is. This prevents the application from consuming too many resources and affecting other applications running on the same system.

---

## Probes

This section describes the parameters for configuring Kubernetes probes. Probes are used by the kubelet to check the health of a container.

### `readinessProbe`

The readiness probe is used to determine when a container is ready to start accepting traffic. If the readiness probe fails, the container's IP address is removed from the endpoints of all Services.

### `livenessProbe`

The liveness probe is used to determine when to restart a container. If the liveness probe fails, the kubelet kills the container, and the container is subjected to its restart policy.

### `startupProbe`

The startup probe is used to determine when a container application has started. If a startup probe is configured, it disables liveness and readiness checks until it succeeds, making sure that those probes don't interfere with the application startup. This is particularly useful for applications that are slow to start.

**Common Probe Parameters:**

*   **`initialDelaySeconds`**: Number of seconds after the container has started before liveness or readiness probes are initiated.
*   **`timeoutSeconds`**: Number of seconds after which the probe times out.
*   **`periodSeconds`**: How often (in seconds) to perform the probe.
*   **`failureThreshold`**: When a probe fails, Kubernetes will try `failureThreshold` times before giving up.
*   **`successThreshold`**: Minimum consecutive successes for the probe to be considered successful after having failed.

**Example:**

```yaml
readinessProbe:
  initialDelaySeconds: 60
  timeoutSeconds: 5
  periodSeconds: 30
  failureThreshold: 10
  successThreshold: 1
livenessProbe:
  initialDelaySeconds: 120
  timeoutSeconds: 5
  periodSeconds: 30
  failureThreshold: 10
  successThreshold: 1
startupProbe:
  initialDelaySeconds: 0
  timeoutSeconds: 5
  periodSeconds: 20
  failureThreshold: 15
  successThreshold: 1
```

**Implementation Details:**

The probe values are used in the `containers` section of the `StatefulSet` in `templates/statefulset.yaml`. The `readinessProbe`, `livenessProbe`, and `startupProbe` blocks are directly populated from the values provided.

For a non-technical user, probes are like health checks for the application.
*   The **readiness probe** tells the system when the application is ready to receive requests.
*   The **liveness probe** tells the system if the application is still running correctly, and if not, to restart it.
*   The **startup probe** tells the system when the application has finished starting up.

---

## Security Context

This section describes the parameters for configuring security settings for the FID pods and containers. A security context defines privilege and access control settings for a Pod or Container, enhancing security by limiting the container's access to the host system.

### `podSecurityContext`

This defines security settings that will be applied to all containers within the pod.

*   **`enabled`**: A boolean to enable or disable the pod-level security context.
*   **`fsGroup`**: A special supplemental group that is applied to all containers in a pod. Any files created in a volume will be owned by this group ID.

### `securityContext`

This defines security settings that are applied at the individual container level.

*   **`enabled`**: A boolean to enable or disable the container-level security context.
*   **`runAsUser`**: The user ID (UID) that the container process will run as.
*   **`runAsGroup`**: The group ID (GID) that the container process will run as.
*   **`runAsNonRoot`**: A boolean indicating that the container must run as a non-root user. If `true`, the Kubelet will validate the image at runtime to ensure that it does not run as UID 0 (root).
*   **`privileged`**: A boolean that determines if the container is run in privileged mode. This is equivalent to the `--privileged` flag in `docker run`.
*   **`readOnlyRootFilesystem`**: A boolean that mounts the container's root filesystem as read-only.
*   **`allowPrivilegeEscalation`**: A boolean that controls whether a process can gain more privileges than its parent process.
*   **`capabilities`**: A list of Linux capabilities to add or drop from a container.

**Example:**

```yaml
podSecurityContext:
  enabled: true
  fsGroup: 1001

securityContext:
  enabled: true
  runAsUser: 1001
  runAsGroup: 1001
  runAsNonRoot: true
  allowPrivilegeEscalation: false
  capabilities:
    drop:
      - ALL
```

**Implementation Details:**

The `podSecurityContext` and `securityContext` values are used in the `StatefulSet` definition in `templates/statefulset.yaml`. The `securityContext` field of the pod spec (`spec.template.spec.securityContext`) is populated from the `podSecurityContext` values, while the `securityContext` field of the container spec (`spec.template.spec.containers[0].securityContext`) is populated from the `securityContext` values.

These settings are also influenced by the `global.compatibility.openshift.adaptSecurityContext` parameter. When deploying to OpenShift, this setting may automatically adjust the security context to comply with the platform's stricter security requirements.

For a non-technical user, these settings are like setting up a secure sandbox for the application. They ensure the application runs with the minimum necessary permissions, cannot access or modify sensitive files on the host system, and is prevented from performing actions that could compromise the stability or security of the entire system.

---

## Migration

### Overview
This chart supports two migration modes:
- Legacy: simple HTTP(S) download of an export.zip (and optional script) using fid.migration.url/script, or embedding the zip as a ConfigMap via fid.migration.file.
- Advanced: pluggable sources (http, s3, gcs, azure, git, db) with optional flags and cloud identity integration.

Precedence:
- When fid.migration.advanced.enabled is true, only the advanced block is used; legacy fields (url/file/script) are ignored.
- When fid.migration.advanced.enabled is false or unset, legacy fields are used and the advanced block is ignored.

Artifacts are placed at:
- /migrations/export.zip (the migration archive)
- /opt/radiantone/scripts/configure_fid.sh (optional post-migration script)

The migration initContainer runs before the main container on every pod start. The product import logic is responsible for only importing on first install (idempotent behavior).

### Legacy mode
Minimal configuration using plain URL (no flags):

```yaml
fid:
  migration:
    url: https://example.com/path/export.zip
    # Optional:
    # script: https://example.com/path/configure_fid.sh
```

Embed the zip (no network fetch):

```yaml
fid:
  migration:
    file: <base64-of-export.zip>
```

### Advanced mode
Enable advanced and select a source type:

```yaml
fid:
  migration:
    advanced:
      enabled: true
      source:
        type: http | s3 | gcs | azure | git | db
        # provider-specific settings shown in examples below
      # Optional post-migration script over HTTP in advanced mode
      script:
        url: ""
        flags: ""
```

Notes:
- Advanced mode supports provider-specific images by default; you can override under fid.migration.advanced.image.
- For cloud identities (IRSA/Workload Identity/Managed Identity) annotate a ServiceAccount and set serviceAccount.create: true.

### Examples

HTTP with flags (-L):
```yaml
fid:
  migration:
    advanced:
      enabled: true
      source:
        type: http
        http:
          url: https://example.com/exports/export.zip
          flags: "-L"
```

S3 with IRSA (AWS):
```yaml
serviceAccount:
  create: true
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::<acct>:role/<RoleForIRSA>

fid:
  migration:
    advanced:
      enabled: true
      source:
        type: s3
        s3:
          bucket: my-bucket
          key: exports/export.zip
          region: us-east-1
          auth:
            irsa: true
```

GCS with Workload Identity (GKE):
```yaml
serviceAccount:
  create: true
  annotations:
    iam.gke.io/gcp-service-account: my-gsa@project.iam.gserviceaccount.com

fid:
  migration:
    advanced:
      enabled: true
      source:
        type: gcs
        gcs:
          bucket: my-bucket
          object: exports/export.zip
          auth:
            workloadIdentity: true
```

Azure Blob with Managed Identity:
```yaml
fid:
  migration:
    advanced:
      enabled: true
      source:
        type: azure
        azure:
          accountName: mystorageacct
          container: exports
          blob: export.zip
          auth:
            managedIdentity: true
```

Git (SSH) private repo:
```yaml
fid:
  migration:
    advanced:
      enabled: true
      source:
        type: git
        git:
          repo: git@github.com:org/private-repo.git
          ref: main
          path: export/export.zip
          auth:
            sshKeySecretRef:
              name: fid-git-ssh-key
              key: ssh-privatekey
            knownHostsConfigMapRef:
              name: fid-known-hosts
              key: known_hosts
```

Database (Postgres example, base64 output):
```yaml
fid:
  migration:
    advanced:
      enabled: true
      source:
        type: db
        db:
          driver: postgres
          host: postgres
          port: 5432
          database: appdb
          userSecretRef: { name: db-creds, key: username }
          passwordSecretRef: { name: db-creds, key: password }
          query: "SELECT encode(zip_bytes, 'base64') FROM exports WHERE name='export.zip' LIMIT 1;"
          outputEncoding: base64
```

Optional post-migration script (HTTP) in advanced mode:
```yaml
fid:
  migration:
    advanced:
      enabled: true
      source:
        type: http
        http:
          url: https://example.com/exports/export.zip
      script:
        url: https://example.com/configure_fid.sh
        flags: "-L"
```

### Precedence and compatibility
- Advanced takes precedence when fid.migration.advanced.enabled is true; legacy fields are ignored.
- Legacy behavior remains unchanged when advanced is disabled.
- All new fields are nil-safe in templates to avoid upgrade issues.

### Service account and cloud identity
- To use IRSA/Workload Identity/Managed Identity, set serviceAccount.create: true and add relevant annotations.
- The StatefulSet will use serviceAccountName: {{ include "fid.serviceAccountName" . }} so pods can assume the annotated identity.

## Migration and Lifecycle Management

### Overview

This section covers automated lifecycle management through CronJobs, providing scheduled backups, data exports, and migration capabilities. The migration CronJob complements the one-time migration process by enabling continuous data protection and scheduled exports.

**Key Capabilities:**
- Scheduled automatic backups of FID data
- Export to S3-compatible storage
- Configuration preservation during upgrades
- Automated data migration between versions
- Compliance with backup retention policies

**Integration Points:**
- Works alongside the migration initContainer
- Complements manual backup strategies
- Integrates with cloud storage services
- Supports GitOps workflows

### Migration CronJob

The migration CronJob (`cronjob.migration`) provides automated, scheduled exports of FID configuration and data. Unlike the one-time migration process that runs during pod initialization, this CronJob runs on a schedule to create regular backups.

**How it works:**
1. Runs on the defined schedule (cron expression)
2. Spins up an Alpine container with kubectl and AWS CLI installed
3. Executes `./migrate.sh export` command inside the FID StatefulSet pod (specifically `fid-0`)
4. Copies the export file from `/opt/radiantone/vds/work/` directory
5. Uploads to configured S3 bucket using AWS CLI
6. Container terminates with cleanup

**Important Implementation Details:**
- **Pod Name**: Currently hardcoded to `fid-0` (first pod of the StatefulSet)
- **Export Location**: Files are created in `/opt/radiantone/vds/work/`
- **Migration Script**: Uses `/migrate.sh` script inside the FID container
- **Service Account**: Requires `hooks.hooks_sa.enabled: true` for RBAC permissions
- **Container Image**: Uses `alpine:latest` with kubectl and aws-cli installed at runtime

**Generated Export Naming:**
```
export-<version>-<release>-<revision>-<timestamp>.zip
```

Example: `export-8.1.0-fid-production-3-20240115120000.zip`

### Configuration

```yaml
# Enable hooks service account (required for CronJob RBAC)
hooks:
  hooks_sa:
    enabled: true  # Must be enabled for CronJob to work

cronjob:
  migration:
    # Enable/disable the migration CronJob
    enabled: false

    # Cron schedule expression
    # Default: "0 0 * * *" (daily at midnight)
    # Format: minute hour day-of-month month day-of-week
    schedule: "0 0 * * *"

    # S3 bucket path for storing exports
    # Default: "s3://fid-exports"
    # Format: s3://<bucket-name>/<optional-prefix>
    s3: "s3://fid-exports/cronjob"
```

**Prerequisites:**
- FID StatefulSet must be running with at least one pod (`fid-0`)
- AWS credentials must be configured (see S3 Bucket Configuration section)
- Hooks service account must be enabled for RBAC permissions

### Examples

#### Basic Daily Backup
```yaml
hooks:
  hooks_sa:
    enabled: true

cronjob:
  migration:
    enabled: true
    schedule: "0 0 * * *"  # Daily at midnight
    s3: "s3://my-backups/fid/daily"
```

#### Hourly Backup During Business Hours
```yaml
hooks:
  hooks_sa:
    enabled: true

cronjob:
  migration:
    enabled: true
    schedule: "0 9-17 * * 1-5"  # Every hour 9 AM - 5 PM, Monday-Friday
    s3: "s3://my-backups/fid/hourly"
```

#### Weekly Backup for Compliance
```yaml
cronjob:
  migration:
    enabled: true
    schedule: "0 2 * * 0"  # Weekly on Sunday at 2 AM
    s3: "s3://compliance-backups/fid/weekly"
```

#### Pre-Upgrade Backup Strategy
Before major upgrades, enable frequent backups:
```yaml
cronjob:
  migration:
    enabled: true
    schedule: "*/30 * * * *"  # Every 30 minutes
    s3: "s3://upgrade-backups/fid/pre-upgrade"
```

### S3 Bucket Configuration

The CronJob requires proper S3 access. Configure AWS credentials through one of these methods:

#### Method 1: ServiceAccount with IRSA (Recommended for EKS)
```yaml
serviceAccount:
  create: true
  annotations:
    eks.amazonaws.com/role-arn: "arn:aws:iam::123456789:role/fid-backup-role"

cronjob:
  migration:
    enabled: true
    s3: "s3://my-secure-bucket/fid"
```

#### Method 2: Environment Variables
```yaml
global:
  env:
    AWS_ACCESS_KEY_ID: "your-key-id"
    AWS_SECRET_ACCESS_KEY: "your-secret-key"
    AWS_DEFAULT_REGION: "us-east-1"

cronjob:
  migration:
    enabled: true
    s3: "s3://my-bucket/fid"
```

#### Method 3: Node IAM Role
If your nodes have appropriate IAM roles attached:
```yaml
cronjob:
  migration:
    enabled: true
    s3: "s3://my-bucket/fid"
```

### Schedule Patterns

Common cron schedule patterns:

| Pattern | Description | Example |
|---------|-------------|---------|
| `0 * * * *` | Every hour | Hourly backups |
| `0 0 * * *` | Daily at midnight | Daily backups |
| `0 0 * * 0` | Weekly on Sunday | Weekly backups |
| `0 0 1 * *` | Monthly on the 1st | Monthly archives |
| `*/15 * * * *` | Every 15 minutes | Frequent sync |
| `0 0,12 * * *` | Twice daily (midnight and noon) | Business continuity |
| `0 2 * * 1-5` | Weekdays at 2 AM | Working days only |

### Security Considerations

1. **Pod Security Context**: The CronJob respects the configured security context:
   ```yaml
   podSecurityContext:
     enabled: true
     runAsUser: 1000
     runAsGroup: 1000
     fsGroup: 1000
   ```

2. **Service Account and RBAC**: Uses the hook service account with broad permissions:
   ```yaml
   serviceAccountName: {{ include "fid.fullname" . }}-hook-account
   ```
   **Note**: The service account has wide permissions (`resources: ["*"]`) in the namespace for managing pods and statefulsets. Consider restricting these permissions in production environments.

3. **Resource Limits**: Fixed resource constraints (not configurable via values):
   ```yaml
   resources:
     requests:
       cpu: 500m
       memory: 512Mi
   ```

4. **Container Security**:
   - Uses `alpine:latest` image which could introduce vulnerabilities
   - Downloads kubectl binary at runtime from Google storage
   - Consider using a custom image with pre-installed tools for production

5. **S3 Encryption**: Ensure bucket-level encryption is enabled:
   ```bash
   aws s3api put-bucket-encryption \
     --bucket fid-exports \
     --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'
   ```

### Monitoring and Troubleshooting

#### View CronJob Status
```bash
kubectl get cronjobs -n <namespace>
kubectl describe cronjob <release>-fid-migration-cronjob-job -n <namespace>
```

#### Check Recent Job Executions
```bash
kubectl get jobs -n <namespace> | grep migration
```

#### View Job Logs
```bash
# Get the most recent job
JOB_NAME=$(kubectl get jobs -n <namespace> --sort-by=.metadata.creationTimestamp | grep migration | tail -1 | awk '{print $1}')

# View logs
kubectl logs -n <namespace> job/$JOB_NAME
```

#### Common Issues and Solutions

**Issue: CronJob not creating Jobs**
- Check if CronJob is enabled: `cronjob.migration.enabled: true`
- Verify schedule syntax is valid
- Check CronJob suspend status: `kubectl get cronjob -o yaml`

**Issue: Export fails with permission denied**
- Ensure FID pod is running and accessible
- Verify service account has exec permissions
- Check pod security policies

**Issue: S3 upload fails**
- Verify AWS credentials are configured
- Check S3 bucket permissions and policies
- Ensure bucket exists and is accessible
- Review network policies and egress rules

**Issue: Export file not found**
- Confirm FID migration script exists at `./migrate.sh` in the FID container
- Check if FID is fully initialized
- Verify that `fid-0` pod exists and is running
- Note: The CronJob is hardcoded to use `fid-0` - if using `fullnameOverride`, the pod name might differ

### Known Limitations

Based on the current implementation (`migration-cronjob.yaml`):

1. **Hardcoded Pod Name**: The CronJob uses `fid-0` which will fail if:
   - You're using `fullnameOverride` that changes the StatefulSet name
   - The StatefulSet has a different name pattern
   - Running multiple FID instances in the same namespace

2. **Fixed Resource Limits**: Resource requests/limits are not configurable through values.yaml

3. **AWS CLI Only**: Only supports S3 uploads; no support for other cloud storage providers

4. **No Retry Logic**: If the export or upload fails, there's no automatic retry mechanism

5. **Runtime Dependencies**: Downloads kubectl at runtime which could fail due to:
   - Network restrictions
   - Google storage unavailability
   - Version compatibility issues

6. **TODO Items**: The template includes a TODO comment about bucket generation, indicating incomplete features

### Best Practices

1. **Backup Retention Policy**
   - Implement S3 lifecycle policies to manage storage costs
   - Example lifecycle rule:
   ```json
   {
     "Rules": [{
       "Id": "DeleteOldBackups",
       "Status": "Enabled",
       "Expiration": {
         "Days": 30
       },
       "NoncurrentVersionExpiration": {
         "NoncurrentDays": 7
       }
     }]
   }
   ```

2. **Monitoring and Alerting**
   - Set up CloudWatch alerts for failed uploads
   - Monitor CronJob execution metrics
   - Track backup sizes and growth trends

3. **Testing and Validation**
   - Regularly test restore procedures
   - Validate export integrity
   - Document recovery time objectives (RTO)

4. **Schedule Optimization**
   - Avoid peak traffic hours for backups
   - Consider time zones for global deployments
   - Balance frequency with storage costs

5. **Security Best Practices**
   - Use IRSA or Workload Identity instead of static credentials
   - Enable S3 versioning for additional protection
   - Implement bucket policies with least privilege
   - Use S3 Object Lock for compliance requirements

6. **Disaster Recovery Planning**
   - Maintain backups in multiple regions
   - Document restore procedures
   - Test failover scenarios regularly
   - Keep backup inventory documentation

## Fluent Bit Integration

### Overview
Fluent Bit is deployed as a DaemonSet for comprehensive log collection and forwarding from FID components. The implementation supports multi-aggregator routing, hot reload capabilities, and maintains full backward compatibility with legacy configurations.

### Features
- **Multi-Aggregator Support**: Route different log sources to different destinations
- **Hot Reload**: Configuration changes without pod restarts
- **Backward Compatibility**: Seamless upgrade from legacy single-output format
- **Kubernetes Metadata Enrichment**: Automatic pod/namespace/container metadata
- **Flexible Log Routing**: Fine-grained control over which logs go where

### Configuration Modes

#### 1. Legacy Mode (Backward Compatible)
Single output configuration for existing deployments:

```yaml
fluent-bit:
  enabled: true
  outputSearchHost: "elasticsearch-master.namespace.svc.cluster.local"
  outputSearchPort: 9200
  outputSearchType: "es"  # Options: es, opensearch, loki, splunk
  outputSearchIndex: "fluent-bit"
  outputSearchLogstashFormat: true
  outputSearchLogstashPrefix: "fid-logs"
  logs:
    - name: fid
      enable: true
      path: /var/log/containers/fid-*.log
      refresh_interval: 10
```

#### 2. Multi-Aggregator Mode (Recommended)
Route logs to multiple destinations with fine-grained control:

```yaml
fluent-bit:
  enabled: true

  # Enable hot reload for configuration changes without restarts
  hotReload:
    enabled: true
    resources:
      requests:
        cpu: 10m
        memory: 32Mi
      limits:
        cpu: 100m
        memory: 128Mi

  # Define log sources
  logs:
    - name: fid
      enable: true
      path: /var/log/containers/fid-*.log
      refresh_interval: 10
      aggregators: ["elasticsearch-prod", "splunk-security"]  # Send to specific aggregators

    - name: zookeeper
      enable: true
      path: /var/log/containers/zk-*.log
      refresh_interval: 10
      aggregators: ["elasticsearch-prod"]  # Send only to Elasticsearch

    - name: iddm-proxy
      enable: true
      path: /var/log/containers/iddm-proxy-*.log
      refresh_interval: 10
      # No aggregators field means send to ALL aggregators

  # Define aggregators
  aggregators:
    - name: "elasticsearch-prod"
      type: "elasticsearch"
      host: "elasticsearch-master.monitoring.svc.cluster.local"
      port: 9200
      index: "fid-logs"
      logstashFormat: true
      logstashPrefix: "fid"
      logstashDateFormat: "%Y.%m.%d"
      username: "elastic"  # Optional
      password: "changeme"  # Optional
      tls: false
      tlsVerify: false
      retryLimit: 5

    - name: "splunk-security"
      type: "splunk"
      host: "splunk-hec.monitoring.svc.cluster.local"
      port: 8088
      token: "your-hec-token"
      index: "main"
      source: "kubernetes"
      sourcetype: "fid:logs"
      tls: true
      tlsVerify: false
      retryLimit: 3

    - name: "loki-grafana"
      type: "loki"
      host: "loki.monitoring.svc.cluster.local"
      port: 3100
      tenantId: "default"
      labels: "job=fluent-bit,cluster=prod"
      autoKubernetesLabels: true
      tls: false
```

### Supported Aggregator Types

#### Elasticsearch
```yaml
aggregators:
  - name: "elasticsearch-main"
    type: "elasticsearch"
    host: "elasticsearch.example.com"
    port: 9200
    index: "logs"
    docType: "_doc"  # For ES 6.x compatibility
    logstashFormat: true
    logstashPrefix: "k8s"
    logstashDateFormat: "%Y.%m.%d"
    username: "elastic"
    password: "secret"
    tls: true
    tlsVerify: true
    retryLimit: 5
```

#### OpenSearch
```yaml
aggregators:
  - name: "opensearch-main"
    type: "opensearch"
    host: "opensearch.example.com"
    port: 9200
    index: "logs"
    logstashFormat: true
    suppressTypeName: true  # For OpenSearch 2.x
    aws:
      enabled: true
      region: "us-west-2"
      roleArn: "arn:aws:iam::123456789012:role/fluent-bit"
```

#### Splunk HEC
```yaml
aggregators:
  - name: "splunk-hec"
    type: "splunk"
    host: "splunk-hec.example.com"
    port: 8088
    token: "abcd1234-5678-90ab-cdef-1234567890ab"
    index: "main"
    source: "kubernetes"
    sourcetype: "container:logs"
    tls: true
    tlsVerify: false
```

#### Grafana Loki
```yaml
aggregators:
  - name: "loki"
    type: "loki"
    host: "loki-gateway.example.com"
    port: 3100
    tenantId: "tenant1"
    labels: "environment=prod,region=us-west"
    autoKubernetesLabels: true
    username: "123456"  # Grafana Cloud instance ID
    password: "glc_..."  # Grafana Cloud API token
    tls: true
```

#### AWS S3
```yaml
aggregators:
  - name: "s3-archive"
    type: "s3"
    bucket: "my-logs-bucket"
    region: "us-west-2"
    prefix: "fid-logs/"
    compression: "gzip"
    uploadChunkSize: "50M"
    uploadTimeout: "10m"
    storeAsJson: true
    roleArn: "arn:aws:iam::123456789012:role/fluent-bit-s3"
```

#### Azure Event Hubs
```yaml
aggregators:
  - name: "azure-events"
    type: "azure_event_hubs"
    # Connection string from Azure Portal → Event Hubs → Namespace → Shared access policies
    connection_string: "Endpoint=sb://<namespace>.servicebus.windows.net/;SharedAccessKeyName=<policy>;SharedAccessKey=<key>"
    hub_name: "fid-logs"
    # Record enrichment
    include_tag: true
    include_time: true
    tag_time_name: "time"
    # Batching for throughput
    batch: true
    max_batch_size: 20
    # Custom message properties for filtering/routing
    message_properties:
      environment: "production"
      cluster: "fid-cluster"
      application: "radiantone-fid"
```

#### OpenTelemetry
```yaml
aggregators:
  - name: "otel-collector"  # required: unique aggregator name
    type: "opentelemetry"   # required: aggregator type
    # required: use either endpoint OR host+port
    endpoint: "http://otel-collector.monitoring.svc.cluster.local:4317"  # required (if no host+port)
    protocol: "grpc"  # optional: "grpc" (default) or "http"
```

#### Apache Kafka
```yaml
aggregators:
  - name: "kafka"
    type: "kafka"
    brokers: "kafka-0:9092,kafka-1:9092,kafka-2:9092"
    topic: "fid-logs"
    messageKey: "kubernetes.pod_name"
    format: "json"
    sasl:
      enabled: true
      mechanism: "SCRAM-SHA-512"
      username: "fluent-bit"
      password: "secret"
```

#### Sumo Logic
```yaml
aggregators:
  - name: "sumologic"
    type: "sumologic"
    host: "collectors.sumologic.com"
    port: 443
    uri: "/receiver/v1/http/YOUR_COLLECTOR_TOKEN"
    category: "kubernetes/fid"
    sourceName: "fid-logs"
    hostname: "${HOSTNAME}"
    tls: true
```

#### Debug (stdout)
```yaml
aggregators:
  - name: "debug"
    type: "stdout"
    format: "json_lines"  # Options: json, json_lines, msgpack
```

### Hot Reload Configuration

Hot reload allows configuration updates without restarting Fluent Bit pods:

```yaml
fluent-bit:
  hotReload:
    enabled: true
    image:
      repository: jimmidyson/configmap-reload
      tag: v0.12.0
    resources:
      requests:
        cpu: 10m
        memory: 32Mi
      limits:
        cpu: 100m
        memory: 128Mi
```

When enabled, configuration changes are automatically detected and applied via SIGHUP signal to Fluent Bit process.

### Kubernetes Filter Configuration

Enrich logs with Kubernetes metadata:

```yaml
fluent-bit:
  kubernetesFilter:
    enabled: true
    kubeURL: "https://kubernetes.default.svc:443"
    mergeLog: true
    keepLog: true
    parser: true
    exclude: true
    caFile: "/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
    tokenFile: "/var/run/secrets/kubernetes.io/serviceaccount/token"
```

### Advanced Configuration Examples

#### Route by Log Content
Send error logs to a different aggregator:

```yaml
fluent-bit:
  logs:
    - name: fid-errors
      enable: true
      path: /var/log/containers/fid-*.log
      refresh_interval: 5
      filter: "level=ERROR"
      aggregators: ["splunk-security", "pagerduty"]

    - name: fid-all
      enable: true
      path: /var/log/containers/fid-*.log
      refresh_interval: 10
      aggregators: ["elasticsearch-prod"]
```

#### Multi-Environment Setup
```yaml
fluent-bit:
  aggregators:
    - name: "es-dev"
      type: "elasticsearch"
      host: "es-dev.example.com"
      port: 9200
      index: "dev-logs"

    - name: "es-prod"
      type: "elasticsearch"
      host: "es-prod.example.com"
      port: 9200
      index: "prod-logs"
      tls: true
      username: "${ES_USERNAME}"
      password: "${ES_PASSWORD}"

  logs:
    - name: fid
      enable: true
      path: /var/log/containers/fid-*.log
      aggregators: ["{{ .Values.global.environment }}-es"]
```

### Migration Guide

#### From Legacy to Multi-Aggregator

1. **Assess Current Configuration**
   ```bash
   kubectl get cm fluent-bit-config -n <namespace> -o yaml > current-config.yaml
   ```

2. **Prepare New Configuration**
   - Convert `outputSearchHost` to aggregator definition
   - Map `outputSearchType` to aggregator type
   - Define log sources with aggregator routing

3. **Deploy with Backward Compatibility**
   ```bash
   # First upgrade with legacy config (verify it works)
   helm upgrade <release> . -f legacy-values.yaml

   # Then upgrade to multi-aggregator
   helm upgrade <release> . -f multi-aggregator-values.yaml
   ```

4. **Verify Log Forwarding**
   ```bash
   # Check Fluent Bit is running
   kubectl get pods -l app.kubernetes.io/name=fluent-bit

   # Verify logs are being forwarded
   kubectl logs -l app.kubernetes.io/name=fluent-bit --tail=100
   ```

### Troubleshooting

#### Common Issues

**Logs not forwarding:**
```bash
# Check Fluent Bit status
kubectl logs -n <namespace> -l app.kubernetes.io/name=fluent-bit

# Verify ConfigMap
kubectl get cm fluent-bit-config -n <namespace> -o yaml

# Test with stdout output
kubectl edit cm fluent-bit-config -n <namespace>
# Add stdout output for debugging
```

**Hot reload not working:**
```bash
# Check config-reloader logs
kubectl logs -n <namespace> -l app.kubernetes.io/name=fluent-bit -c reloader

# Verify SIGHUP is sent
kubectl logs -n <namespace> -l app.kubernetes.io/name=fluent-bit | grep SIGHUP
```

**Kubernetes metadata missing:**
```bash
# Verify service account permissions
kubectl get clusterrole fluent-bit -o yaml

# Check filter configuration
kubectl get cm fluent-bit-config -n <namespace> -o yaml | grep -A10 kubernetes
```

#### Performance Tuning

```yaml
fluent-bit:
  resources:
    requests:
      cpu: 100m
      memory: 128Mi
    limits:
      cpu: 500m
      memory: 256Mi

  # Tune buffer sizes for high-volume logs
  config:
    service:
      flushInterval: 5
      daemon: false
      logLevel: info
      parsersFile: parsers.conf
      httpServer: true
      httpListen: 0.0.0.0
      httpPort: 2020
      storageMetrics: true

    input:
      memBufLimit: 5MB
      skipLongLines: true
      refreshInterval: 10
      rotateWait: 30
      db: /var/log/flb-storage/
      dbSync: normal
```

### Best Practices

1. **Use Multi-Aggregator Mode** for new deployments
2. **Enable Hot Reload** to minimize disruptions
3. **Configure Resource Limits** based on log volume
4. **Use Kubernetes Filters** for metadata enrichment
5. **Implement Log Routing** to optimize storage costs
6. **Monitor Fluent Bit Metrics** via Prometheus endpoint
7. **Test Configuration Changes** in staging first
8. **Use TLS** for external aggregators
9. **Implement Retry Logic** with appropriate limits
10. **Regular Log Rotation** to prevent disk issues

---

## Logging Configuration (Fluentd Sidecar)

### Overview

The `logging:` section configures Fluentd as a sidecar container within FID pods for direct log file collection. This is different from Fluent Bit which runs as a DaemonSet and collects from container stdout/stderr. The logging configuration also controls Elasticsearch Curator for index management and can automatically create Kibana index patterns.

**Note**: For most deployments, we recommend using Fluent Bit (see [Fluent Bit Integration](#fluent-bit-integration)) instead of Fluentd sidecars as it's more resource-efficient and provides better flexibility.

### Key Features

- **Sidecar Deployment**: Runs alongside FID containers in the same pod
- **Direct File Access**: Reads log files directly from FID directories
- **Multi-Aggregator Support**: Send logs to multiple destinations simultaneously
- **Custom Parsing**: Supports TSV/CSV parsing for access logs via parse blocks
- **Automatic Index Naming**: Smart index naming for different aggregator types
- **Supported Aggregators**: Elasticsearch, OpenSearch, Splunk HEC, Loki, Sumo Logic, S3, Azure Event Hubs, OpenTelemetry

### Basic Configuration

#### Enable Fluentd Sidecar

```yaml
logging:
  enabled: true
  fluentd:
    enabled: true
    posFileDirectory: "/opt/radiantone/vds/work/logging"
    configFile: /fluentd/etc/fluent.conf

    # Define log sources
    logs:
      vds_server:
        enabled: true
        path: "/opt/radiantone/vds/vds_server/logs/vds_server.log"
        index: vds_server.log
        retention_days: 30
        aggregators: ["default"]  # Reference aggregators by name

      vds_server_access:
        enabled: true
        path: "/opt/radiantone/vds/vds_server/logs/vds_server_access.csv"
        index: vds_server_access.log
        retention_days: 30
        aggregators: ["default"]
        # TSV parsing for access logs
        parse: |-
          <parse>
            @type tsv
            keys LOGID,LOGDATE,LOGTIME,LOGTYPE,SERVERID,SERVERPORT
            types LOGID:integer,SERVERPORT:integer
          </parse>

      vds_events:
        enabled: true
        path: "/opt/radiantone/vds/vds_server/logs/vds_events.log"
        index: vds_events.log
        retention_days: 7
        aggregators: ["default"]

    # Define aggregators (destinations)
    aggregators:
      # Elasticsearch aggregator
      # Note: Index name is automatically set to <logName>.log-<clusterName>
      - name: "default"
        type: "elasticsearch"
        host: "elasticsearch-master.common-services.svc.cluster.local"  # Required
        port: "9200"  # Required (as string)
        # scheme: "https"  # Optional
        # user: "elastic"  # Optional
        # password: "changeme"  # Optional
        # reconnect_on_error: true  # Optional
        # time_key: "@timestamp"  # Optional
        # include_timestamp: true  # Optional (default: true)
```

#### Enable with Multi-Aggregator

```yaml
logging:
  enabled: true
  fluentd:
    enabled: true

    # Log sources configuration with routing
    logs:
      vds_server:
        enabled: true
        path: "/opt/radiantone/vds/vds_server/logs/vds_server.log"
        index: vds_server.log
        retention_days: 30
        aggregators: ["elasticsearch", "s3-archive"]  # Route to multiple destinations
        retention_days: 30

      audit:
        enabled: true
        path: "/opt/radiantone/vds/vds_server/logs/audit.log"
        index: audit.log
        retention_days: 90  # Longer retention for audit
        # Splunk aggregator will use this log's name for indexing
        aggregators: ["splunk-security", "elasticsearch"]

      connector:
        enabled: true
        path: "/opt/radiantone/vds/logs/sync_agents/*/connector.log"
        index: connector.log
        aggregators: ["elasticsearch"]
        retention_days: 30

    # Define multiple aggregators
    aggregators:
      # Elasticsearch aggregator
      - name: "elasticsearch"
        type: "elasticsearch"
        host: "elastic.example.com"
        port: "9200"
        # Index automatically becomes: <logName>.log-<clusterName>
        scheme: "https"  # Optional
        user: "elastic"  # Optional
        password: "changeme"  # Optional
        reconnect_on_error: true  # Optional
        include_timestamp: true  # Optional
        buffer:  # Optional buffer configuration
          path: "/var/log/fluentd-buffers/es.buffer"
          flush_mode: "interval"
          flush_interval: "5s"
          chunk_limit_size: "2M"
          queue_limit_length: "8"

      # S3 aggregator for archival
      - name: "s3-archive"
        type: "s3"
        bucket: "fid-logs-archive"  # Required
        region: "us-west-2"  # Required
        aws_key_id: "AKIAIOSFODNN7EXAMPLE"  # Optional
        aws_sec_key: "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"  # Optional
        path: "logs/%Y/%m/%d/"  # Optional
        s3_object_key_format: "%{\path}%{\time_slice}_%{\index}.%{\file_extension}"  # Optional
        store_as: "gzip"  # Optional
        format: "json"  # Optional

      # Splunk HEC aggregator
      - name: "splunk-security"
        type: "splunk_hec"
        hec_host: "splunk.example.com"  # Required
        hec_port: "8088"  # Required (as string)
        hec_token: "your-hec-token-here"  # Required
        protocol: "https"  # Optional
        insecure_ssl: true  # Optional
        index: "security_audit"  # Optional (overrides default)
        source: "fid"  # Optional
        sourcetype: "_json"  # Optional
```

### Aggregator Types and Parameters

#### Elasticsearch Aggregator

Elasticsearch aggregator automatically sets index names to `<logName>.log-<clusterName>` format.

##### Required Parameters
- `type`: "elasticsearch"
- `name`: Unique aggregator name
- One of the following connection methods:
  - `host` + `port`: Direct connection
  - `hosts`: Comma-separated list of hosts with ports
  - `cloud_id`: Elastic Cloud deployment ID

##### Complete Parameter List
```yaml
aggregators:
  - name: "elasticsearch-prod"
    type: "elasticsearch"

    # Connection (choose one method)
    host: "elasticsearch.example.com"
    port: "9200"
    # OR
    hosts: "es1.example.com:9200,es2.example.com:9200"
    # OR
    cloud_id: "deployment-name:base64data"
    cloud_auth: "user:password"

    # Network
    scheme: "https"  # http or https (forced to https when SSL enabled)
    path: "/"  # API path prefix

    # Authentication
    user: "elastic"
    password: "changeme"

    # Index Configuration
    index_name: "custom-index"  # Overrides automatic naming
    logstash_format: true  # Use logstash index format
    logstash_prefix: "custom-prefix"  # Default: <logName>-<clusterName>
    logstash_dateformat: "%Y.%m.%d"
    logstash_prefix_separator: "-"

    # Document Configuration
    type_name: "_doc"
    id_key: "id_field"
    parent_key: "parent_field"
    routing_key: "routing_field"
    write_operation: "index"  # index, create, update, upsert
    pipeline: "ingest-pipeline"

    # Templates
    template_name: "template-name"
    template_file: "/path/to/template.json"
    template_overwrite: false

    # ILM (Index Lifecycle Management)
    enable_ilm: true
    ilm_policy: "policy-name"
    ilm_policy_id: "policy-id"

    # Connection Management
    reconnect_on_error: true
    reload_connections: false
    reload_on_failure: true
    resurrect_after: "60s"
    request_timeout: "5s"

    # Time Configuration
    time_key: "@timestamp"
    time_key_format: "%Y-%m-%dT%H:%M:%S.%N%z"
    include_timestamp: true  # Default: true
    utc_index: true

    # Field Management
    include_tag_key: false
    tag_key: "tag"
    remove_keys: "field1,field2"
    suppress_type_name: true
    prefer_oj_serializer: false

    # SSL/TLS Configuration (both formats supported)
    # Option 1: Flat parameters
    ssl_verify: true
    ca_file: "/path/to/ca.pem"
    client_cert: "/path/to/client-cert.pem"
    client_key: "/path/to/client-key.pem"
    client_key_pass: "password"
    ssl_version: "TLSv1_2"

    # Option 2: Nested SSL (EOC compatible)
    ssl:
      enabled: true
      verify: true
      ca_path: "/path/to/ca.pem"
      cert_path: "/path/to/client-cert.pem"
      key_path: "/path/to/client-key.pem"
      key_passphrase: "password"
      version: "TLSv1_2"

    # Buffer Configuration
    buffer:
      path: "/var/log/fluentd-buffers/es.buffer"
      flush_mode: "interval"
      flush_interval: "5s"
      retry_type: "exponential_backoff"
      retry_max_interval: "30"
      chunk_limit_size: "2M"
      queue_limit_length: "8"
```

#### OpenSearch Aggregator

OpenSearch uses the same parameters as Elasticsearch with identical behavior for index naming.

##### Required Parameters
- `type`: "opensearch"
- `name`: Unique aggregator name
- One of: `host` + `port`, `hosts`

##### Complete Parameter List
```yaml
aggregators:
  - name: "opensearch-aws"
    type: "opensearch"

    # All Elasticsearch parameters are supported (see above)
    # Key differences:
    # - No cloud_id support
    # - AWS signature authentication can be configured separately

    host: "my-domain.us-west-2.es.amazonaws.com"
    port: "443"
    scheme: "https"

    # All other parameters identical to Elasticsearch
```

#### Splunk HEC Aggregator

Splunk HEC aggregator sends logs to Splunk HTTP Event Collector.

##### Required Parameters
- `type`: "splunk_hec"
- `name`: Unique aggregator name
- `hec_host`: Splunk HEC endpoint host
- `hec_port`: Splunk HEC port (typically 8088)
- `hec_token`: HEC authentication token

##### Complete Parameter List
```yaml
aggregators:
  - name: "splunk-prod"
    type: "splunk_hec"

    # Connection (required)
    hec_host: "splunk.example.com"
    hec_port: "8088"
    hec_token: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

    # Protocol
    protocol: "https"  # http or https

    # Index Configuration
    index: "main"  # Target index (optional)
    host: "fid-server"  # Event host field
    source: "fid"  # Event source field
    sourcetype: "_json"  # Event sourcetype

    # Alternative dynamic fields (mutually exclusive with static)
    index_key: "index_field"  # Get index from record
    host_key: "host_field"  # Get host from record
    source_key: "source_field"  # Get source from record
    sourcetype_key: "type_field"  # Get sourcetype from record

    # Data Format
    data_type: "event"  # event or metric
    use_raw: false  # Send as raw events
    raw_line_key: "message"  # Field for raw event
    keep_keys: "field1,field2"  # Fields to keep

    # Metrics (when data_type is metric)
    metrics_from_event: false
    metric_name_key: "metric_name"
    metric_value_key: "metric_value"

    # Fields (indexed fields)
    fields:  # Sent as indexed fields in Splunk
      environment: "production"
      datacenter: "us-east-1"
      application: "fid"

    # ACK Configuration
    use_ack: false  # Enable indexer acknowledgment
    channel: "channel-id"  # Required when use_ack is true
    ack_retry: 3
    ack_retry_limit: 5

    # Timing
    use_fluentd_time: false
    time_as_integer: false

    # Timeouts
    idle_timeout: 5
    read_timeout: 10
    open_timeout: 10

    # Content
    coerce_to_utf8: true
    non_utf8_replacement_string: "?"

    # SSL/TLS Configuration
    insecure_ssl: false  # Disable certificate verification
    ca_file: "/path/to/ca.pem"
    ca_path: "/path/to/ca-dir"
    client_cert: "/path/to/client-cert.pem"
    client_key: "/path/to/client-key.pem"
    ssl_ciphers: "TLS_AES_256_GCM_SHA384"

    # Alternative nested format
    ssl:
      verify: true  # Maps to NOT insecure_ssl

    # Buffer Configuration
    buffer:
      path: "/var/log/fluentd-buffers/splunk.buffer"
      flush_interval: "5s"
      chunk_limit_size: "10M"
```

#### Loki Aggregator (Grafana Loki)

Loki aggregator sends logs to Grafana Loki using the official fluent-plugin-grafana-loki.

##### Required Parameters
- `type`: "loki"
- `name`: Unique aggregator name
- `url`: Loki API endpoint URL

##### Complete Parameter List
```yaml
aggregators:
  - name: "loki-grafana"
    type: "loki"

    # Connection (required)
    url: "https://logs-prod-us-central1.grafana.net"

    # Authentication
    username: "123456"  # Basic auth username
    password: "glc_secret"  # Basic auth password
    bearer_token_file: "/var/run/secrets/token"  # Bearer token
    tenant: "my-org-id"  # X-Scope-OrgID header

    # Labels
    extra_labels:  # Additional labels for all log streams
      environment: "production"
      datacenter: "us-west"
      application: "fid"
    # Note: extraLabels also supported for backward compatibility

    # Format Configuration
    line_format: "json"  # json or key_value
    drop_single_key: true  # Simplify single-key records
    remove_keys: ["temp_field", "debug"]  # Array of keys to remove
    extract_kubernetes_labels: false  # Extract k8s labels
    include_thread_label: true  # Add fluentd_thread label

    # Compression
    compress: "gzip"  # Enable gzip compression

    # Custom Headers
    custom_headers:  # Additional HTTP headers
      X-Custom-Header: "value"
      X-Scope-OrgID: "override-tenant"

    # SSL/TLS Configuration
    cert: "/path/to/client.crt"  # Client certificate
    key: "/path/to/client.key"  # Client key
    ca_cert: "/path/to/ca.pem"  # CA certificate
    insecure_tls: false  # Disable verification
    ciphers: "TLS_AES_256_GCM_SHA384:TLS_AES_128_GCM_SHA256"
    min_version: "TLSv1.2"  # Minimum TLS version

    # Alternative nested format
    ssl:
      verify: true  # Maps to NOT insecure_tls
      ca_path: "/path/to/ca.pem"  # Maps to ca_cert

    # Buffer Configuration
    buffer:
      path: "/var/log/fluentd-buffers/loki.buffer"
      flush_interval: "2s"
      chunk_limit_size: "2M"
```

#### Sumo Logic Aggregator

Sumo Logic aggregator sends logs to Sumo Logic HTTP collector.

##### Required Parameters
- `type`: "sumologic"
- `name`: Unique aggregator name
- `endpoint`: Sumo Logic collector endpoint URL

##### Complete Parameter List
```yaml
aggregators:
  - name: "sumologic-prod"
    type: "sumologic"

    # Connection (required)
    endpoint: "https://collectors.sumologic.com/receiver/v1/http/xxx"

    # Source Configuration
    source_name: "fid-logs"  # _sourceName metadata
    source_host: "fid-server"  # _sourceHost metadata
    source_category: "k8s/fid"  # _sourceCategory metadata

    # Alternative dynamic sources (mutually exclusive)
    source_name_key: "source_field"
    source_host_key: "host_field"
    source_category_key: "category_field"

    # Category options
    source_category_prefix: "prefix/"
    source_category_replace_dash: "_"

    # Data Type
    data_type: "logs"  # logs or metrics
    metric_data_format: "prometheus"  # graphite, carbon2, or prometheus

    # Log Format
    log_format: "json"  # text, json, or json_merge
    log_key: "message"  # Field for text format
    json_merge: true  # Merge log_key into top level

    # Timestamp
    add_timestamp: true
    timestamp_key: "timestamp"

    # Compression
    compress: true
    compress_encoding: "gzip"  # gzip or deflate

    # Network
    open_timeout: 60
    send_timeout: 120
    receive_timeout: 60
    disable_cookies: false

    # Additional Fields
    delimiter: "."  # Nested field delimiter
    custom_fields: "env=prod,team=platform"  # key=value pairs
    custom_dimensions: "cluster=prod-west"  # For metrics
    sumo_client: "fluentd-k8s"  # Client identifier

    # Retry Configuration
    use_internal_retry: false
    retry_timeout: 86400
    retry_max_times: 0  # 0 = infinite
    retry_min_interval: 1
    retry_max_interval: 300

    # Request Control
    max_request_size: 4194304  # 4MB default

    # Proxy
    proxy_uri: "http://proxy.example.com:8080"
    proxy_cert: "/path/to/proxy-cert.pem"
    proxy_key: "/path/to/proxy-key.pem"

    # SSL/TLS Configuration
    verify_ssl: true
    ca_path: "/path/to/ca-dir"

    # Alternative nested format
    ssl:
      verify: true  # Maps to verify_ssl
      ca_path: "/path/to/ca-dir"

    # Buffer Configuration
    buffer:
      path: "/var/log/fluentd-buffers/sumologic.buffer"
      flush_interval: "5s"
      chunk_limit_size: "10M"
```

#### S3 Aggregator

S3 aggregator archives logs to Amazon S3 buckets.

##### Required Parameters
- `type`: "s3"
- `name`: Unique aggregator name
- `s3_bucket` or `bucket`: S3 bucket name
- `s3_region` or `region`: AWS region

##### Complete Parameter List
```yaml
aggregators:
  - name: "s3-archive"
    type: "s3"

    # Bucket Configuration (required)
    s3_bucket: "my-logs-bucket"  # or 'bucket'
    s3_region: "us-west-2"  # or 'region'
    s3_endpoint: "https://s3.amazonaws.com"  # Custom endpoint

    # Authentication (choose one method)
    # Option 1: Access keys
    aws_key_id: "AKIAIOSFODNN7EXAMPLE"
    aws_sec_key: "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"

    # Option 2: IAM role
    assume_role_credentials: true
    role_arn: "arn:aws:iam::123456789:role/log-writer"
    role_session_name: "fid-logs"
    external_id: "unique-external-id"

    # Object Configuration
    path: "logs/%Y/%m/%d/"  # S3 key prefix with time placeholders
    s3_object_key_format: "%{path}%{time_slice}_%{index}.%{file_extension}"
    store_as: "gzip"  # gzip, lzo, json, or text
    storage_class: "STANDARD"  # STANDARD, STANDARD_IA, GLACIER, etc.

    # Format
    format: "json"  # json or single_value
    format_json_flatten: true

    # Compression
    compression: "gzip"  # For store_as compatibility

    # SSL/Network
    use_ssl: true
    ssl_verify_peer: true
    force_path_style: false

    # Encryption
    use_server_side_encryption: true
    ssekms_key_id: "arn:aws:kms:us-west-2:123456789:key/xxx"
    sse_customer_algorithm: "AES256"
    sse_customer_key: "base64-encoded-key"
    sse_customer_key_md5: "base64-encoded-md5"

    # ACL/Permissions
    acl: "private"  # private, public-read, etc.
    grant_full_control: "id=xxx"
    grant_read: "id=xxx"
    grant_read_acp: "id=xxx"
    grant_write_acp: "id=xxx"

    # Bucket Management
    auto_create_bucket: true
    overwrite: false
    check_bucket: true
    check_object: false

    # Time Configuration
    time_slice_format: "%Y%m%d"
    utc: true
    hex_random_length: 4
    index_format: "%Y%m%d"

    # Warnings
    warn_for_delay: "3600"  # Warn if delayed by 1 hour

    # Buffer Configuration
    buffer:
      path: "/var/log/fluentd-buffers/s3.buffer"
      flush_interval: "10s"
      chunk_limit_size: "256M"
      queue_limit_length: "32"
```

#### Azure Event Hubs Aggregator

Azure Event Hubs aggregator sends logs to Azure Event Hubs using `fluent-plugin-azureeventhubs-radiant`.

##### Required Parameters
- `type`: "azure_event_hubs"
- `name`: Unique aggregator name
- `connection_string`: Azure Event Hub connection string
- `hub_name`: Event Hub name

##### Minimal Example

```yaml
aggregators:
  - name: "azure-events"
    type: "azure_event_hubs"
    connection_string: "Endpoint=sb://<namespace>.servicebus.windows.net/;SharedAccessKeyName=<policy>;SharedAccessKey=<key>"
    hub_name: "fid-logs"
```

#### OpenTelemetry Aggregator

OpenTelemetry aggregator sends logs to an OpenTelemetry Collector via OTLP using `fluent-plugin-opentelemetry`.

##### Required Parameters
- `type`: "opentelemetry"
- `name`: Unique aggregator name
- One of: `endpoint`, or `host` + `port`

##### Minimal Example

```yaml
aggregators:
  - name: "otel-collector"  # required: unique aggregator name
    type: "opentelemetry"   # required: aggregator type
    # required: use either endpoint OR host+port
    endpoint: "http://otel-collector.monitoring.svc.cluster.local:4317"  # required (if no host+port)
    protocol: "grpc"  # optional: "grpc" (default) or "http"
```

### Elasticsearch Curator Configuration

Curator helps manage Elasticsearch indices by performing automated maintenance tasks:

```yaml
logging:
  enabled: true
  curator:
    enabled: true
    schedule: "0 1 * * *"  # Run daily at 1 AM

    # Elasticsearch connection
    client:
      hosts:
        - elasticsearch-master.monitoring.svc.cluster.local
      port: 9200
      use_ssl: false
      ssl_no_validate: true
      username: elastic
      password: changeme
      timeout: 300
      master_only: false

    # Actions to perform
    actions:
      # Delete indices older than 30 days
      - action: delete_indices
        description: "Delete indices older than 30 days"
        filters:
          - filtertype: pattern
            kind: prefix
            value: fid-
          - filtertype: age
            source: name
            direction: older
            timestring: '%Y.%m.%d'
            unit: days
            unit_count: 30

      # Close indices older than 7 days (save memory)
      - action: close
        description: "Close indices older than 7 days"
        filters:
          - filtertype: pattern
            kind: prefix
            value: fid-
          - filtertype: age
            source: name
            direction: older
            timestring: '%Y.%m.%d'
            unit: days
            unit_count: 7

      # Snapshot indices older than 1 day
      - action: snapshot
        description: "Snapshot yesterday's index"
        repository: fid-backups
        name: "fid-%Y%m%d"
        filters:
          - filtertype: pattern
            kind: prefix
            value: fid-
          - filtertype: age
            source: name
            direction: older
            timestring: '%Y.%m.%d'
            unit: days
            unit_count: 1
```

### Kibana Index Pattern Creation

Automatically create index patterns in Kibana for visualization:

```yaml
logging:
  enabled: true
  indexCreation:
    enabled: true
    kibana:
      scheme: "http"
      host: "kibana.monitoring.svc.cluster.local"
      port: "5601"
      username: "elastic"  # Optional
      password: "changeme"  # Optional

    # Index patterns to create
    patterns:
      - id: "fid-logs-*"
        timeFieldName: "@timestamp"
        title: "FID Logs"
        default: true

      - id: "fid-audit-*"
        timeFieldName: "timestamp"
        title: "FID Audit Logs"
        default: false

    # RBAC for the Job
    rbac:
      enabled: true
      serviceAccount:
        create: true
        name: kibana-index-creator
```

### Metrics Exporter Integration

When logging with Fluentd is enabled, the FID metrics exporter sidecar is automatically deployed:

```yaml
logging:
  enabled: true
  fluentd:
    enabled: true

# This automatically adds the exporter sidecar
exporter:
  image: "radiantone/fid-exporter"
  imageTag: "1.0.4"
  securityContext:
    enabled: true
    runAsUser: 0

  # Prometheus metrics configuration
  port: 9090
  path: /metrics

  # Probe configurations
  livenessProbe:
    initialDelaySeconds: 60
    timeoutSeconds: 5
    path: /healthz

  readinessProbe:
    initialDelaySeconds: 120
    timeoutSeconds: 5
    path: /ready

# Metrics configuration (works with exporter)
metrics:
  enabled: true

  # Prometheus scraping
  prometheus:
    enabled: true
    port: 9090
    path: /metrics
    interval: 30s
    scrapeTimeout: 10s

  # Push to Prometheus Pushgateway
  pushMode: true
  pushGateway: "prometheus-pushgateway.monitoring:9091"
  pushMetricCron: "*/5 * * * *"  # Every 5 minutes
  pushMetricJobName: "fid-metrics"
```

### Advanced Use Cases

#### Use Case 1: Separate Application and Audit Logs

```yaml
logging:
  enabled: true
  fluentd:
    enabled: true

    logs:
      # Application logs to Elasticsearch
      vds_server:
        enabled: true
        path: "/opt/radiantone/vds/vds_server/logs/vds_server.log"
        index: vds_server.log
        retention_days: 30
        aggregators: ["elasticsearch"]  # Only to Elasticsearch

      # Audit logs to Splunk for security team
      audit:
        enabled: true
        path: "/opt/radiantone/vds/vds_server/logs/audit.log"
        index: audit.log
        retention_days: 365  # Keep audit logs for a year
        aggregators: ["splunk"]  # Only to Splunk
        splunk_index: "security_audit"
        splunk_sourcetype: "_json"

      # Access logs to both for correlation
      web_access:
        enabled: true
        path: "/opt/radiantone/vds/vds_server/logs/jetty/web_access.log"
        index: web_access.log
        retention_days: 30
        aggregators: ["elasticsearch", "splunk"]  # To both

    aggregators:
      - name: "elasticsearch"
        type: "elasticsearch"
        host: "es.logging.svc.cluster.local"
        port: "9200"
        logstash_format: true
        logstash_prefix: "fid-app"
        include_timestamp: true
        reconnect_on_error: true
        reload_on_failure: true
        request_timeout: 30000

      - name: "splunk"
        type: "splunk_hec"
        host: "splunk.security.svc.cluster.local"
        port: "8088"
        token: "${SPLUNK_TOKEN}"
        insecure_ssl: true
```

#### Use Case 2: Parse CSV Access Logs

```yaml
logging:
  enabled: true
  fluentd:
    enabled: true

    logs:
      vds_server_access:
        enabled: true
        path: "/opt/radiantone/vds/vds_server/logs/vds_server_access.csv"
        index: vds_server_access.log
        retention_days: 30
        aggregators: ["elasticsearch"]
        # Parse TSV/CSV format with specific fields
        parse: |-
          <parse>
            @type tsv
            keys LOGID,LOGDATE,LOGTIME,LOGTYPE,SERVERID,SERVERPORT,SESSIONID,MSGID,CLIENTIP,BINDDN,BINDUSER,CONNNB,OPNB,OPCODE,OPNAME,BASEDN,ATTRIBUTES,SCOPE,FILTER,SIZELIMIT,TIMELIMIT,LDAPCONTROLS,CHANGES,RESULTCODE,ERRORMESSAGE,MATCHEDDN,NBENTRIES,ETIME
            types LOGID:integer,SERVERPORT:integer,SESSIONID:integer,MSGID:integer,CONNNB:integer,OPNB:integer,OPCODE:integer,SIZELIMIT:integer,TIMELIMIT:integer,RESULTCODE:integer,NBENTRIES:integer,ETIME:integer
          </parse>

    aggregators:
      - name: "elasticsearch"
        type: "elasticsearch"
        host: "elasticsearch.example.com"
        port: "9200"
```

#### Use Case 3: Multiple Log Types with Different Parsing

```yaml
logging:
  enabled: true
  fluentd:
    enabled: true

    logs:
      # Standard application logs - multiline by default
      vds_server:
        enabled: true
        path: "/opt/radiantone/vds/vds_server/logs/vds_server.log"
        index: vds_server.log
        retention_days: 30
        aggregators: ["elasticsearch", "s3-archive"]
        # No parse block = uses default multiline parsing

      # Access logs with CSV parsing
      vds_server_access:
        enabled: true
        path: "/opt/radiantone/vds/vds_server/logs/vds_server_access.csv"
        index: vds_server_access.log
        retention_days: 7
        aggregators: ["elasticsearch"]
        parse: |-
          <parse>
            @type tsv
            keys LOGID,LOGDATE,LOGTIME,LOGTYPE,SERVERID,SERVERPORT
            types LOGID:integer,SERVERPORT:integer
          </parse>

      # Event logs - standard format
      vds_events:
        enabled: true
        path: "/opt/radiantone/vds/vds_server/logs/vds_events.log"
        index: vds_events.log
        retention_days: 30
        aggregators: ["elasticsearch"]
```

#### Use Case 4: Archive to S3 with Long-Term Storage

```yaml
logging:
  enabled: true
  fluentd:
    enabled: true

    logs:
      # All server logs go to both Elasticsearch and S3
      vds_server:
        enabled: true
        path: "/opt/radiantone/vds/vds_server/logs/vds_server.log"
        index: vds_server.log
        retention_days: 30
        aggregators: ["elasticsearch", "s3-archive"]

      # Audit logs have longer retention and go to S3
      audit:
        enabled: true
        path: "/opt/radiantone/vds/vds_server/logs/audit.log"
        index: audit.log
        retention_days: 365
        aggregators: ["s3-archive", "splunk"]

    aggregators:
      - name: "elasticsearch"
        type: "elasticsearch"
        host: "elasticsearch.example.com"
        port: "9200"

      - name: "s3-archive"
        type: "s3"
        bucket: "fid-logs-archive"
        region: "us-west-2"
        aws_key_id: "AKIAIOSFODNN7EXAMPLE"
        aws_sec_key: "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
        path: "logs/%Y/%m/%d/"
        s3_object_key_format: "%{\path}%{\time_slice}_%{\index}.%{\file_extension}"
        store_as: "gzip"
        format: "json"

      - name: "splunk"
        type: "splunk_hec"
        hec_host: "splunk.example.com"
        hec_port: "8088"
        hec_token: "your-token-here"
```

### Notes on Configuration

**Important Implementation Details:**

1. **Index Naming**:
   - For Elasticsearch/OpenSearch: Index names are automatically set to `<logName>.log-<clusterName>`
   - For Splunk: If no index is specified in the aggregator, it uses the log name without the `.log` suffix
   - For Loki: Automatically adds `service_name` label set to `<logName>.log`

2. **Supported Parse Types**:
   - Default (no parse block): Multiline parsing with pattern `/\d{4}-\d{1,2}-\d{1,2}/`
   - TSV/CSV parsing: Use `<parse>` block with `@type tsv` or `@type csv`

3. **Buffer Configuration**:
   - Buffers can be configured per aggregator
   - Default buffer type is file-based for reliability

4. **Aggregator Validation**:
   - All aggregator configurations are validated against allowed keys
   - Required fields must be present or the deployment will fail

### Troubleshooting Fluentd

#### Check Fluentd Status

```bash
# Check if Fluentd sidecar is running
kubectl get pods -n <namespace> -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{range .spec.containers[*]}{.name}{" "}{end}{"\n"}{end}' | grep fluentd

# View Fluentd logs
kubectl logs -n <namespace> <pod-name> -c fluentd

# Check Fluentd configuration
kubectl exec -n <namespace> <pod-name> -c fluentd -- cat /fluentd/etc/fluent.conf
```

#### Common Issues and Solutions

**Issue: Logs not being forwarded**
- Check that aggregator names in logs match defined aggregators
- Verify required fields are present for each aggregator type
- Check Fluentd container logs for connection errors

**Issue: Index names not as expected**
- Remember that Elasticsearch/OpenSearch automatically use `<logName>.log-<clusterName>` format
- For Splunk, check if index is set in aggregator or defaults to log name without `.log`

**Issue: Parse errors with CSV logs**
- Ensure the parse block matches the actual CSV/TSV format
- Verify field names and types match the log structure

### Comparison: Fluentd vs Fluent Bit

| Feature | Fluentd (Sidecar) | Fluent Bit (DaemonSet) |
|---------|-------------------|------------------------|
| **Deployment Model** | Sidecar in each pod | One DaemonSet per node |
| **Resource Usage** | Higher (Ruby-based) | Lower (C-based) |
| **Log Collection** | Direct file access | Container stdout/stderr |
| **Configuration** | Complex, powerful | Simple, efficient |
| **Plugin Ecosystem** | Extensive | Growing |
| **Use When** | Need complex processing | Standard log forwarding |
| **Recommended For** | Legacy systems, complex parsing | New deployments |

### Migration from Fluentd to Fluent Bit

If you're currently using Fluentd and want to migrate to Fluent Bit:

```yaml
# Step 1: Deploy Fluent Bit alongside Fluentd
fluent-bit:
  enabled: true
  # ... configuration

logging:
  fluentd:
    enabled: true  # Keep running initially

# Step 2: Verify Fluent Bit is collecting logs
# Step 3: Disable Fluentd
logging:
  fluentd:
    enabled: false
```

### Best Practices for Fluentd Configuration

1. **Define Multiple Aggregators** for redundancy and different use cases
2. **Use Appropriate Parse Blocks** for CSV/TSV access logs
3. **Set Proper Retention Days** based on compliance requirements
4. **Configure S3 Archival** for long-term storage needs
5. **Use Splunk HEC** for security and audit logs
6. **Test Aggregator Connectivity** before deploying
7. **Monitor Fluentd Logs** for connection and parsing errors
8. **Validate Required Fields** for each aggregator type
9. **Use Correct Port Format** (strings) for aggregator configurations
10. **Test Configuration** in staging first

### When to Use Fluentd Sidecar

Choose Fluentd sidecar when you need:

- **Direct file access**: Reading logs not available in stdout/stderr
- **Complex parsing**: Advanced multiline patterns, custom Ruby plugins
- **In-pod processing**: Heavy transformation before forwarding
- **Legacy compatibility**: Existing Fluentd configurations
- **Multiple destinations**: Complex routing rules per pod

For most use cases, we recommend Fluent Bit as it's more resource-efficient and easier to manage

---

## Metrics Configuration

### Overview

The FID Helm chart provides two distinct approaches for metrics collection and monitoring:

1. **`metrics:` section** - Configures the FID Exporter sidecar for application-level metrics
2. **`metricsService:` section** - Deploys a standalone metrics service for service availability monitoring

These two systems can work independently or together to provide comprehensive monitoring of your FID deployment.

### Architecture Comparison

| Feature | `metrics:` (FID Exporter) | `metricsService:` (Script Exporter) |
|---------|---------------------------|-------------------------------------|
| **Deployment Model** | Sidecar container in FID pods | Standalone Deployment |
| **Primary Purpose** | Application metrics & log forwarding | Service availability checks |
| **Metrics Source** | Direct from FID via LDAP/REST APIs | Network checks & REST API endpoints |
| **Push/Pull Model** | Push to Prometheus Pushgateway | Pull via Prometheus scraping |
| **Resource Usage** | Higher (runs per FID pod) | Lower (single deployment) |
| **Dependencies** | Requires Fluentd to be enabled | Independent |
| **Best For** | Deep application metrics | Quick health checks & status |

### FID Exporter (`metrics:` section)

The FID Exporter runs as a sidecar container alongside FID and Fluentd, collecting detailed application metrics and optionally pushing them to a Prometheus Pushgateway.

#### Basic Configuration

```yaml
metrics:
  enabled: true
  image: "radiantone/script_exporter"
  tag: "v2.24.3"
  pushMode: false  # Set to true to push metrics
  pushGateway: "http://prometheus-pushgateway.monitoring.svc.cluster.local:9091"
  pushMetricCron: "* * * * *"  # Every minute
```

#### With Push Mode

```yaml
metrics:
  enabled: true
  pushMode: true
  pushGateway: "http://prometheus-pushgateway.monitoring.svc.cluster.local:9091"
  pushMetricCron: "*/5 * * * *"  # Every 5 minutes

# Also requires Fluentd to be enabled
logging:
  enabled: true
  fluentd:
    enabled: true
    # ... fluentd configuration
```

#### How It Works

1. **Deployment**: The FID Exporter is deployed as a sidecar container in the FID StatefulSet when both `metrics.enabled` and `logging.fluentd.enabled` are true
2. **Startup**: Waits for FID to be ready on port 2636 (LDAPS)
3. **Collection**: Gathers metrics from FID using LDAP and REST API calls
4. **Push Mode**: When enabled, pushes metrics to Prometheus Pushgateway on a schedule
5. **Port**: Exposes metrics on port 9095 for direct scraping

#### Environment Variables

The exporter container receives these environment variables:
- `PUSH_MODE`: Whether to push metrics to gateway
- `PUSHGATEWAY_URI`: URL of the Prometheus Pushgateway
- `PUSH_METRIC_CRON`: Cron schedule for pushing metrics
- `LDAP_URI`: Always set to `ldaps://localhost:2636`
- `JOB_NAME`: Set to the cluster name from ConfigMap

#### Related Configuration: `exporter:` section

The `exporter:` section configures the FID Exporter image and probes:

```yaml
exporter:
  image: "radiantone/fid-exporter"
  imageTag: "dev-1.0.4"
  securityContext:
    enabled: true
    runAsUser: 0
  livenessProbe:
    initialDelaySeconds: 60
    timeoutSeconds: 5
  readinessProbe:
    initialDelaySeconds: 120
    timeoutSeconds: 5
```

### Metrics Service (`metricsService:` section)

The Metrics Service deploys a standalone script_exporter that performs service availability checks and collects FID metrics through REST APIs.

#### Basic Configuration

```yaml
metricsService:
  enabled: true
  image:
    repository: "ricoberger/script_exporter"
    tag: "v2.12.0"
```

#### How It Works

1. **Deployment**: Creates a separate Deployment with a single replica
2. **ConfigMap**: Contains bash scripts for checking service availability
3. **Service**: Exposes metrics on port 9469 with Prometheus annotations
4. **Scripts**: Two main scripts are configured:
   - `fid_ldaps.sh`: Simple LDAPS port check
   - `fid_status.sh`: Comprehensive service checks and metrics collection

#### Metrics Collected

The `fid_status.sh` script checks and reports on:

1. **Service Availability** (0 = online, non-zero = offline):
   - `fid_ldaps_status`: LDAPS service (port 2636)
   - `fid_ldap_status`: LDAP service (port 2389)
   - `fid_http_status`: HTTP/REST service (port 8089)
   - `fid_https_status`: HTTPS/REST service (port 8090)
   - `fid_cp_http_status`: Classic Control Panel HTTP (port 7070)
   - `fid_cp_https_status`: Classic Control Panel HTTPS (port 7171)
   - `fid_admin_http_status`: Admin HTTP (port 9100)
   - `fid_admin_https_status`: Admin HTTPS (port 9101)
   - `fid_zk_status`: Zookeeper service (port 2181)

2. **FID Application Metrics** (when Admin HTTPS is available):
   - Cluster latency metrics
   - Cluster information
   - LDAP operation statistics
   - HDAP store metrics
   - Node monitoring data
   - Node status information

#### Prometheus Integration

The service includes Prometheus annotations for automatic discovery:

```yaml
annotations:
  prometheus.io/path: '/probe'
  prometheus.io/param_script: 'fid_status'
  prometheus.io/port: '9469'
  prometheus.io/scrape: 'true'
```

#### API Key Configuration

If FID requires authentication, the service uses:
- `fid.adminApiKey` from values (if set)
- Or fetches from `rootcreds-<release>-fid` secret

### Combined Usage Example

For comprehensive monitoring, enable both systems:

```yaml
# FID Exporter for detailed metrics with push capability
metrics:
  enabled: true
  pushMode: true
  pushGateway: "http://prometheus-pushgateway.monitoring:9091"
  pushMetricCron: "*/5 * * * *"

# Metrics Service for quick health checks
metricsService:
  enabled: true

# Required for FID Exporter to work
logging:
  enabled: true
  fluentd:
    enabled: true
    # ... your fluentd configuration

# Exporter image configuration
exporter:
  image: "radiantone/fid-exporter"
  imageTag: "dev-1.0.4"
```

### Use Case Scenarios

#### Scenario 1: Simple Health Monitoring

For basic health checks without heavy resource usage:

```yaml
metricsService:
  enabled: true

# Disable the heavier sidecar approach
metrics:
  enabled: false
```

#### Scenario 2: Detailed Metrics with Push Gateway

For comprehensive metrics pushed to a central Prometheus:

```yaml
metrics:
  enabled: true
  pushMode: true
  pushGateway: "http://prometheus-pushgateway:9091"
  pushMetricCron: "*/10 * * * *"  # Every 10 minutes

logging:
  enabled: true
  fluentd:
    enabled: true

metricsService:
  enabled: false  # Not needed if using FID Exporter
```

#### Scenario 3: Full Monitoring Stack

For complete observability with both push and pull models:

```yaml
# Push detailed metrics every 5 minutes
metrics:
  enabled: true
  pushMode: true
  pushGateway: "http://prometheus-pushgateway:9091"
  pushMetricCron: "*/5 * * * *"

# Pull quick health checks
metricsService:
  enabled: true

# Required for metrics
logging:
  enabled: true
  fluentd:
    enabled: true
```

### Troubleshooting

#### FID Exporter Issues

```bash
# Check if exporter sidecar is running
kubectl get pods -n <namespace> -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{range .spec.containers[*]}{.name}{" "}{end}{"\n"}{end}' | grep exporter

# View exporter logs
kubectl logs -n <namespace> <pod-name> -c fid-exporter

# Check if metrics are being pushed
kubectl logs -n <namespace> <pod-name> -c fid-exporter | grep "Pushing metrics"
```

#### Metrics Service Issues

```bash
# Check deployment status
kubectl get deployment iddm-metrics-service -n <namespace>

# View service logs
kubectl logs -n <namespace> -l app.kubernetes.io/component=iddm-metrics-service

# Test metrics endpoint
kubectl port-forward -n <namespace> service/iddm-metrics-service 9469:9469
curl http://localhost:9469/probe?script=fid_status

# Check service connectivity
kubectl exec -n <namespace> deployment/iddm-metrics-service -- nc -zv fid-app 2636
```

### Migration Notes

#### From Legacy `metrics:` Configuration

The old configuration under `metrics:` with `fluentd` subsection is deprecated. Migrate to:

```yaml
# Old (deprecated)
metrics:
  enabled: true
  fluentd:
    enabled: true
    logs: {}
    aggregators: []

# New
metrics:
  enabled: true
  # ... other metrics config

logging:
  enabled: true
  fluentd:
    enabled: true
    logs: {}
    aggregators: []
```

### Best Practices

1. **Choose the Right Tool**:
   - Use `metricsService` for lightweight health monitoring
   - Use `metrics` (FID Exporter) for detailed application metrics
   - Use both for comprehensive coverage

2. **Resource Considerations**:
   - FID Exporter adds ~100m CPU and 128Mi memory per pod
   - Metrics Service uses minimal resources (single deployment)

3. **Push vs Pull**:
   - Use push mode for environments where Prometheus can't reach pods directly
   - Use pull mode (metricsService) for standard Prometheus setups

4. **Monitoring Strategy**:
   - Start with metricsService for basic monitoring
   - Add FID Exporter when you need detailed application metrics
   - Consider push mode for centralized metrics collection

5. **Security**:
   - Store API keys in secrets, not in values
   - Use TLS for push gateway connections in production
   - Limit metrics service access using NetworkPolicies

### Metrics Reference

#### Available Metrics from FID Exporter

- LDAP operation counts and latencies
- Connection pool statistics
- Cache hit rates and sizes
- Replication status and lag
- JVM memory and GC metrics
- Thread pool utilization

#### Available Metrics from Metrics Service

- Service port availability (binary up/down)
- Cluster latency percentiles
- Node synchronization status
- HDAP store statistics
- Real-time LDAP operation metrics

### Integration Examples

#### With Prometheus Operator

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: fid-metrics
spec:
  selector:
    matchLabels:
      app: iddm-metrics-service
  endpoints:
  - port: http
    path: /probe
    params:
      script: ["fid_status"]
    interval: 30s
```

#### With Grafana Dashboard

Import dashboard JSON for FID metrics visualization:
- Service availability overview
- LDAP operation trends
- Performance metrics graphs
- Alert configuration examples
