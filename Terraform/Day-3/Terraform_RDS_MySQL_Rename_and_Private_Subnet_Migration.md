# Terraform Runbook: Rename an Existing RDS MySQL Instance and Move It to Private Subnets

## Goal

Safely update an existing Terraform-managed Amazon RDS for MySQL DB instance so that:

- The **DB instance identifier** changes from `mydb` to a new identifier such as `dev-mydb-99b7c6`.
- The existing MySQL data is retained.
- The DB instance becomes private and uses private subnets.
- The existing EC2 instance can continue connecting to RDS over TCP `3306` through VPC networking.

This runbook is based on the lab details shared in the conversation: Region `us-east-1`, MySQL RDS, Single-AZ at the time of the screenshot, and private subnet `subnet-0a0c7080a3ad24c29`. Confirm all live values in the AWS account before making changes. Do not put database passwords in this document or commit them to Git.

---

## Important corrections before starting

### 1. RDS instance identifier is not the MySQL database/schema name

- **DB instance identifier** (for example, `mydb`) is the AWS resource identifier.
- **MySQL database/schema name** is created inside MySQL and is separate.
- Renaming the RDS DB instance identifier does not rename or erase the MySQL databases stored inside the instance.

AWS supports renaming an RDS DB instance. The instance reboots, and its endpoint changes. Applications must use the new endpoint after the rename.

### 2. Do not switch to a brand-new DB subnet group in the same VPC

For an existing RDS DB instance, AWS documents that you cannot directly change to another DB subnet group in the same VPC. This is why assigning a newly created group such as `dev-rds-subnet-group` can fail even when both groups are in the same VPC.

For a same-VPC public-to-private subnet migration, AWS documents a workaround that updates the **currently attached DB subnet group**, temporarily uses Multi-AZ, and performs a failover. Do not follow the simple instruction “create a new private subnet group and change `db_subnet_group_name`” for this existing instance.

---

## Phase 0 — Record the current configuration and take a backup

1. In **RDS → Databases → mydb → Connectivity & security**, record:
   - Current DB instance identifier.
   - Current DB subnet group name.
   - VPC ID.
   - Current Availability Zone.
   - Publicly accessible setting.
   - Multi-AZ setting.
   - Current endpoint and port.
   - Attached VPC security groups.
2. Open **RDS → Snapshots → Take snapshot** and create a manual snapshot. Wait until it is `Available` before continuing.
3. Verify that the RDS instance is `Available` and that the EC2-to-RDS connection works before making changes.
4. Do not change the engine version, storage, DB instance class, identifier, and networking all at once. Separate the rename from the subnet migration so each plan is easier to review.

Optional AWS CLI read-only check:

```bash
aws rds describe-db-instances \
  --db-instance-identifier mydb \
  --query "DBInstances[0].[DBInstanceIdentifier,DBSubnetGroup.DBSubnetGroupName,DBSubnetGroup.VpcId,PubliclyAccessible,MultiAZ,Endpoint.Address,AvailabilityZone]" \
  --output table
```

Record the **currently attached** DB subnet group name. Do not assume it is the new `dev-rds-subnet-group`.

---

## Phase 1 — Rename the existing RDS DB instance with Terraform

1. Keep the existing `aws_db_instance` resource address the same: `module.rds.aws_db_instance.default`.
2. Change the `identifier` input/value to the new unique identifier, for example `dev-mydb-99b7c6`.
3. Do not create a second `aws_db_instance` resource for the rename.
4. Check the installed Terraform AWS provider version with `terraform providers` and `terraform version`.
5. Run:

```bash
terraform fmt
terraform validate
terraform plan
```

6. Review the RDS resource action:
   - **In-place update (`~`) for the identifier:** review the full diff, then it is eligible to proceed.
   - **Replacement (`-/+`) or destroy (`-`): STOP. Do not apply.** Investigate the provider version and every attribute marked ` forces replacement` before proceeding.
7. After a reviewed in-place plan, apply the rename. Wait for the DB instance to return to `Available`.
8. Copy the new endpoint from **RDS → Databases → renamed instance → Connectivity & security** and update the EC2/application connection configuration.

AWS notes that the endpoint changes after a rename and that the DB instance is rebooted. The old DNS name is removed; the new DNS name can take several minutes to become effective.

---

## Phase 2 — Identify the subnet currently used by the RDS primary

Do this before editing the existing DB subnet group.

1. Copy the current RDS endpoint from the RDS console.
2. Resolve the endpoint from a machine with DNS access:

```bash
nslookup <CURRENT_RDS_ENDPOINT>
```

3. In **VPC → Subnets**, identify which subnet CIDR contains the resolved private IP address. Record that subnet as the **current primary subnet**.
4. Confirm the subnet's Availability Zone and confirm the VPC ID matches the RDS instance VPC.
5. Confirm that `subnet-0a0c7080a3ad24c29` is in that same VPC and is actually private based on its route table. Obtain at least one more private subnet in a different Availability Zone. Prefer two or more private subnets across different AZs.

A subnet name or tag alone does not prove that a subnet is private. Inspect its route table. A route to an Internet Gateway (`igw-...`) indicates a public route; a private subnet commonly uses a NAT Gateway for outbound internet, or has no internet default route.

---

## Phase 3 — Prepare the EXISTING DB subnet group

**Do not change `db_subnet_group_name` to the newly created subnet group.** Keep the currently attached DB subnet group name.

1. Open **RDS → Subnet groups** and edit the DB subnet group currently attached to the DB instance.
2. Add the verified private subnets from at least two Availability Zones.
3. Temporarily keep the public subnet that contains the current RDS primary. Do not remove that subnet before the failover.
4. Follow the AWS same-VPC migration procedure: retain the current primary's public subnet and add the private subnets; remove other public subnets from the group where appropriate, but do not remove the current primary subnet yet.
5. Save the changes and verify that the existing group now contains the current primary subnet plus the required private subnet choices.

### Terraform state ownership

The existing DB subnet group must be represented correctly in Terraform before applying configuration changes.

- Run `terraform state list` and inspect the subnet-group resource address, if one exists.
- Run `terraform state show <SUBNET_GROUP_RESOURCE_ADDRESS>` to confirm which real DB subnet group Terraform currently tracks.
- If the resource is already tracking the **currently attached** DB subnet group, update that resource's `subnet_ids` to match the transition list above.
- If the resource block/state currently tracks only the newly created `dev-rds-subnet-group`, do not point the DB instance at it. Reconcile state carefully: remove only the incorrect resource address from Terraform state (this does not delete the AWS subnet group), change the resource configuration to describe the existing attached group, and import the existing group at the correct module address. Example import address, if it matches the actual configuration:

```bash
terraform import module.rds.aws_db_subnet_group.main <EXISTING_ATTACHED_DB_SUBNET_GROUP_NAME>
```

Do not run `terraform state rm` or `terraform import` blindly. First confirm the exact address and group name with `terraform state list`, `terraform state show`, and the RDS console. The unused `dev-rds-subnet-group` can be cleaned up only after confirming it is not attached to any DB instance and is no longer needed.

---

## Phase 4 — Use Multi-AZ failover to move the primary into a private subnet

This is the AWS-documented same-VPC workaround. Plan a maintenance window because the steps cause service interruption. Enabling Multi-AZ temporarily adds a standby DB instance and increases cost while enabled.

1. In the RDS console, verify the current DB instance is Single-AZ and set **Publicly accessible = No**. If already set to `No`, leave it that way.
2. Ensure the existing DB subnet group contains the current primary subnet plus the private subnet options from Phase 3.
3. Temporarily enable **Multi-AZ** on the existing DB instance. Wait until the modification completes and the DB is `Available`.
4. Perform **Reboot with failover** from the RDS console (or the equivalent supported operation for the instance).
5. Wait for the failover to complete. Resolve the endpoint again and verify that the new primary IP belongs to one of the private subnet CIDRs.
6. After confirming the new primary is in a private subnet, disable Multi-AZ if you do not want to keep it for this lab. Wait for the instance to return to `Available`.
7. Edit the same existing DB subnet group and remove the old public subnet. Keep only the verified private subnets in at least two Availability Zones.
8. Verify `Publicly accessible = No`, the primary IP maps to a private subnet, and the DB subnet group contains private subnets only.

Do not remove the old public subnet before failover has moved the primary away from it. Do not delete the VPC subnet itself; remove only its association from the DB subnet group when the migration is complete.

---

## Phase 5 — Reconcile the final Terraform configuration

After the AWS migration has completed, make Terraform describe the final live configuration:

- `identifier` uses the new instance identifier.
- `db_subnet_group_name` remains the name of the **same existing DB subnet group** used during the migration; do not switch to the newly created group.
- The Terraform-managed DB subnet group resource lists only the final private subnet IDs.
- `publicly_accessible = false`.
- `multi_az` is set to the intended final value (`false` for the original Single-AZ lab, or `true` if you intentionally want to retain Multi-AZ and its cost).
- `vpc_security_group_ids` references the RDS security group.

The RDS security group should allow inbound MySQL TCP `3306` only from the EC2 security group (or other specifically approved application security groups). Do not allow `0.0.0.0/0` on port `3306`.

Run the following and review every proposed change:

```bash
terraform fmt
terraform validate
terraform plan
```

Only apply a plan that matches the intended final state and does not unexpectedly replace or destroy the RDS instance.

---

## Phase 6 — Verify the result

In **RDS → Databases → renamed instance → Connectivity & security**, confirm:

- New DB instance identifier is shown.
- Status is `Available`.
- Publicly accessible is `No`.
- DB subnet group is the existing group updated for the migration.
- Its subnet list contains private subnets in at least two Availability Zones.
- RDS security group allows TCP `3306` from the EC2 security group.

From EC2:

```bash
nslookup <NEW_RDS_ENDPOINT>
nc -zv <NEW_RDS_ENDPOINT> 3306
mysql -h <NEW_RDS_ENDPOINT> -P 3306 -u <DB_USERNAME> -p
```

Inside MySQL, verify the existing schemas and sample data:

```sql
SHOW DATABASES;
USE <EXISTING_DATABASE_NAME>;
SHOW TABLES;
SELECT COUNT(*) FROM <EXISTING_TABLE_NAME>;
```

Use the new endpoint after the rename. The database/schema names and table data should remain as they were; the endpoint is what changes during the DB instance rename.

---

## Stop conditions and cost precautions

- **Never apply a plan that destroys/recreates the existing DB instance** when your goal is to keep the current database and data.
- Do not change `db_subnet_group_name` to a different subnet group in the same VPC; update the existing attached group using the documented workaround.
- Do not remove the current primary's subnet from the DB subnet group before failover.
- Keep the manual snapshot until the rename and connectivity checks are complete.
- A temporary Multi-AZ deployment adds standby-instance cost. Disable it after the move if the lab does not need Multi-AZ.
- The RDS details previously shared showed MySQL 5.7 Extended Support enabled. Check the associated charges and plan a separate engine upgrade; do not combine an engine upgrade with this network migration.
- The DB password was shared in chat earlier. Rotate it and do not place it in this Markdown file, Terraform source, or Git.

---

## AWS references

- [Rename a DB instance — Amazon RDS User Guide](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_RenameInstance.html)
- [Move an RDS DB instance from a public to private subnet in one VPC — AWS re:Post](https://repost.aws/knowledge-center/rds-move-to-private-subnet)
- [Updating the VPC for a DB instance — Amazon RDS User Guide](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_VPC.VPC2VPC.html)
- [ModifyDBInstance API — Amazon RDS](https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_ModifyDBInstance.html)
