# Terraform demo

A very simple Exoscale terraform demo, deploying a Nodepool with a Network Load Balancer. The Nodepool serves a website with the name of a customer.

# Quickstart

1. Download Terraform: https://www.terraform.io/downloads
2. Generate an Exoscale API-Key
    * IAM -> Add Key -> Insert any name (e.g. your name) -> Restricted -> Compute
    * Put the Key and secret in the file "cloudstack.ini"
    * Never share the key with anyone. If accidently shared, delete and recreate the key
4. `terraform.exe init` (only needed the first time using it)
3. `terraform.exe apply -var='customer=meinkunde'`
4. Wait until all resources are created (as seen in the UI)
5. Wait until app is ready (1 minute)
6. You can access the demo wegpage by opening up one of the IPs of the VMs of the nodepool in your Browser, or opening up the IP of the Network Load Balancer.
7. After you are finished, destroy using: `terraform.exe destroy`

On default, just a demo with a Network Load Balancer and a Webapplication is deployed.
You can also deploy an empty SKS cluster and database by renaming the .disabled files (e.g. `exoscale-sks.tf.disabled` to `exoscale-sks.tf`)

You can change the website in `scripts/webserver.yaml`

## Caveats

If multiple people use the demo at the same time, the names of the resources could conflict. Consider just chaning all the **name** keys in the .tf file.

Sometimes a security group could fail to destroy (as said by the console). Simply delete it manually in the Exoscale UI and redo `terraform destroy`

Note that the API can change, so test it before demos.

## Disclaimer

This script example is provided as-is and can be modified freely. Refer to [Exoscale SKS SLA](https://community.exoscale.com/documentation/sks/overview/#service-level-and-support) to understand the limits of Exoscale Support. If you find a bug or have a suggestion/improvement to make
we welcome issues or PR in this repository but take no commitment in integrating/resolving these.