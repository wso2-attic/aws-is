# AWS Resources for WSO2 Identity Server

This repository contains CloudFormation templates to deploy WSO2 Identity Server with different patterns in Amazon Web Services(AWS).

Available patterns are [scalable-is](https://github.com/wso2/aws-is/tree/master/scalable-is) and [is-with-analytics](https://github.com/wso2/aws-is/tree/master/is-with-analytics).

Each product pattern points to three previously created Amazon Machine Images (AMI).
1. Puppetmaster AMI - Consists the product packs(GA), WUM client, puppet modules, and the necessary configurations for each deployment pattern.

2. IS AMI - Includes the deployment pattern specific IS resources.

3. IS-Analytics AMI - Includes the deployment pattern specific IS Analytics resources.

First the Puppetmaster AMI would deploy and afterwards the product specific AMIs would deploy and request the necessary configurations from the Puppetmaster AMI to deploy the WSO2 Identity Server.

## Scalable IS

![pattern1](images/is-pattern1.png)

## Identity Server Configured with Analytics

![pattern2](images/is-pattern2.png)
