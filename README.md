Good day enigneer, please note, I find it 

As a DevOps Engineer I am running this stack for Previse organization. This will be done using Terraform in the eu-west-2 (Ohio)region. Looking at the downtime it experience during the weekend, I decided within myself that for it to be highly available, I will deploy it on a 3-Tier Network VPC whereby it will be deployed in two different regions with a public and two private subnets in each region.

Created Public Route Table: I created a Public Route table which is associated to the public subnets, and then add 
public route to it which will route traffic to the internet through the internet gateway.
Create NAT GATEWAY: Created Nat Gateway in the Public Subnet AZ1 and Public Subnet AZ2, afterwards created 
Private Route Table AZ1 and Private Route Table AZ2. Add route to each of the route table so as to route traffic to 
the internet through each of the Nat Gateways and then associate the Route Table to Private Subnets in each 
availability zone.

For best practice, I would advice the file/webfiles ae uploaded into an S3 bucket, this would protect the file as any memeber of the team that doesn't have the S3FullAccessPermission won't be able to access it, this would mean that the webfiles are safe and won't be altered in anyway and if any of such happened we know those to hold accountable. I did not introduce this because i felt the user-data has been attached to the ec2 instance but i believe it is something we can correct in the future.

To avoid donwtime of any of our website, i am introducing the use of auto-scaling group in the deployment. This is why i have Application Load Balancer created in the public subnet so as to ensure effectiveness and balance of traffic across multiple instances. 

Creating an Application Load Balancer: Since I will be using an EC2 instances to host the website, it is to note that 
Application Load Balancer would help distribute the web traffic across EC2 instances in multiple Availability Zones. I would launch EC2 instance in both availability zone. Haven launch the EC2 instance in both availability zone, I would go ahead to create a TARGET GROUP. The function of this Target group is to have the EC2 Instances in both AZs and allow the Application Load Balancer to route traffic to them. Once that has been created, I would then proceed to 
creating the Application Load Balancer with IP Address type of IPV4, with the mapping being in any of the Public 
Subnets created. Attached my created Application Load Balancer Security Groups. Set up a listener of port 80 (HTTP) and then create the Application Load Balancer.The load balancer will make this website highly available and also fault tolerance.

Creating an Auto-Scaling Group: Not only do we need the auto scaling group for high availability, it can also serve purpose of Cost Consideration and optimization, I would create an Auto Scaling Group which would help to automatically adjust the number of instances needed in response to changes in demand for the website, thereby providing scalability, high availability and monitor health checks of all instances, in the event that any Instance fails health check or become unavailable, Auto Scaling Group would terminate it and automatically launches a new one so as to maintain the desired capacity.

