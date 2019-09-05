## Part 1: The picture of the stuff
1 applications per server
Linux just didn’t have the technologies to safely and securely run multiple applications on the same server.

Every time the business needed a new application, IT would go out and buy a new server

=> Hello VMware!

=> Hello Containers!

=> Linux containers

Docker, Inc. made containers simple!

Windows containers: This way developers and sysadmins familiar with the Docker toolset from the Linux platform will feel at home using 

Windows containers.

Windows containers vs Linux containers

What about Kubernetes

Kubernetes is an open-source project out of Google that has quickly emerged as the leading orchestrator of containerized apps
Kubernetes uses Docker as its default container runtime the piece of Kubernetes that starts and stops containers, as well as pulls images etc. 

Kubernetes uses Docker as its default container runtime the piece of Kubernetes that starts and stops containers, as well as pulls images etc. However, Kubernetes has a pluggable container runtime interface called the CRI. This makes it easy to swap-out Docker for a different container runtime.

The important thing to know about Kubernetes, at this stage, is that it’s a higher-level platform than Docker,

2: Docker


