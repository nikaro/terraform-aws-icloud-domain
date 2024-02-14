variable "zone" {
  description = "Zone where to publish records."
  type = object({
    id   = string
    name = string
  })
}

variable "mx_enabled" {
  description = "Enable MX records."
  type        = bool
  default     = true
}

variable "mx_priority" {
  description = "MX records priority."
  type        = number
  default     = 10
}

variable "spf_enabled" {
  description = "Enable SPF records."
  type        = bool
  default     = true
}

variable "spf_includes" {
  description = "SPF includes."
  type        = list(string)
  default     = ["icloud.com"]
}

variable "spf_policy" {
  description = "SPF policy."
  type        = string
  default     = "~all"
  validation {
    condition     = contains(["~all", "-all", "?all"], var.spf_policy)
    error_message = "value must be one of: ~all, -all, ?all"
  }
}

variable "dkim_enabled" {
  description = "Enable DKIM records."
  type        = bool
  default     = true
}

variable "dmarc_enabled" {
  description = "Enable DMARC records."
  type        = bool
  default     = true
}

variable "dmarc_policy" {
  description = "DMARC policy."
  type        = string
  default     = "reject"
  validation {
    condition     = contains(["none", "quarantine", "reject"], var.dmarc_policy)
    error_message = "value must be one of: none, quarantine, reject"
  }
}

variable "autodiscover_enabled" {
  description = "Enable autodiscover records."
  type        = bool
  default     = true
}

variable "domain_verif_data" {
  description = "Domain verification data."
  type        = string
}

variable "ttl" {
  description = "TTL for records."
  type        = number
  default     = 3600
}
