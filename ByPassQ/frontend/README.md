AWS-Frontend-CICD
BitBucket + CodePipeline + S3 + Route 53 + CloudFront

Except that the region of ACM is us-east-1, all regions in this tutorial are ap-southeast-2

Step 1: Register domain in Route 53
image

For example: example.link

image

Fill in details and register the domain

Step 2: Create S3 buckets
a) Please ensure names of S3 buckets are exactly the same with your domain (example.link) and subdomain (www.example.link)

b) Select a region for your app (ap-southeast-2 is using for this tutorial)

c) Enable the Bucket Versioning

d) Remain the rest and create the bucket

Step 3: Change properties and permissions of S3 buckets
For the domain bucket (example.link):

Under the properties page, find the section Static website hosting and click Edit

alt text

Under the permissions page, find the section Cross-origin resource sharing (CORS) and click Edit

Attach CORS policy for the domain bucket

[
    {
        "AllowedHeaders": [],
        "AllowedMethods": [
            "GET"
        ],
        "AllowedOrigins": [
            "*"
        ],
        "ExposeHeaders": []
    }
]
AllowedMethods: please check with the developer

AllowedOrigins: the best practice should be "https://Your-Bucket-Name"

For the subdomain bucket (www.example.link):

Under the properties page, find the section Static website hosting and click Edit

alt text

Please note that we do not need to edit Block public access (bucket settings) if we use Cloudfront

Step 4: Create the buildspec.yml
Upload the buildspec.yml to the root directory of the master branch

version: 0.2

phases:
  install:
    runtime-versions:
      nodejs: 14
      
  pre_build:
    commands:
      - echo Installing source NPM dependencies...
      - npm install
      
  build:
    commands:
      - echo Build started on `date`
      - echo Compiling the Node.js code
      - npm run build
      
  post_build:
    commands:
      - echo Build completed on `date`

# Include only the files required for your application to run.
artifacts:
  files:
    - '**/*'
  discard-paths: no
  base-directory: build
Step 5: Create a CodePipeline
alt text

If you do not own the Bitbucket repo, please create a User role in IAM for the repo owner, and ask the owner generate a connection

You can delete the user after the connection is generated.

If you own the Bitbucket repo, click Connect to Bitbucket and then generate a connection alt text

Next page, choose the CodeBuild and then click the Create Project button if needed image image

More details of images can be founded: https://docs.aws.amazon.com/codebuild/latest/userguide/available-runtimes.html

alt text

The UI will change after you tick the box (Extract file before deploy)

alt text

Review and create the pipeline

Step 6: Create a Hosted Zone
image

Click into the Hosted zone just created and choose Create record.

(Switch to wizard if you have a different UI) Choose Simple routing, and choose Next.

image

Choose Define simple record.

In Record name, accept the default value, which is the name of your hosted zone and your domain.

In Value/Route traffic to, choose Alias to S3 website endpoint.

Choose the Region and the S3 bucket.

For Evaluate target health, choose Yes.

image

To add an alias record for your subdomain (www.example.com)

image

On the Configure records page, choose Create records.

Step 7: Request a certificate in AWS Certificate Manager
Please ensure the region is us-east-1 before doing anything

image image

DNS Validation image

Please confirm all nameservers in Hosted Zone and Registered Domain are identical

image image

Your new certificate might continue to display a status of Pending validation for up to 30 minutes

After the verification is successful, you will see that the status of your certificate becomes Issued, and there are 3 more records in the Hosted Zone of Route 53.

Step 8: Create a distribution in CloudFront
alt text alt text alt text alt text alt text

Step 9: Update records in Route 53
Under Records, select the type A record of your domain and subdomain.

Domain: example.link

alt text

Subdomain: www.example.link

alt text

Step 10: Confirm the S3 bucket policy
Substitute YOUR_DOMAIN_BUCKET and YOUR_OAI

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "1",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity YOUR_OAI"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::YOUR_DOMAIN_BUCKET/*"
        }
    ]
}
References:
https://docs.aws.amazon.com/AmazonS3/latest/userguide/website-hosting-custom-domain-walkthrough.html#website-hosting-custom-domain-walkthrough-domain-registry
https://docs.aws.amazon.com/acm/latest/userguide/dns-validation.html
https://docs.aws.amazon.com/AmazonS3/latest/userguide/website-hosting-cloudfront-walkthrough.html
