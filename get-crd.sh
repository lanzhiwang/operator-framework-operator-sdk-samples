#!/usr/bin/env bash
# set -x

echo "***************** olmconfigs.operators.coreos.com *****************"
kubectl get olmconfigs.operators.coreos.com -A
echo ""

echo "***************** operatorgroups.operators.coreos.com *****************"
kubectl get operatorgroups.operators.coreos.com -A
echo ""

echo "***************** clusterserviceversions.operators.coreos.com *****************"
kubectl get clusterserviceversions.operators.coreos.com -A
echo ""

echo "***************** catalogsources.operators.coreos.com *****************"
kubectl get catalogsources.operators.coreos.com -A
echo ""

echo "***************** installplans.operators.coreos.com *****************"
kubectl get installplans.operators.coreos.com -A
echo ""

echo "***************** operatorconditions.operators.coreos.com *****************"
kubectl get operatorconditions.operators.coreos.com -A
echo ""

echo "***************** operators.operators.coreos.com *****************"
kubectl get operators.operators.coreos.com -A
echo ""

echo "***************** subscriptions.operators.coreos.com *****************"
kubectl get subscriptions.operators.coreos.com -A
echo ""

echo "***************** packagemanifests *****************"
kubectl get packagemanifests -A
echo ""

# $ kubectl api-resources
# NAME                              SHORTNAMES   APIVERSION                             NAMESPACED   KIND
# catalogsources                    catsrc       operators.coreos.com/v1alpha1          true         CatalogSource
# clusterserviceversions            csv,csvs     operators.coreos.com/v1alpha1          true         ClusterServiceVersion
# installplans                      ip           operators.coreos.com/v1alpha1          true         InstallPlan
# olmconfigs                                     operators.coreos.com/v1                false        OLMConfig
# operatorconditions                condition    operators.coreos.com/v2                true         OperatorCondition
# operatorgroups                    og           operators.coreos.com/v1                true         OperatorGroup
# operators                                      operators.coreos.com/v1                false        Operator
# subscriptions                     sub,subs     operators.coreos.com/v1alpha1          true         Subscription
# packagemanifests                               packages.operators.coreos.com/v1       true         PackageManifest
# $

# $ ./get-crd.sh
# ***************** olmconfigs.operators.coreos.com *****************
# apiVersion: v1
# items:
# - apiVersion: operators.coreos.com/v1
#   kind: OLMConfig
#   metadata:
#     creationTimestamp: "2024-05-08T05:46:12Z"
#     generation: 1
#     name: cluster
#     resourceVersion: "786"
#     uid: cde5dd3a-18ce-4f29-a000-424fcff3382e
#   status:
#     conditions:
#     - lastTransitionTime: "2024-05-08T05:46:13Z"
#       message: Copied CSVs are enabled and present across the cluster
#       reason: CopiedCSVsEnabled
#       status: "False"
#       type: DisabledCopiedCSVs
# kind: List
# metadata:
#   resourceVersion: ""

# ***************** operatorgroups.operators.coreos.com *****************
# apiVersion: v1
# items:
# - apiVersion: operators.coreos.com/v1
#   kind: OperatorGroup
#   metadata:
#     annotations:
#       olm.providedAPIs: PackageManifest.v1.packages.operators.coreos.com
#     creationTimestamp: "2024-05-08T05:46:12Z"
#     generation: 1
#     name: olm-operators
#     namespace: olm
#     resourceVersion: "790"
#     uid: 90d8a8f5-d02e-4918-96ed-a393884691b8
#   spec:
#     targetNamespaces:
#     - olm
#     upgradeStrategy: Default
#   status:
#     lastUpdated: "2024-05-08T05:46:13Z"
#     namespaces:
#     - olm
# - apiVersion: operators.coreos.com/v1
#   kind: OperatorGroup
#   metadata:
#     creationTimestamp: "2024-05-08T05:46:12Z"
#     generation: 1
#     name: global-operators
#     namespace: operators
#     resourceVersion: "789"
#     uid: bb0c3e82-0237-4cc3-a85b-bb70e5e57185
#   spec:
#     upgradeStrategy: Default
#   status:
#     lastUpdated: "2024-05-08T05:46:13Z"
#     namespaces:
#     - ""
# kind: List
# metadata:
#   resourceVersion: ""

# ***************** clusterserviceversions.operators.coreos.com *****************
# apiVersion: v1
# items:
# - apiVersion: operators.coreos.com/v1alpha1
#   kind: ClusterServiceVersion
#   metadata:
#     annotations:
#       olm.operatorGroup: olm-operators
#       olm.operatorNamespace: olm
#       olm.targetNamespaces: olm
#     creationTimestamp: "2024-05-08T05:46:12Z"
#     finalizers:
#     - operators.coreos.com/csv-cleanup
#     generation: 2
#     labels:
#       olm.version: v0.27.0
#     name: packageserver
#     namespace: olm
#     resourceVersion: "2507"
#     uid: 8522b825-b186-4a33-81b6-d8f53932b306
#   spec:
#     apiservicedefinitions:
#       owned:
#       - containerPort: 5443
#         deploymentName: packageserver
#         description: A PackageManifest is a resource generated from existing CatalogSources
#           and their ConfigMaps
#         displayName: PackageManifest
#         group: packages.operators.coreos.com
#         kind: PackageManifest
#         name: packagemanifests
#         version: v1
#     cleanup:
#       enabled: false
#     customresourcedefinitions: {}
#     description: Represents an Operator package that is available from a given CatalogSource
#       which will resolve to a ClusterServiceVersion.
#     displayName: Package Server
#     install:
#       spec:
#         clusterPermissions:
#         - rules:
#           - apiGroups:
#             - authorization.k8s.io
#             resources:
#             - subjectaccessreviews
#             verbs:
#             - create
#             - get
#           - apiGroups:
#             - ""
#             resources:
#             - configmaps
#             verbs:
#             - get
#             - list
#             - watch
#           - apiGroups:
#             - operators.coreos.com
#             resources:
#             - catalogsources
#             verbs:
#             - get
#             - list
#             - watch
#           - apiGroups:
#             - packages.operators.coreos.com
#             resources:
#             - packagemanifests
#             verbs:
#             - get
#             - list
#           serviceAccountName: olm-operator-serviceaccount
#         deployments:
#         - name: packageserver
#           spec:
#             replicas: 2
#             selector:
#               matchLabels:
#                 app: packageserver
#             strategy:
#               rollingUpdate:
#                 maxSurge: 1
#                 maxUnavailable: 1
#               type: RollingUpdate
#             template:
#               metadata:
#                 creationTimestamp: null
#                 labels:
#                   app: packageserver
#               spec:
#                 containers:
#                 - command:
#                   - /bin/package-server
#                   - -v=4
#                   - --secure-port
#                   - "5443"
#                   - --global-namespace
#                   - olm
#                   image: quay.io/operator-framework/olm:v0.27.0
#                   imagePullPolicy: Always
#                   livenessProbe:
#                     httpGet:
#                       path: /healthz
#                       port: 5443
#                       scheme: HTTPS
#                   name: packageserver
#                   ports:
#                   - containerPort: 5443
#                     protocol: TCP
#                   readinessProbe:
#                     httpGet:
#                       path: /healthz
#                       port: 5443
#                       scheme: HTTPS
#                   resources:
#                     requests:
#                       cpu: 10m
#                       memory: 50Mi
#                   securityContext:
#                     allowPrivilegeEscalation: false
#                     capabilities:
#                       drop:
#                       - ALL
#                   terminationMessagePolicy: FallbackToLogsOnError
#                   volumeMounts:
#                   - mountPath: /tmp
#                     name: tmpfs
#                 nodeSelector:
#                   kubernetes.io/os: linux
#                 securityContext:
#                   runAsNonRoot: true
#                   seccompProfile:
#                     type: RuntimeDefault
#                 serviceAccountName: olm-operator-serviceaccount
#                 volumes:
#                 - emptyDir: {}
#                   name: tmpfs
#       strategy: deployment
#     installModes:
#     - supported: true
#       type: OwnNamespace
#     - supported: true
#       type: SingleNamespace
#     - supported: true
#       type: MultiNamespace
#     - supported: true
#       type: AllNamespaces
#     keywords:
#     - packagemanifests
#     - olm
#     - packages
#     links:
#     - name: Package Server
#       url: https://github.com/operator-framework/operator-lifecycle-manager/tree/master/pkg/package-server
#     maintainers:
#     - email: openshift-operators@redhat.com
#       name: Red Hat
#     maturity: alpha
#     minKubeVersion: 1.11.0
#     provider:
#       name: Red Hat
#     version: 0.27.0
#   status:
#     certsLastUpdated: "2024-05-08T05:46:13Z"
#     certsRotateAt: "2026-05-07T05:46:13Z"
#     cleanup: {}
#     conditions:
#     - lastTransitionTime: "2024-05-08T05:46:13Z"
#       lastUpdateTime: "2024-05-08T05:46:13Z"
#       message: requirements not yet checked
#       phase: Pending
#       reason: RequirementsUnknown
#     - lastTransitionTime: "2024-05-08T05:46:13Z"
#       lastUpdateTime: "2024-05-08T05:46:13Z"
#       message: all requirements found, attempting install
#       phase: InstallReady
#       reason: AllRequirementsMet
#     - lastTransitionTime: "2024-05-08T05:46:13Z"
#       lastUpdateTime: "2024-05-08T05:46:13Z"
#       message: waiting for install components to report healthy
#       phase: Installing
#       reason: InstallSucceeded
#     - lastTransitionTime: "2024-05-08T05:46:13Z"
#       lastUpdateTime: "2024-05-08T05:46:13Z"
#       message: apiServices not installed
#       phase: Installing
#       reason: InstallWaiting
#     - lastTransitionTime: "2024-05-08T05:48:25Z"
#       lastUpdateTime: "2024-05-08T05:48:25Z"
#       message: install strategy completed with no errors
#       phase: Succeeded
#       reason: InstallSucceeded
#     - lastTransitionTime: "2024-05-08T06:38:41Z"
#       lastUpdateTime: "2024-05-08T06:38:41Z"
#       message: apiServices not installed
#       phase: Failed
#       reason: ComponentUnhealthy
#     - lastTransitionTime: "2024-05-08T06:38:41Z"
#       lastUpdateTime: "2024-05-08T06:38:41Z"
#       message: apiServices not installed
#       phase: Pending
#       reason: NeedsReinstall
#     - lastTransitionTime: "2024-05-08T06:38:41Z"
#       lastUpdateTime: "2024-05-08T06:38:41Z"
#       message: all requirements found, attempting install
#       phase: InstallReady
#       reason: AllRequirementsMet
#     - lastTransitionTime: "2024-05-08T06:38:41Z"
#       lastUpdateTime: "2024-05-08T06:38:41Z"
#       message: waiting for install components to report healthy
#       phase: Installing
#       reason: InstallSucceeded
#     - lastTransitionTime: "2024-05-08T06:38:41Z"
#       lastUpdateTime: "2024-05-08T06:38:41Z"
#       message: apiServices not installed
#       phase: Installing
#       reason: InstallWaiting
#     - lastTransitionTime: "2024-05-08T06:38:54Z"
#       lastUpdateTime: "2024-05-08T06:38:54Z"
#       message: install strategy completed with no errors
#       phase: Succeeded
#       reason: InstallSucceeded
#     lastTransitionTime: "2024-05-08T06:38:54Z"
#     lastUpdateTime: "2024-05-08T06:38:54Z"
#     message: install strategy completed with no errors
#     phase: Succeeded
#     reason: InstallSucceeded
#     requirementStatus:
#     - group: operators.coreos.com
#       kind: ClusterServiceVersion
#       message: CSV minKubeVersion (1.11.0) less than server version (v1.28.3)
#       name: packageserver
#       status: Present
#       version: v1alpha1
#     - group: apiregistration.k8s.io
#       kind: APIService
#       message: ""
#       name: v1.packages.operators.coreos.com
#       status: DeploymentFound
#       version: v1
#     - dependents:
#       - group: rbac.authorization.k8s.io
#         kind: PolicyRule
#         message: cluster rule:{"verbs":["create","get"],"apiGroups":["authorization.k8s.io"],"resources":["subjectaccessreviews"]}
#         status: Satisfied
#         version: v1
#       - group: rbac.authorization.k8s.io
#         kind: PolicyRule
#         message: cluster rule:{"verbs":["get","list","watch"],"apiGroups":[""],"resources":["configmaps"]}
#         status: Satisfied
#         version: v1
#       - group: rbac.authorization.k8s.io
#         kind: PolicyRule
#         message: cluster rule:{"verbs":["get","list","watch"],"apiGroups":["operators.coreos.com"],"resources":["catalogsources"]}
#         status: Satisfied
#         version: v1
#       - group: rbac.authorization.k8s.io
#         kind: PolicyRule
#         message: cluster rule:{"verbs":["get","list"],"apiGroups":["packages.operators.coreos.com"],"resources":["packagemanifests"]}
#         status: Satisfied
#         version: v1
#       group: ""
#       kind: ServiceAccount
#       message: ""
#       name: olm-operator-serviceaccount
#       status: Present
#       version: v1
# kind: List
# metadata:
#   resourceVersion: ""

# ***************** catalogsources.operators.coreos.com *****************
# apiVersion: v1
# items:
# - apiVersion: operators.coreos.com/v1alpha1
#   kind: CatalogSource
#   metadata:
#     creationTimestamp: "2024-05-08T05:46:12Z"
#     generation: 1
#     name: operatorhubio-catalog
#     namespace: olm
#     resourceVersion: "2428"
#     uid: 60c6d30a-8d1f-4250-a0a1-3c54399e6c92
#   spec:
#     displayName: Community Operators
#     grpcPodConfig:
#       securityContextConfig: restricted
#     image: quay.io/operatorhubio/catalog:latest
#     publisher: OperatorHub.io
#     sourceType: grpc
#     updateStrategy:
#       registryPoll:
#         interval: 60m
#   status:
#     connectionState:
#       address: operatorhubio-catalog.olm.svc:50051
#       lastConnect: "2024-05-08T06:38:41Z"
#       lastObservedState: READY
#     registryService:
#       createdAt: "2024-05-08T05:46:13Z"
#       port: "50051"
#       protocol: grpc
#       serviceName: operatorhubio-catalog
#       serviceNamespace: olm
# kind: List
# metadata:
#   resourceVersion: ""

# ***************** installplans.operators.coreos.com *****************
# apiVersion: v1
# items: []
# kind: List
# metadata:
#   resourceVersion: ""

# ***************** operatorconditions.operators.coreos.com *****************
# apiVersion: v1
# items:
# - apiVersion: operators.coreos.com/v2
#   kind: OperatorCondition
#   metadata:
#     creationTimestamp: "2024-05-08T05:46:13Z"
#     generation: 1
#     name: packageserver
#     namespace: olm
#     ownerReferences:
#     - apiVersion: operators.coreos.com/v1alpha1
#       blockOwnerDeletion: false
#       controller: true
#       kind: ClusterServiceVersion
#       name: packageserver
#       uid: 8522b825-b186-4a33-81b6-d8f53932b306
#     resourceVersion: "814"
#     uid: f0e3c72c-0ef2-42a7-9137-047480804898
#   spec:
#     deployments:
#     - packageserver
#     serviceAccounts:
#     - olm-operator-serviceaccount
# kind: List
# metadata:
#   resourceVersion: ""

# ***************** operators.operators.coreos.com *****************
# apiVersion: v1
# items: []
# kind: List
# metadata:
#   resourceVersion: ""

# ***************** subscriptions.operators.coreos.com *****************
# apiVersion: v1
# items: []
# kind: List
# metadata:
#   resourceVersion: ""

# ***************** packagemanifests *****************
# NAMESPACE   NAME                                       CATALOG               AGE
# olm         carbonetes-operator                        Community Operators   55m
# olm         sonar-operator                             Community Operators   55m
# olm         percona-xtradb-cluster-operator            Community Operators   55m
# olm         redis-operator                             Community Operators   55m
# olm         horreum-operator                           Community Operators   55m
# olm         ack-elbv2-controller                       Community Operators   55m
# olm         openebs                                    Community Operators   55m
# olm         layer7-operator                            Community Operators   55m
# olm         ack-sagemaker-controller                   Community Operators   55m
# olm         nfd-operator                               Community Operators   55m
# olm         seldon-operator                            Community Operators   55m
# olm         cluster-impairment-operator                Community Operators   55m
# olm         searchpe-operator                          Community Operators   55m
# olm         debezium-operator                          Community Operators   55m
# olm         hive-operator                              Community Operators   55m
# olm         percona-postgresql-operator                Community Operators   55m
# olm         kiali                                      Community Operators   55m
# olm         snapscheduler                              Community Operators   55m
# olm         etcd                                       Community Operators   55m
# olm         awx-operator                               Community Operators   55m
# olm         service-binding-operator                   Community Operators   55m
# olm         kernel-module-management-hub               Community Operators   55m
# olm         dynatrace-operator                         Community Operators   55m
# olm         rocketmq-operator                          Community Operators   55m
# olm         yaks                                       Community Operators   55m
# olm         ack-documentdb-controller                  Community Operators   55m
# olm         mongodb-enterprise                         Community Operators   55m
# olm         edp-keycloak-operator                      Community Operators   55m
# olm         stackgres                                  Community Operators   55m
# olm         ks-releaser-operator                       Community Operators   55m
# olm         k8gb                                       Community Operators   55m
# olm         myvirtualdirectory                         Community Operators   55m
# olm         kom-operator                               Community Operators   55m
# olm         monocle-operator                           Community Operators   55m
# olm         api-operator                               Community Operators   55m
# olm         couchbase-enterprise                       Community Operators   55m
# olm         nfs-provisioner-operator                   Community Operators   55m
# olm         dns-operator                               Community Operators   55m
# olm         portworx-essentials                        Community Operators   55m
# olm         netobserv-operator                         Community Operators   55m
# olm         ack-applicationautoscaling-controller      Community Operators   55m
# olm         keycloak-permissions-operator              Community Operators   55m
# olm         ember-csi-operator                         Community Operators   55m
# olm         hyperfoil-bundle                           Community Operators   55m
# olm         argocd-operator                            Community Operators   55m
# olm         hawtio-operator                            Community Operators   55m
# olm         appdynamics-operator                       Community Operators   55m
# olm         ndb-operator                               Community Operators   55m
# olm         nexus-operator-m88i                        Community Operators   55m
# olm         hedvig-operator                            Community Operators   55m
# olm         ack-keyspaces-controller                   Community Operators   55m
# olm         microcks                                   Community Operators   55m
# olm         ham-deploy                                 Community Operators   55m
# olm         wso2am-operator                            Community Operators   55m
# olm         alvearie-imaging-ingestion                 Community Operators   55m
# olm         hazelcast-platform-operator                Community Operators   55m
# olm         lib-bucket-provisioner                     Community Operators   55m
# olm         rook-ceph                                  Community Operators   55m
# olm         kube-arangodb                              Community Operators   55m
# olm         sonataflow-operator                        Community Operators   55m
# olm         beegfs-csi-driver-operator                 Community Operators   55m
# olm         falcon-operator                            Community Operators   55m
# olm         cte-k8s-operator                           Community Operators   55m
# olm         machine-deletion-operator                  Community Operators   55m
# olm         moodle-operator                            Community Operators   55m
# olm         ack-acm-controller                         Community Operators   55m
# olm         dnext-operator                             Community Operators   55m
# olm         ack-route53-controller                     Community Operators   55m
# olm         minio-operator                             Community Operators   55m
# olm         traefikee-operator                         Community Operators   55m
# olm         nexus-operator                             Community Operators   55m
# olm         ecr-secret-operator                        Community Operators   55m
# olm         customized-user-remediation                Community Operators   55m
# olm         cloud-native-postgresql                    Community Operators   55m
# olm         ack-s3-controller                          Community Operators   55m
# olm         banzaicloud-kafka-operator                 Community Operators   55m
# olm         ibm-block-csi-operator-community           Community Operators   55m
# olm         verticadb-operator                         Community Operators   55m
# olm         strimzi-kafka-operator                     Community Operators   55m
# olm         node-maintenance-operator                  Community Operators   55m
# olm         dapr-kubernetes-operator                   Community Operators   55m
# olm         hpe-csi-operator                           Community Operators   55m
# olm         fence-agents-remediation                   Community Operators   55m
# olm         apch-operator                              Community Operators   55m
# olm         klusterlet                                 Community Operators   55m
# olm         rook-edgefs                                Community Operators   55m
# olm         halkyon                                    Community Operators   55m
# olm         community-trivy-operator                   Community Operators   55m
# olm         pubsubplus-eventbroker-operator            Community Operators   55m
# olm         multicluster-operators-subscription        Community Operators   55m
# olm         lightbend-console-operator                 Community Operators   55m
# olm         postgresql-operator                        Community Operators   55m
# olm         self-node-remediation                      Community Operators   55m
# olm         tagger                                     Community Operators   55m
# olm         apicurio-registry                          Community Operators   55m
# olm         skupper-operator                           Community Operators   55m
# olm         portworx                                   Community Operators   55m
# olm         kaap                                       Community Operators   55m
# olm         ack-organizations-controller               Community Operators   55m
# olm         virt-gateway-operator                      Community Operators   55m
# olm         datadog-operator                           Community Operators   55m
# olm         metering-upstream                          Community Operators   55m
# olm         ceph-s3-operator                           Community Operators   55m
# olm         ack-dynamodb-controller                    Community Operators   55m
# olm         lms-moodle-operator                        Community Operators   55m
# olm         flux                                       Community Operators   55m
# olm         cloudnative-pg                             Community Operators   55m
# olm         jaeger                                     Community Operators   55m
# olm         camel-k                                    Community Operators   55m
# olm         prometheus-exporter-operator               Community Operators   55m
# olm         flagsmith                                  Community Operators   55m
# olm         ack-efs-controller                         Community Operators   55m
# olm         oci-ccm-operator                           Community Operators   55m
# olm         anchore-engine                             Community Operators   55m
# olm         wildfly                                    Community Operators   55m
# olm         ack-eks-controller                         Community Operators   55m
# olm         kubero-operator                            Community Operators   55m
# olm         leaksignal-operator                        Community Operators   55m
# olm         mysql                                      Community Operators   55m
# olm         camel-karavan-operator                     Community Operators   55m
# olm         kubernetes-imagepuller-operator            Community Operators   55m
# olm         airflow-helm-operator                      Community Operators   55m
# olm         elastic-phenix-operator                    Community Operators   55m
# olm         siddhi-operator                            Community Operators   55m
# olm         ipfs-operator                              Community Operators   55m
# olm         neuvector-operator                         Community Operators   55m
# olm         susql-operator                             Community Operators   55m
# olm         atlasmap-operator                          Community Operators   55m
# olm         spinnaker-operator                         Community Operators   55m
# olm         kubeflow                                   Community Operators   55m
# olm         cc-operator                                Community Operators   55m
# olm         aerospike-kubernetes-operator              Community Operators   55m
# olm         vault                                      Community Operators   55m
# olm         cos-bucket-operator                        Community Operators   55m
# olm         mongodb-atlas-kubernetes                   Community Operators   55m
# olm         elastic-cloud-eck                          Community Operators   55m
# olm         cryostat-operator                          Community Operators   55m
# olm         argocd-operator-helm                       Community Operators   55m
# olm         multi-nic-cni-operator                     Community Operators   55m
# olm         zoperator                                  Community Operators   55m
# olm         qserv-operator                             Community Operators   55m
# olm         infinispan                                 Community Operators   55m
# olm         mariadb-operator                           Community Operators   55m
# olm         xrootd-operator                            Community Operators   55m
# olm         tempo-operator                             Community Operators   55m
# olm         gitlab-runner-operator                     Community Operators   55m
# olm         app-director-operator                      Community Operators   55m
# olm         ibmcloud-operator                          Community Operators   55m
# olm         ack-lambda-controller                      Community Operators   55m
# olm         sn-operator                                Community Operators   55m
# olm         ack-kinesis-controller                     Community Operators   55m
# olm         istio                                      Community Operators   55m
# olm         tf-controller                              Community Operators   55m
# olm         joget-tomcat-operator                      Community Operators   55m
# olm         tektoncd-operator                          Community Operators   55m
# olm         mondoo-operator                            Community Operators   55m
# olm         composable-operator                        Community Operators   55m
# olm         ack-cloudwatch-controller                  Community Operators   55m
# olm         grafana-operator                           Community Operators   55m
# olm         tidb-operator                              Community Operators   55m
# olm         meshery-operator                           Community Operators   55m
# olm         cass-operator-community                    Community Operators   55m
# olm         ibm-application-gateway-operator           Community Operators   55m
# olm         parseable-operator                         Community Operators   55m
# olm         gitlab-operator-kubernetes                 Community Operators   55m
# olm         t8c                                        Community Operators   55m
# olm         kong                                       Community Operators   55m
# olm         telegraf-operator                          Community Operators   55m
# olm         ublhub-operator                            Community Operators   55m
# olm         log2rbac                                   Community Operators   55m
# olm         enc-key-sync                               Community Operators   55m
# olm         limitador-operator                         Community Operators   55m
# olm         ack-route53resolver-controller             Community Operators   55m
# olm         trident-operator                           Community Operators   55m
# olm         function-mesh                              Community Operators   55m
# olm         routernetes-operator                       Community Operators   55m
# olm         otc-rds-operator                           Community Operators   55m
# olm         deployment-validation-operator             Community Operators   55m
# olm         chaosblade-operator                        Community Operators   55m
# olm         awss3-operator-registry                    Community Operators   55m
# olm         yugabyte-operator                          Community Operators   55m
# olm         akka-cluster-operator                      Community Operators   55m
# olm         ibmcloud-iam-operator                      Community Operators   55m
# olm         sematext                                   Community Operators   55m
# olm         security-profiles-operator                 Community Operators   55m
# olm         ack-rds-controller                         Community Operators   55m
# olm         oneagent                                   Community Operators   55m
# olm         rabbitmq-single-active-consumer-operator   Community Operators   55m
# olm         ack-mq-controller                          Community Operators   55m
# olm         federatorai                                Community Operators   55m
# olm         aqua                                       Community Operators   55m
# olm         victoriametrics-operator                   Community Operators   55m
# olm         ext-postgres-operator                      Community Operators   55m
# olm         ibm-quantum-operator                       Community Operators   55m
# olm         spark-gcp                                  Community Operators   55m
# olm         nri-plugins-operator                       Community Operators   55m
# olm         ibm-security-verify-access-operator        Community Operators   55m
# olm         noobaa-operator                            Community Operators   55m
# olm         pmem-csi-operator                          Community Operators   55m
# olm         rabbitmq-cluster-operator                  Community Operators   55m
# olm         mcad-operator                              Community Operators   55m
# olm         ack-secretsmanager-controller              Community Operators   55m
# olm         splunk                                     Community Operators   55m
# olm         cluster-manager                            Community Operators   55m
# olm         universal-crossplane                       Community Operators   55m
# olm         kernel-module-management                   Community Operators   55m
# olm         kubestone                                  Community Operators   55m
# olm         project-quay                               Community Operators   55m
# olm         windup-operator                            Community Operators   55m
# olm         vault-helm                                 Community Operators   55m
# olm         ack-opensearchservice-controller           Community Operators   55m
# olm         sosivio                                    Community Operators   55m
# olm         intel-ethernet-operator                    Community Operators   55m
# olm         ditto-operator                             Community Operators   55m
# olm         ripsaw                                     Community Operators   55m
# olm         enmasse                                    Community Operators   55m
# olm         zookeeper-operator                         Community Operators   55m
# olm         ibm-security-verify-directory-operator     Community Operators   55m
# olm         litmuschaos                                Community Operators   55m
# olm         metallb-operator                           Community Operators   55m
# olm         azure-service-operator                     Community Operators   55m
# olm         keydb-operator                             Community Operators   55m
# olm         ack-cloudfront-controller                  Community Operators   55m
# olm         ack-networkfirewall-controller             Community Operators   55m
# olm         skydive-operator                           Community Operators   55m
# olm         appranix                                   Community Operators   55m
# olm         mariadb-operator-app                       Community Operators   55m
# olm         ack-kms-controller                         Community Operators   55m
# olm         esindex-operator                           Community Operators   55m
# olm         synapse-operator                           Community Operators   55m
# olm         api-testing-operator                       Community Operators   55m
# olm         submariner                                 Community Operators   55m
# olm         logging-operator                           Community Operators   55m
# olm         storageos                                  Community Operators   55m
# olm         patterns-operator                          Community Operators   55m
# olm         konveyor-operator                          Community Operators   55m
# olm         postgresql                                 Community Operators   55m
# olm         github-arc-operator                        Community Operators   55m
# olm         ack-elasticache-controller                 Community Operators   55m
# olm         ack-ecr-controller                         Community Operators   55m
# olm         starboard-operator                         Community Operators   55m
# olm         rabbitmq-messaging-topology-operator       Community Operators   55m
# olm         ndmspc-operator                            Community Operators   55m
# olm         ack-cloudwatchlogs-controller              Community Operators   55m
# olm         kaoto-operator                             Community Operators   55m
# olm         ibm-spectrum-scale-csi-operator            Community Operators   55m
# olm         registry-operator                          Community Operators   55m
# olm         ack-iam-controller                         Community Operators   55m
# olm         datatrucker-operator                       Community Operators   55m
# olm         knative-operator                           Community Operators   55m
# olm         istio-workspace-operator                   Community Operators   55m
# olm         eventing-kogito                            Community Operators   55m
# olm         community-kubevirt-hyperconverged          Community Operators   55m
# olm         opentelemetry-operator                     Community Operators   55m
# olm         kubeturbo                                  Community Operators   55m
# olm         ack-memorydb-controller                    Community Operators   55m
# olm         nuxeo-operator                             Community Operators   55m
# olm         druid-operator                             Community Operators   55m
# olm         robin-operator                             Community Operators   55m
# olm         event-streams-topic                        Community Operators   55m
# olm         ack-kafka-controller                       Community Operators   55m
# olm         ack-sfn-controller                         Community Operators   55m
# olm         ack-acmpca-controller                      Community Operators   55m
# olm         hpe-ezmeral-csi-operator                   Community Operators   55m
# olm         kepler-operator                            Community Operators   55m
# olm         dell-csm-operator                          Community Operators   55m
# olm         pystol                                     Community Operators   55m
# olm         postgres-operator-krestomatio              Community Operators   55m
# olm         credstash-operator                         Community Operators   55m
# olm         radanalytics-spark                         Community Operators   55m
# olm         varnish-operator                           Community Operators   55m
# olm         pixie-operator                             Community Operators   55m
# olm         postgresql-operator-dev4devs-com           Community Operators   55m
# olm         topolvm-operator                           Community Operators   55m
# olm         apimatic-kubernetes-operator               Community Operators   55m
# olm         nsm-operator-registry                      Community Operators   55m
# olm         loki-operator                              Community Operators   55m
# olm         prometheus                                 Community Operators   55m
# olm         kube-green                                 Community Operators   55m
# olm         silicom-sts-operator                       Community Operators   55m
# olm         sap-btp-operator                           Community Operators   55m
# olm         mercury-operator                           Community Operators   55m
# olm         lbconfig-operator                          Community Operators   55m
# olm         kogito-operator                            Community Operators   55m
# olm         keda                                       Community Operators   55m
# olm         kubernetes-nmstate-operator                Community Operators   55m
# olm         hpa-operator                               Community Operators   55m
# olm         cassandra-operator                         Community Operators   55m
# olm         openshift-qiskit-operator                  Community Operators   55m
# olm         iot-simulator                              Community Operators   55m
# olm         marin3r                                    Community Operators   55m
# olm         application-services-metering-operator     Community Operators   55m
# olm         nfs-operator                               Community Operators   55m
# olm         sigstore-helm-operator                     Community Operators   55m
# olm         authorino-operator                         Community Operators   55m
# olm         galaxy-operator                            Community Operators   55m
# olm         percona-server-mongodb-operator            Community Operators   55m
# olm         kubemq-operator                            Community Operators   55m
# olm         aiven-operator                             Community Operators   55m
# olm         kubensync                                  Community Operators   55m
# olm         eginnovations-operator                     Community Operators   55m
# olm         pulsar-resources-operator                  Community Operators   55m
# olm         bookkeeper-operator                        Community Operators   55m
# olm         parodos-operator                           Community Operators   55m
# olm         ack-eventbridge-controller                 Community Operators   55m
# olm         ack-ecs-controller                         Community Operators   55m
# olm         cert-manager                               Community Operators   55m
# olm         postgres-operator                          Community Operators   55m
# olm         instana-agent-operator                     Community Operators   55m
# olm         steerd-presto-operator                     Community Operators   55m
# olm         hawkbit-operator                           Community Operators   55m
# olm         ack-ec2-controller                         Community Operators   55m
# olm         dell-csi-operator                          Community Operators   55m
# olm         falco                                      Community Operators   55m
# olm         wavefront                                  Community Operators   55m
# olm         gingersnap                                 Community Operators   55m
# olm         apicast-community-operator                 Community Operators   55m
# olm         ack-apigatewayv2-controller                Community Operators   55m
# olm         planetscale                                Community Operators   55m
# olm         kuadrant-operator                          Community Operators   55m
# olm         aws-auth-operator                          Community Operators   55m
# olm         ack-cloudtrail-controller                  Community Operators   55m
# olm         pinot-operator                             Community Operators   55m
# olm         node-healthcheck-operator                  Community Operators   55m
# olm         cockroachdb                                Community Operators   55m
# olm         flink-kubernetes-operator                  Community Operators   55m
# olm         keycloak-operator                          Community Operators   55m
# olm         pulp-operator                              Community Operators   55m
# olm         ovms-operator                              Community Operators   55m
# olm         clever-operator                            Community Operators   55m
# olm         cluster-aas-operator                       Community Operators   55m
# olm         prometurbo                                 Community Operators   55m
# olm         external-secrets-operator                  Community Operators   55m
# olm         ack-prometheusservice-controller           Community Operators   55m
# olm         ack-pipes-controller                       Community Operators   55m
# olm         temporal-operator                          Community Operators   55m
# olm         kong-gateway-operator                      Community Operators   55m
# olm         kube-loxilb-operator                       Community Operators   55m
# olm         integration-operator                       Community Operators   55m
# olm         pcc-operator                               Community Operators   55m
# olm         jenkins-operator                           Community Operators   55m
# olm         move2kube-operator                         Community Operators   55m
# olm         clickhouse                                 Community Operators   55m
# olm         integrity-shield-operator                  Community Operators   55m
# olm         ack-emrcontainers-controller               Community Operators   55m
# olm         kubefed-operator                           Community Operators   55m
# olm         ack-sns-controller                         Community Operators   55m
# olm         project-quay-container-security-operator   Community Operators   55m
# olm         kubemod                                    Community Operators   55m
# olm         mongodb-operator                           Community Operators   55m
# olm         intel-device-plugins-operator              Community Operators   55m
# olm         pulsar-operator                            Community Operators   55m
# olm         redis-enterprise                           Community Operators   55m
# olm         sap-hana-express-operator                  Community Operators   55m
# olm         shipwright-operator                        Community Operators   55m
# olm         trivy-operator                             Community Operators   55m
# olm         tf-operator                                Community Operators   55m
# olm         ack-sqs-controller                         Community Operators   55m
# olm         fossul-operator                            Community Operators   55m

# $
