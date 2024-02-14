resource "aws_route53_zone" "example_net" {
  name = "example.net"
}

module "icloud_example_net" {
  source            = "./modules/terraform-aws-icloud-domain"
  zone              = aws_route53_zone.example_net
  domain_verif_data = "xxxxxxxxxxxxxxxx"
}
