data "aws_iam_policy_document" "website_policy" {
  statement {

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion"
    ]
    principals {
      identifiers = ["*"]
      type = "AWS"
    }
    resources = [
      "arn:aws:s3:::cleanforce-test-frontend/*"
    ]
  }
}

/*data "aws_iam_policy_document" "backend_policy" {
    statement {
      effect = ["Allow"]
      actions = ["s3:ListBucket"
      ]
      Resource = ["arn:aws:s3:::cleanforce-frontend-state"
      ]
    }
    statement {
      effect = ["Allow"]
      actions = ["s3:GetObject",
                 "s3:PutObject"
      ]
      Resource = ["arn:aws:s3:::cleanforce-frontend-state/terraformstate/key"
      ]

    }
}*/
