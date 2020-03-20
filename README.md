# AWS Resources for WSO2 Identity Server

This repository contains CloudFormation templates to deploy WSO2 Identity Server with different patterns in Amazon Web Services(AWS).

Available patterns are [scalable-is](https://github.com/wso2/aws-is/tree/master/scalable-is).

The WSO2 IS CloudFormation templates use Puppet to manage the server configurations and use the following AMI's to provision the deployment.

1. Puppetmaster AMI - Contains the Identity Server GA distribution, WSO2 Update Manager and Puppet modules containing the configurations for IS deployment patterns.

2. IS AMI - Contains the scripts that is required to create the Puppet catalog.

First the Puppetmaster AMI would deploy and afterwards the product specific AMI's would deploy and request the necessary configurations from the Puppetmaster AMI to deploy the WSO2 Identity Server.

## Scalable IS

![pattern1](images/is-pattern1.png)

## Identity Server Samples

- Setting up sample application for SAML SSO authentication
    - travelocity.com
    - PassiveSTSSampleApp
