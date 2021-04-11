## Week 3

```
bash ./rds-script.sql.sh >> logs.log
```

### Terraform
```
terraform init
terraform apply -var 'instance_name=AnotherName03'
terraform destroy
```


#!/bin/bash
aws rds create-db-instance \
    --db-instance-identifier test-mysql-instance \
    --db-instance-class db.t3.micro \
    --engine mysql \
    --master-username admin \
    --master-user-password secret99 \
    --allocated-storage 20

# arn:aws:rds:us-west-2:214066540222:db:test-mysql-instance
# 

aws rds-data execute-statement \
    --resource-arn "arn:aws:rds:us-west-2:214066540222:db:test-mysql-instance" \
    --database "mydb" \
    --sql "update mytable set quantity=5 where id=201"
