#### ⚠️ DISCLAIMER

Use these artefacts as a reference to build your deployment artefacts. Existing artefacts only developed to demonstrate a reference deployment and should not be used as is in production

------------------------------------------------------------------

# AWS Resources for WSO2 Identity Server

 The following sections guide you through setting up the deployment pattern, which is a High Available (HA) Clustered Deployment, for two WSO2 Identity Server nodes on AWS using CloudFormation scripts.

  ![pattern1](images/is-pattern1.png)

## Steps to deploy

The deployment is of three phases. All phases can either run individually or can be combined via a [nested CloudFormation script](Minimum-HA/nested-identity.yaml). Follow the provided guides to deploy each phase.

  - Phase 1: [Network setup](network/README.md)
  - Phase 2: [Database setup](database/README.md)
  - Phase 3: [Product deployment](product/README.md)
