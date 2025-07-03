variable "aws_account_id" {
  description = "AWS アカウント ID"
  type        = string
}

variable "my_ip_address" {
  description = "ALB にアクセスする際の使用中の IP アドレス"
  type        = string
}

variable "repository_name" {
  description = "Github のリポジトリ名"
  type        = string
}

variable "github_user" {
  description = "Github のユーザー名"
  type        = string
}


