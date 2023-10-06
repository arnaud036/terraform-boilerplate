
output "vpc_id" {
    value = aws_vpc.aws_vpc.id
    description = "ID for the primary VPC"
}

output "private_subnet_ids" {
    value = aws_subnet.private.*.id
    description = "object containing all the private subnet ID's based on the array inputted"
}

output "public_subnet_ids" {
    value = aws_subnet.public.*.id
    description = "object containing all the public subnet ID's based on the array inputted"
}