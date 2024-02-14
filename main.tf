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
  count   = var.mx_enabled ? 1 : 0
  zone_id = var.zone_id
  name    = var.zone_name
  type    = "MX"
  ttl     = var.ttl
  records = [
    "${var.mx_priority} mx01.mail.icloud.com.",
    "${var.mx_priority} mx02.mail.icloud.com.",
  ]
}

resource "aws_route53_record" "spf" {
  count   = var.spf_enabled ? 1 : 0
  zone_id = var.zone_id
  name    = var.zone_name
  type    = "TXT"
  ttl     = var.ttl
  records = [
    "v=spf1 ${join(" ", [for i in var.spf_includes : "include:${i}"])} ${var.spf_policy}",
  ]
}

resource "aws_route53_record" "dkim" {
  count   = var.dkim_enabled ? 1 : 0
  zone_id = var.zone_id
  name    = "sig1._domainkey.${var.zone_name}"
  type    = "CNAME"
  ttl     = var.ttl
  records = [
    "sig1.dkim.${var.zone_name}.at.icloudmailadmin.com.",
  ]
}

resource "aws_route53_record" "dmarc" {
  count   = var.dmarc_enabled ? 1 : 0
  zone_id = var.zone_id
  name    = "_dmarc.${var.zone_name}"
  type    = "TXT"
  ttl     = var.ttl
  records = [
    "v=DMARC1; p=${var.dmarc_policy};",
  ]
}

resource "aws_route53_record" "srv_submission" {
  count   = var.autodiscover_enabled ? 1 : 0
  zone_id = var.zone_id
  name    = "_submission._tcp.${var.zone_name}"
  type    = "SRV"
  ttl     = var.ttl
  records = [
    "0 1 587 smtp.mail.me.com.",
  ]
}

resource "aws_route53_record" "srv_imaps" {
  count   = var.autodiscover_enabled ? 1 : 0
  zone_id = var.zone_id
  name    = "_imaps._tcp.${var.zone_name}"
  type    = "SRV"
  ttl     = var.ttl
  records = [
    "0 1 993 imap.mail.me.com.",
  ]
}

resource "aws_route53_record" "domain_verif_data" {
  zone_id = var.zone_id
  name    = var.zone_name
  type    = "TXT"
  ttl     = var.ttl
  records = [
    "apple-domain=${var.domain_verif_data}",
  ]
}
