```bash

$ operator-sdk olm install
INFO[0000] Fetching CRDs for version "latest"
INFO[0000] Fetching resources for resolved version "latest"
FATA[0059] Failed to install OLM version "latest": failed to get resources: failed to fetch CRDs: request failed: failed GET 'https://github.com/operator-framework/operator-lifecycle-manager/releases/latest/download/crds.yaml': Get "https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.27.0/crds.yaml": dial tcp 20.205.243.166:443: connect: operation timed out
$

https://github.com/operator-framework/operator-lifecycle-manager

```

customresourcedefinition.apiextensions.k8s.io
	catalogsources.operators.coreos.com
	clusterserviceversions.operators.coreos.com
	installplans.operators.coreos.com
	olmconfigs.operators.coreos.com
	operatorconditions.operators.coreos.com
	operatorgroups.operators.coreos.com
	operators.operators.coreos.com
	subscriptions.operators.coreos.com

namespace
	olm
	operators

serviceaccount
	olm-operator-serviceaccount

clusterrole.rbac.authorization.k8s.io
	system:controller:operator-lifecycle-manager
	aggregate-olm-edit
	aggregate-olm-view

clusterrolebinding.rbac.authorization.k8s.io
	olm-operator-binding-olm

deployment.apps
	olm-operator
	catalog-operator

olmconfig.operators.coreos.com
	cluster

operatorgroup.operators.coreos.com
	global-operators
	olm-operators

clusterserviceversion.operators.coreos.com
	packageserver

catalogsource.operators.coreos.com
	operatorhubio-catalog

```bash
$ pwd
~/work/code/go_code/operator-framework/operator-sdk-samples/go/memcached-operator/deploy/olm-catalog

$ tree -a .
.
└── memcached-operator
    └── manifests
        ├── cache.example.com_memcacheds_crd.yaml
        └── memcached-operator.clusterserviceversion.yaml

3 directories, 2 files
$

$ opm version
Version: version.Version{OpmVersion:"v1.43.1", GitCommit:"48ad75db", BuildDate:"2024-05-24T13:23:15Z", GoOs:"darwin", GoArch:"amd64"}
$

$ opm alpha bundle generate --directory ./memcached-operator/manifests --package memcached-operator --channels stable --default stable
INFO[0000] Building annotations.yaml
INFO[0000] Writing annotations.yaml in /Users/huzhi/work/code/go_code/operator-framework/operator-sdk-samples/go/memcached-operator/deploy/olm-catalog/memcached-operator/metadata
INFO[0000] Building Dockerfile
INFO[0000] Writing bundle.Dockerfile in /Users/huzhi/work/code/go_code/operator-framework/operator-sdk-samples/go/memcached-operator/deploy/olm-catalog

$ tree -a .
.
├── bundle.Dockerfile #################
└── memcached-operator
    ├── manifests
    │   ├── cache.example.com_memcacheds_crd.yaml
    │   └── memcached-operator.clusterserviceversion.yaml
    └── metadata #################
        └── annotations.yaml #################

4 directories, 4 files
$

$ docker build -t registry.cn-hangzhou.aliyuncs.com/lanzhiwang_kubeflow/memcached-operator-bundle:latest -f bundle.Dockerfile .

# $ mkdir -p cool-catalog/memcached-operator
# $ opm generate dockerfile cool-catalog
$ mkdir -p cool-catalog/memcached-operator
$ tree -a .
.
├── bundle.Dockerfile
├── cool-catalog #################
│   └── memcached-operator #################
└── memcached-operator
    ├── manifests
    │   ├── cache.example.com_memcacheds_crd.yaml
    │   └── memcached-operator.clusterserviceversion.yaml
    └── metadata
        └── annotations.yaml

6 directories, 4 files

$ opm generate dockerfile cool-catalog
$ tree -a .
.
├── bundle.Dockerfile
├── cool-catalog
│   └── memcached-operator
├── cool-catalog.Dockerfile #################
└── memcached-operator
    ├── manifests
    │   ├── cache.example.com_memcacheds_crd.yaml
    │   └── memcached-operator.clusterserviceversion.yaml
    └── metadata
        └── annotations.yaml

6 directories, 5 files
$

$ cat << EOF > memcached-operator-template.yaml
Schema: olm.semver
GenerateMajorChannels: true
GenerateMinorChannels: false
Stable:
  Bundles:
  - Image: registry.cn-hangzhou.aliyuncs.com/lanzhiwang_kubeflow/memcached-operator-bundle:latest
EOF

$ tree -a .
.
├── bundle.Dockerfile
├── cool-catalog
│   └── memcached-operator
├── cool-catalog.Dockerfile
├── memcached-operator
│   ├── manifests
│   │   ├── cache.example.com_memcacheds_crd.yaml
│   │   └── memcached-operator.clusterserviceversion.yaml
│   └── metadata
│       └── annotations.yaml
└── memcached-operator-template.yaml #################

6 directories, 6 files
$

$ opm alpha render-template semver -o yaml < memcached-operator-template.yaml > cool-catalog/catalog.yaml

$ tree -a .
.
├── bundle.Dockerfile
├── cool-catalog
│   ├── catalog.yaml #################
│   └── memcached-operator
├── cool-catalog.Dockerfile
├── memcached-operator
│   ├── manifests
│   │   ├── cache.example.com_memcacheds_crd.yaml
│   │   └── memcached-operator.clusterserviceversion.yaml
│   └── metadata
│       └── annotations.yaml
└── memcached-operator-template.yaml

6 directories, 7 files
$

$ opm validate cool-catalog
$ echo $?
0
$

$ docker build -f cool-catalog.Dockerfile -t registry.cn-hangzhou.aliyuncs.com/lanzhiwang_kubeflow/cool-catalog:latest .
$ docker push registry.cn-hangzhou.aliyuncs.com/lanzhiwang_kubeflow/cool-catalog:latest



$ cat << EOF > cool-catalog-catalogsource.yaml
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: cool-catalog
  namespace: operator
spec:
  sourceType: grpc
  image: registry.cn-hangzhou.aliyuncs.com/lanzhiwang_kubeflow/cool-catalog:latest
  displayName: Coolest Catalog
  publisher: Me
  updateStrategy:
    registryPoll:
      interval: 10m
EOF

$ tree -a .
.
├── bundle.Dockerfile
├── cool-catalog
│   ├── catalog.yaml
│   └── memcached-operator
├── cool-catalog-catalogsource.yaml #################
├── cool-catalog.Dockerfile
├── memcached-operator
│   ├── manifests
│   │   ├── cache.example.com_memcacheds_crd.yaml
│   │   └── memcached-operator.clusterserviceversion.yaml
│   └── metadata
│       └── annotations.yaml
└── memcached-operator-template.yaml

6 directories, 8 files
$

$ kubectl create ns operator
namespace/operator created

$ kubectl apply -f cool-catalog-catalogsource.yaml
catalogsource.operators.coreos.com/cool-catalog created
$

$ kubectl get packagemanifest memcached-operator -n operator -o jsonpath="{.status.channels[0].currentCSVDesc.installModes}"
[
	{"supported":true,"type":"OwnNamespace"},
	{"supported":true,"type":"SingleNamespace"},
	{"supported":false,"type":"MultiNamespace"},
	{"supported":true,"type":"AllNamespaces"}
]
$


$ cat << EOF > og.yaml
apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  name: my-group
  namespace: operator
spec:
  targetNamespaces:
    - operator
EOF

$ tree -a .
.
├── bundle.Dockerfile
├── cool-catalog
│   ├── catalog.yaml
│   └── memcached-operator
├── cool-catalog-catalogsource.yaml
├── cool-catalog.Dockerfile
├── memcached-operator
│   ├── manifests
│   │   ├── cache.example.com_memcacheds_crd.yaml
│   │   └── memcached-operator.clusterserviceversion.yaml
│   └── metadata
│       └── annotations.yaml
├── memcached-operator-template.yaml
└── og.yaml #################

6 directories, 9 files
$

$ kubectl apply -f og.yaml
operatorgroup.operators.coreos.com/my-group created
$

$ ../../../../get-crd.sh
***************** olmconfigs.operators.coreos.com *****************
NAME      AGE
cluster   85m

***************** operatorgroups.operators.coreos.com *****************
NAMESPACE   NAME               AGE
olm         olm-operators      85m
operator    my-group           2m55s
operators   global-operators   85m

***************** clusterserviceversions.operators.coreos.com *****************
NAMESPACE   NAME            DISPLAY          VERSION   REPLACES   PHASE
olm         packageserver   Package Server   0.27.0               Succeeded

***************** catalogsources.operators.coreos.com *****************
NAMESPACE   NAME                    DISPLAY               TYPE   PUBLISHER        AGE
olm         operatorhubio-catalog   Community Operators   grpc   OperatorHub.io   85m
operator    cool-catalog            Coolest Catalog       grpc   Me               15m

***************** installplans.operators.coreos.com *****************
No resources found

***************** operatorconditions.operators.coreos.com *****************
NAMESPACE   NAME            AGE
olm         packageserver   84m

***************** operators.operators.coreos.com *****************
No resources found

***************** subscriptions.operators.coreos.com *****************
No resources found

$ cat << EOF > sub.yaml
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: sub-to-my-operator
  namespace: operator
spec:
  channel: stable
  name: memcached-operator
  source: cool-catalog
  sourceNamespace: operator
  installPlanApproval: Automatic
EOF

$ tree -a .
.
├── bundle.Dockerfile
├── cool-catalog
│   ├── catalog.yaml
│   └── memcached-operator
├── cool-catalog-catalogsource.yaml
├── cool-catalog.Dockerfile
├── memcached-operator
│   ├── manifests
│   │   ├── cache.example.com_memcacheds_crd.yaml
│   │   └── memcached-operator.clusterserviceversion.yaml
│   └── metadata
│       └── annotations.yaml
├── memcached-operator-template.yaml
├── og.yaml
└── sub.yaml #################

6 directories, 10 files
$


$ kubectl apply -f sub.yaml
subscription.operators.coreos.com/sub-to-my-operator created
╭─huzhi@localhost ~/work/code/go_code/operator-framework/operator-sdk-samples/go/memcached-operator/deploy/olm-catalog ‹learn-v0.19.2●›
╰─$ ../../../../get-crd.sh
***************** olmconfigs.operators.coreos.com *****************
NAME      AGE
cluster   88m

***************** operatorgroups.operators.coreos.com *****************
NAMESPACE   NAME               AGE
olm         olm-operators      88m
operator    my-group           5m42s
operators   global-operators   88m

***************** clusterserviceversions.operators.coreos.com *****************
NAMESPACE   NAME            DISPLAY          VERSION   REPLACES   PHASE
olm         packageserver   Package Server   0.27.0               Succeeded

***************** catalogsources.operators.coreos.com *****************
NAMESPACE   NAME                    DISPLAY               TYPE   PUBLISHER        AGE
olm         operatorhubio-catalog   Community Operators   grpc   OperatorHub.io   88m
operator    cool-catalog            Coolest Catalog       grpc   Me               18m

***************** installplans.operators.coreos.com *****************
No resources found

***************** operatorconditions.operators.coreos.com *****************
NAMESPACE   NAME            AGE
olm         packageserver   87m

***************** operators.operators.coreos.com *****************
NAME                          AGE
memcached-operator.operator   5s

***************** subscriptions.operators.coreos.com *****************
NAMESPACE   NAME                 PACKAGE              SOURCE         CHANNEL
operator    sub-to-my-operator   memcached-operator   cool-catalog   stable




```