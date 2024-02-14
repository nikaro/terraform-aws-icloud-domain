terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

resource "aws_route53_record" "mx" {
  zone_id = var.zone.id
  name    = var.zone.name
  type    = "MX"
  ttl     = var.ttl
  records = [
    "${var.mx_priority} mx01.mail.icloud.com.",
    "${var.mx_priority} mx02.mail.icloud.com.",
  ]
}

resource "aws_route53_record" "txt_apex" {
  zone_id = var.zone.id
  name    = var.zone.name
  type    = "TXT"
  ttl     = var.ttl
  records = [
    "v=spf1 ${join(" ", [for i in var.spf_includes : "include:${i}"])} ${var.spf_policy}",
    "apple-domain=${var.domain_verif_data}",
  ]
}

resource "aws_route53_record" "dkim" {
  zone_id = var.zone.id
  name    = "sig1._domainkey.${var.zone.name}"
  type    = "CNAME"
  ttl     = var.ttl
  records = [
    "sig1.dkim.${var.zone.name}.at.icloudmailadmin.com.",
  ]
}

resource "aws_route53_record" "dmarc" {
  zone_id = var.zone.id
  name    = "_dmarc.${var.zone.name}"
  type    = "TXT"
  ttl     = var.ttl
  records = [
    "v=DMARC1; p=${var.dmarc_policy};",
  ]
}

resource "aws_route53_record" "srv_submission" {
  zone_id = var.zone.id
  name    = "_submission._tcp.${var.zone.name}"
  type    = "SRV"
  ttl     = var.ttl
  records = [
    "0 1 587 smtp.mail.me.com.",
  ]
}

resource "aws_route53_record" "srv_imaps" {
  zone_id = var.zone.id
  name    = "_imaps._tcp.${var.zone.name}"
  type    = "SRV"
  ttl     = var.ttl
  records = [
    "0 1 993 imap.mail.me.com.",
  ]
}
