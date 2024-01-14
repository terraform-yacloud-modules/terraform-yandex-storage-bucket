locals {
  cm_certificate_name = try(var.https.certificate.name_prefix != null, false) ? "${var.https.certificate.name_prefix}-${random_string.unique_id.result}" : "s3-https-certificate-${random_string.unique_id.result}"
}

resource "yandex_cm_certificate" "this" {
  count               = try(var.https.certificate != null, false) ? 1 : 0
  name                = coalesce(var.https.certificate.name, local.cm_certificate_name)
  description         = var.https.certificate.description
  labels              = var.https.certificate.labels
  domains             = var.https.certificate.domains
  deletion_protection = var.https.certificate.deletion_protection
  folder_id           = local.folder_id

  managed {
    challenge_type = "DNS_CNAME"

    # Remove wildcard domains from challenge count ("example.com" and "*.example.com" has the same DNS_CNAME challenge).
    # First, we check each domain in the list of domains. If the domain has a *. prefix, replace it with the name without the prefix.
    # Example: ["example.com", "*.example.com"] becomes ["example.com", "example.com"]
    # Then remove duplicates in the list.
    # Example: ["example.com", "example.com"] becomes ["example.com"]
    # Finally, count the number of elements in the list.
    challenge_count = length(distinct([for domain in var.https.certificate.domains : replace(domain, "/^(\\*\\.)(.*)$/", "$2")]))
  }
}

resource "yandex_dns_recordset" "this" {
  count   = try(var.https.certificate != null, false) ? yandex_cm_certificate.this[0].managed[0].challenge_count : 0
  zone_id = var.https.certificate.public_dns_zone_id
  name    = yandex_cm_certificate.this[0].challenges[count.index].dns_name
  type    = yandex_cm_certificate.this[0].challenges[count.index].dns_type
  data    = [yandex_cm_certificate.this[0].challenges[count.index].dns_value]
  ttl     = var.https.certificate.dns_records_ttl
}
