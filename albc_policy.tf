resource "aws_iam_policy" "aws_load_balancer_controller" {
  name   = "EKSIngressAWSLoadBalancerController"
  policy = file("${path.module}/albc_iam_policy.json")
}

module "iam_assumable_role_admin" {
  source                       = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  create_role                  = true
  role_name                    = "EKSIngressAWSLoadBalancerController"
  provider_url                 = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns             = [aws_iam_policy.aws_load_balancer_controller.arn]
  oidc_subjects_with_wildcards = ["system:serviceaccount:*:*"]
}
