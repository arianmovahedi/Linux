# Interacting with Argo CD
Along side the UI Argo CD comes with a RESTful API and a CLI tool.

An application in Argo CD is a source of GitOps content that targets a particular destination environment and is the primary focus for end users using Argo CD. 

The following are the values in the setting of the UI panel:
|Settings|Description|
|:---:|:---:|
|Repositories|Configuration of remote locations containing resources that will be translated into Kubernetes manifests|
|Certificates|Management of transport mechanisms to facilitate secure connectivity to remote repositories|
|GnuPG Keys|Key management to enable the verfication of source control content|
|Clusters|Kubernetes environments that have content from source repositories applied|
|Projects|Logical groupings of applications with common configurations and permissions|
|Accounts|Management of local accountes stored within Argo CD server|
|Appearance|Configuration of look and feel of the UI|

Even with all the parameters and settings that can be configured within the Argo CD UI, there are still a large number of properties that either cannot be managed using the UI or their values are read-only.