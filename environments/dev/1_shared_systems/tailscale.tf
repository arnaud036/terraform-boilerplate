module "dev_tailscale" {
  source = "../../../modules/companyxyz-aws-fargate"

  prefix = "dev-tailscale"

  docker_image = "tailscale/tailscale"
  docker_tag = "v1.36.1"
  
  aws_region = "us-west-2"
  vpc_id = "vpc-01ca872928f14da0b"
  subnet_ids = ["subnet-0bcdefc9da30b3b86", "subnet-0f136513cf2ac4478"] # private subnets

  container_port = 8080
  container_cpu = 512
  container_memory = 1024

  container_environment = [
    { name = "TS_ROUTES", value = "10.0.0.0/16" },
    { name = "TS_AUTH_KEY", value = "tskey-auth-****" },
    { name = "TS_USERSPACE", value = "true" },
  ]
}