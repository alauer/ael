#!/bin/bash

cd ./1-dx
terraform plan --out tf.plan
terraform apply tf.plan

cd ..
cd ./2-vpc
terraform plan --out tf.plan
terraform apply tf.plan

#cd ..
#cd ./3-application
#terraform plan --out tf.plan
#terraform apply tf.plan

