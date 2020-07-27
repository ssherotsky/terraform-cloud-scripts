# Citrix ADC 3 Network Interface with ADM Agent deployment

Some changes from the master citrix/terraform-cloud-scripts repo include:
+ Consolidation of variables into single file, variables.tf
+ Added automatic SSH key generation as default. Read comments in ssh_key.tf and variables.tf to use custom keys
+ An ADM Agent sharing management subnet with the ADC.

For everyone's benefit, make sure to change the se_name value in variables.tf to your initials

 My goal with these changes is to be able to quickly deploy a simple environemnt that
 can be managed and licensed thropgh ADM Service for testing and easily removed to clean
 up for other SEs and prevent unecessary AWS costs.

 As a result of the notes above, some of the information below is out of date.

This folder contains the configuration scripts to deploy
* A VPC with 3 subnets and associated security groups and routing tables.
* A single Citrix ADC instance with 3 NICs.
* An SSH keypair to manage ssh access to the Citrix ADC instance.

## VPC configuration

The VPC is configured to have a single subnet which is then
divided into three blocks for use in each of the Citrix ADC NICs.

The configuration for the VPC and networking components
is contained in the following files

* `networking.tf`: configuration for all networking components.
* `networking_variables.tf`: definition of the input variables needed to configure the networking setup.
* `networking_outputs.tf`: definition of output variables related to the networking configuration.


## Citrix ADC confguration

The Citrix ADC instance is deployed as a single instance with 3 separate
NICs each in a separate subnet with its own security groups.

The management NIC/subnet is used for assigning the NSIP to the instance and to
have ssh access from the controlling subnet. Ideally the allowed source subnet
should be as narrow as possible to avoid having unauthorized access.

The client NIC/subnet is used for public access to the load balancing configuration
of the Citrix ADC instance. It is meant to load balance the backend services.
Users of services should be allowed access to this subnet.
In general this could be the entire public internet or a whole corporate intranet.

The server NIC/subnet is used to communicate with the backend services.
This subnet is restricted from public access. Backend services should be added
to this network and be accessible to Citrix ADC through its SNIP.

The configuration files used are the following

* `citrix_adc.tf`: Citrix ADC instance configuration.
* `citrix_adc_variables.tf`: Input variables for Citrix ADC cofnfiguration
* `citrix_adc_outputs.tf`: Output variables for Citrix ADC.


## SSH keypair

The ssh keypair with which to manage the Citrix ADC instance.

If you already have one key you may omit this part of the configuration or
use `terraform import` to import an existing key.

The following files are used

* `ssh_key.tf`: Definition of the ssh keypair
* `ssh_key_variables.tf`: Input variables for ssh keypair
* `ssh_key_outputs.tf`: Output variables for ssh keypair

## Provider configuration

The AWS provider is the one used for all configuration.

The following files are related to the provider configuration

* `provider.tf`: AWS provider configuration.
* `provider_variables.tf`: Input variables for the AWS provider.

## Licensing

There is a choice of licensing options for the provisioned Citrix ADC.

You can copy a subdirectory's files from the `licensing` directory to
apply a license mode.

The available licensing modes are `CICO`, `Pooled` and `vCPU`.

For more info on Citrix ADC licensing see this [link](https://docs.citrix.com/en-us/citrix-adc/13/licensing.html).

All of these require the Citrix ADC to be able to communicate with a Citrix ADM
which will act as the license server.
