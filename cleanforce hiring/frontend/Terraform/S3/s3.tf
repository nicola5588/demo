resource "aws_s3_bucket" "cleanforceFrontEnd" {
bucket = "cleanforce-test-frontend"
force_destroy = true
acl = "public-read"
policy = data.aws_iam_policy_document.website_policy.json
website {
    index_document = "index.html"
    error_document = "index.html"
}
lifecycle {
    create_before_destroy = false
}


}

/*
resource "aws_s3_bucket" "cleanforceFrontEndState" {
bucket = "cleanforce-frontend-state"
force_destroy = true
acl = "private-read"
policy = data.aws_iam_policy_document.backend_policy.json
}*/