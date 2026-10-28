


* map_public_ip_on_launch = true (Subnet level)

   Any EC2 launched in this subnet gets a public IP automatically.

* associate_public_ip_address = true (EC2 level)

  This specific EC2 instance gets a public IP.

Easy way to remember:

map_public_ip_on_launch  -> Default setting for the subnet
associate_public_ip_address -> Setting for a specific EC2

---


Flow:

User Request
     |
     v
IGW
     |
     v
ALB Security Group  ← 1st check
     |
     v
ALB
     |
     v
EC2 Security Group  ← 2nd check
     |
     v
EC2 Instance

Example

ALB SG
Inbound:
80 -> 0.0.0.0/0


EC2 SG
Inbound:
80 -> ALB-SG


When a user browses:

http://my-alb.amazonaws.com

Request reaches the ALB.
ALB SG checks whether port 80 is allowed.
If allowed, ALB accepts the request.
ALB forwards the request to EC2.
EC2 SG checks whether traffic from ALB-SG is allowed.
If allowed, request reaches EC2.

 ✅ First: ALB Security Group
 ✅ Second: EC2 Security Group
 ✅ Route table and IGW are not security layers; they only route traffic.
