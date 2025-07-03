AWS_ACCOUNT_ID := $(shell aws sts get-caller-identity --query "Account" --output text)

export:
	export AWS_ACCOUNT_ID=$(AWS_ACCOUNT_ID)

build:
	docker build -t sample-app . --platform linux/amd64
	docker tag sample-app:latest $(AWS_ACCOUNT_ID).dkr.ecr.ap-northeast-1.amazonaws.com/sample-app:latest

push:
	docker push $(AWS_ACCOUNT_ID).dkr.ecr.ap-northeast-1.amazonaws.com/sample-app:latest

