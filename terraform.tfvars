///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                   Enviroment Veriables                                       //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////


observability_server     = "server_name"                                                   #Provide the Name for you Monitoring server.
environment_name         = "Prod-env"                                                      # Provide the Enviroment Name.
ami                      = "ami-01d21b7be69801c2f"                                         # Copy the Latest ubuntu AMI id and past it.
region                   = "eu-west-3"                                                     # Define the region.                                                    
key_pair_name            = "test"                                                          # Create New or Add existing key pair name here.                                                   
instance_type            = "t2.micro"                                                      # Defin the instance Type.
private_subnet_id_A      = "subnet-0f4692f696d5bc515"                                      # Defin the Private Subnet.
public_subnit_id_A       = "subnet-0668d977de5367751"                                      # Defin the Public Subnet.
public_subnit_id_B       = "subnet-026bbc46ab5b08b0e"                                      # Defin the Public Subnet.
public_subnit_id_C       = "subnet-08e7c7a8bb8c5054f"                                      # Defin the Public Subnet.
vpc_id                   = "vpc-0ac433fa2c6667904"                                         # Defin the VPC Id.
vpc_cidr                 = "172.31.0.0/16"                                                 # Defin the VPC CIDR Range.
