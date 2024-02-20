// IAM Role for SSM Access
resource "aws_iam_role" "SSM_role" {
  name               = "EC2_SSM_Access"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

// Attach Policies to IAM Role
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  role       = aws_iam_role.SSM_role.name
}

resource "aws_iam_role_policy_attachment" "efs_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemFullAccess"
  role       = aws_iam_role.SSM_role.name
}

resource "aws_iam_role_policy_attachment" "s3_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.SSM_role.name
}

resource "aws_iam_role_policy_attachment" "ssm_instance_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.SSM_role.name
}

// Custom Policy to read EC2 tags
resource "aws_iam_role_policy" "custom_policy" {
  name = aws_iam_role.SSM_role.name
  role = aws_iam_role.SSM_role.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances",
        "ec2:DescribeTags"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

/// IAM Instance Profile
resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "EC2_SSM_Access_Instance_Profile"
  role = aws_iam_role.SSM_role.name
}
