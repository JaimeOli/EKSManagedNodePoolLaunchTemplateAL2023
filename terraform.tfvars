aws_region = "us-west-2"
cluster_name = "ClusterChingon"
custom_ami_id = "ami-001d3033025518f3f"
node_group_name = "MNGChingon2"
vpc_id = "vpc-054807b9655e3a45e"
subnet_ids = ["subnet-096232bddd945d1fa", "subnet-00f05f72b7e91c6a2", "subnet-0365c2f85c41393c3","subnet-0c8ed0a2ca8d8d6da"]
instance_type = "t4g.medium"  # You can change this to your desired instance type
disk_size = 20
desired_size = 2
max_size = 4
min_size = 1
# cluster_service_cidr = "172.20.0.0/16"  # Uncomment and set this if you need to override
