variable "create_vpc" {
  type        = bool
  description = "If true, create a dedicated VPC and public subnets. If false, use the default VPC or an existing VPC."
  default     = false
}

variable "vpc_id" {
  type        = string
  description = "Existing VPC ID to use when create_vpc is false. Leave empty to use the account default VPC."
  default     = ""
}

variable "subnet_ids" {
  type        = list(string)
  description = "At least two public subnet IDs in the chosen VPC. Leave empty to auto-discover subnets with map-public-ip-on-launch=true."
  default     = []
}

locals {
  resolved_vpc_id = var.create_vpc ? aws_vpc.main[0].id : (
    var.vpc_id != "" ? var.vpc_id : data.aws_vpc.default[0].id
  )

  need_discover_subnets = !var.create_vpc && length(var.subnet_ids) < 2

  discovered_subnet_ids = local.need_discover_subnets ? slice(
    sort(data.aws_subnets.public[0].ids),
    0,
    min(2, length(data.aws_subnets.public[0].ids))
  ) : []

  public_subnet_ids = var.create_vpc ? aws_subnet.public[*].id : (
    length(var.subnet_ids) >= 2 ? var.subnet_ids : local.discovered_subnet_ids
  )
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "default" {
  count   = var.create_vpc || var.vpc_id != "" ? 0 : 1
  default = true
}

data "aws_subnets" "public" {
  count = local.need_discover_subnets ? 1 : 0

  filter {
    name   = "vpc-id"
    values = [local.resolved_vpc_id]
  }

  filter {
    name   = "map-public-ip-on-launch"
    values = ["true"]
  }
}

resource "aws_vpc" "main" {
  count      = var.create_vpc ? 1 : 0
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  count = var.create_vpc ? 2 : 0

  vpc_id                  = aws_vpc.main[0].id
  cidr_block              = cidrsubnet("10.0.0.0/16", 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  count  = var.create_vpc ? 1 : 0
  vpc_id = aws_vpc.main[0].id
}

resource "aws_route_table" "rt" {
  count  = var.create_vpc ? 1 : 0
  vpc_id = aws_vpc.main[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[0].id
  }
}

resource "aws_route_table_association" "a" {
  count          = var.create_vpc ? 2 : 0
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.rt[0].id
}

output "vpc_id" {
  value = local.resolved_vpc_id
}

output "public_subnet_ids" {
  value = local.public_subnet_ids
}
