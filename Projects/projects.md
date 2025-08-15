### Cloud SQL
* Create a cloudsql instance based on the customer requirement 
* We should be having a mechanism where based on the custom requirement the cloudsql should have HA .
* Include a code to have read replicas if customer needs it. 
* ex: dev instance.... no need of HA, stage instance automatically ha should be enabled
* the configurations of the vm, (ex: name, cpus, memory, these should be coming from map)
* create a db , dbuser and include those details in senstive
* make the instance to have public ip with autorised n/w and that authorised networj should be coming from local values 



### Instance template
* Create a instance template with a startup script 
* Create a vm from that instance template in us-central1-a zone
* Create a instance template with a startup script 
* Create a instance group with the above instance template in us-central1 region with 3 vm's spread across 3 zones
* Create a instance template with a startup script 
* Create a instance group with the above instance template in us-central1 minimum 1 vm and configure autoscaling to scale instance based on the load 

### Cloud instance with private ip
* Create a vm with no public ip 
* enable iap and open the respective firewalls and ssh should be enabled 
* enable a way to reach internet and download packages
    * create a nat resource and enable it to the above vm 

### IAM
* creaet a custom role with maybe compute instance admin and storage admin persmissions
* Create a service account 
* assign the above role created to the service account
    * the project id should be dynamic 

### DNS
* create a tf code to configure dns in public zone and the dns name should be coming from the tfvars file
* get the ns records as output

### firewalls
* [refer](https://github.com/devopswithcloud/GoogleCloudPlatform/blob/master/V2/VPC/2-Firewalls_AllInstances_Instancetag.md) this example and convert the same into terraform code






