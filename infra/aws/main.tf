data "aws_caller_identity" "current" {}

data "tls_certificate" "azure" {
  url = "https://sts.windows.net/${var.azure_tenant_id}/.well-known/openid-configuration"
}

locals {
  application_id_url = "api://${var.name}"
}

resource "aws_iam_openid_connect_provider" "main" {
  url = "https://sts.windows.net/${var.azure_tenant_id}/"

  client_id_list = [
    local.application_id_url
  ]

  thumbprint_list = [
    data.tls_certificate.azure.certificates[0].sha1_fingerprint
  ]
}

resource "aws_iam_role" "for_azure" {
  name = "for-azure"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        "Principal" : {
          "Federated" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/sts.windows.net/${var.azure_tenant_id}/"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "sts.windows.net/${var.azure_tenant_id}/:aud" : local.application_id_url,
            "sts.windows.net/${var.azure_tenant_id}/:sub" : var.azure_sp_object_id
          }
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "s3" {
  name = "s3"
  role = aws_iam_role.for_azure.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListAllMyBuckets"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
