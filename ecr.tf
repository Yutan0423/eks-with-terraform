resource "aws_ecr_repository" "repository" {
  name                 = "sample-app"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}
