resource "aws_iam_role" "role" {
  name = "test-role"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ec2:GetDefaultCreditSpecification",
                "ec2:GetManagedPrefixListEntries",
                "ec2:DescribeTags",
                "ec2:GetCoipPoolUsage",
                "ec2:DescribeVpnConnections",
                "ec2:GetEbsEncryptionByDefault",
                "ec2:GetCapacityReservationUsage",
                "ec2:DescribeVolumesModifications",
                "ec2:GetHostReservationPurchasePreview",
                "ec2:DescribeFastSnapshotRestores",
                "ec2:GetConsoleScreenshot",
                "ec2:GetReservedInstancesExchangeQuote",
                "ec2:GetConsoleOutput",
                "ec2:GetPasswordData",
                "ec2:GetLaunchTemplateData",
                "ec2:DescribeScheduledInstances",
                "ec2:DescribeScheduledInstanceAvailability",
                "ec2:GetManagedPrefixListAssociations",
                "ec2:GetEbsDefaultKmsKeyId",
                "ec2:DescribeElasticGpus"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "policy" {
  name        = "test-policy"
  description = "A test policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}
