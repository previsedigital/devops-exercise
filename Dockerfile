#This terraform version has been select4ed as its the most up to date version fo Terraform .14

FROM hashicorp/terraform:0.14.11

RUN apk add --no-cache curl

# add terrafrom modules
RUN mkdir /app
ADD main.tf /app/main.tf
ADD ohio.tfvars /app/ohio.tfvars
ADD london.tfvars /app/london.tfvars
ADD variables.tf /app/variables.tf
ADD entrypoint.sh /app/entrypoint.sh

# terraform state directory allowing state to be defined on local machines allowing for multiple states based on project
RUN mkdir /app/.state
VOLUME .state


WORKDIR /app

ENTRYPOINT ["./entrypoint.sh"]