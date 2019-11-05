# ReplicaSets - StatefulSets - DaemonSets
## 
As you’ve seen, a ReplicaSet creates and manages Pods. If a Pod shuts down because a Node fails, a ReplicaSet can automatically replace the Pod on another Node. You should generally create a ReplicaSet through a Deployment rather than creating it directly, because it’s easier to update your app with a Deployment.
