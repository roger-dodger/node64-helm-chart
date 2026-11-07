# Node64 Helm Chart (unofficial)

An **unofficial** Helm chart for deploying [Node64](https://node64.de) on Kubernetes.

> [!WARNING]
> This chart is a community project. It is **not** affiliated with, endorsed by, or supported by
> the developers of Node64. **Use it at your own risk.** For questions about Node64 itself, refer to
> [node64.de](https://node64.de).

## What it deploys

- A **StatefulSet** running the `ghcr.io/ipv64net/node64` container image
- A **PersistentVolumeClaim** per pod, mounted at `/data` (default size `1Gi`)
- A **Service**, a **ServiceAccount**, and optionally an **Ingress**, a Gateway API **HTTPRoute** and a **HorizontalPodAutoscaler**

## Prerequisites

- Kubernetes cluster
- Helm 3 or newer
- A StorageClass that can provision volumes (or an existing default StorageClass)

## Installation

```sh
git clone https://github.com/roger-dodger/node64-helm-chart.git node64
helm install node64 ./node64 --namespace node64 --create-namespace
```

To override values, pass `--set key=value` or your own values file:

```sh
helm install node64 ./node64 -f my-values.yaml
```

## Configuration

The most relevant values are listed below. See [`values.yaml`](values.yaml) for all options.

| Key | Description | Default |
| --- | --- | --- |
| `image.repository` | Container image | `ghcr.io/ipv64net/node64` |
| `image.tag` | Image tag (defaults to the chart `appVersion`) | `""` |
| `image.pullPolicy` | Image pull policy | `Always` |
| `replicaCount` | Number of pods | `1` |
| `persistence.enabled` | Use a PersistentVolumeClaim for `/data`. If `false`, an `emptyDir` is used and data is lost when the pod is recreated | `true` |
| `persistence.storageClass` | StorageClass for the volume (empty uses the cluster default) | `""` |
| `persistence.accessModes` | Access modes of the volume | `["ReadWriteOnce"]` |
| `persistence.size` | Size of the volume | `1Gi` |
| `service.type` | Service type | `ClusterIP` |
| `service.port` | Service and container port | `8080` |
| `ingress.enabled` | Create an Ingress | `false` |
| `httpRoute.enabled` | Create a Gateway API HTTPRoute | `false` |
| `resources` | CPU/memory requests and limits | `{}` |

## Persistence

Each pod gets its own volume named `data-<release>-node64-<n>`, mounted at `/data`.
`helm uninstall` does **not** delete these volumes, so your data is kept. To remove it as well:

```sh
kubectl delete pvc -l app.kubernetes.io/instance=<release> -n <namespace>
```

Note that the size of an existing volume cannot be changed through `helm upgrade`; it has to be
resized on the PVC directly (if the StorageClass supports volume expansion).

## Uninstall

```sh
helm uninstall node64 --namespace node64
```

## License

Copyright 2026 Roger Blum

This chart is licensed under the [Apache License 2.0](LICENSE). Node64 and its container image
are the property of their respective owners and are not covered by this license.
