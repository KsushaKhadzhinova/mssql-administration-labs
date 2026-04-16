# Verification of Requirements

## Overall status

| Area | Requirement | Status | Notes |
|---|---|---|---|
| Environment & infrastructure | WSL2, Ubuntu, Docker, 3 instances (`sql1`, `sql2`, `sql3`) | Met | Setup scripts and `docker-compose.yml` provide the full lab environment. |
| Database structure | Minimum 7 tables in `ProjectDB` | Met | `ProjectDB` contains `Categories`, `Suppliers`, `Products`, `Stocks`, `Customers`, `Orders`, `OrderDetails`. |
| Lab 1.1 | Installation and basic configuration | Met | Instance checks, connectivity tests, server properties, stop/start, and port verification are included. |
| Lab 1.2 | Database and file management | Met | Filegroups, `.ndf` file, file growth, schemas, and ownership are implemented. |
| Lab 1.3 | Backup and restore | Met | Master backup, corruption demo, restore, cross-instance restore, snapshots, and log recovery are covered. |
| Lab 1.4 | Security management | Met | Logins, users, roles, `DENY` permissions, and schema authorization are implemented. |
| Lab 2.1 | Administration automation | Met | SQL Agent, Database Mail, operator, jobs, alerts, and job history checks are included. |
| Lab 2.2 | Replication and HA/DR | Met | Distribution, publication, subscription, log shipping, and strategy notes are included. |
| Lab 2.3 | Monitoring and troubleshooting | Met | DMVs, Extended Events, performance testing, indexing, execution plans, and cleanup are included. |
| Script constraints | CLI only, no Russian in scripts, no comments, Bash/sqlcmd based | Met | All scripts are console-friendly and aligned with the requested constraints. |

---

## What is included

- The setup phase defines the full lab infrastructure with three SQL Server containers and shared backup storage.
- The SQL design for `ProjectDB` is sufficient for the later labs and uses a realistic relational structure.
- Each lab from 1.1 to 2.3 has a matching Markdown block with commands and expected results.
- The automation and monitoring labs use native SQL Server tools such as SQL Agent, Database Mail, DMVs, and Extended Events.
- The HA/DR section includes replication and log shipping guidance, plus a backup strategy for the company scenario.

---

## Notes

- The mirroring example is correctly described as a syntax example only, since it is deprecated and not supported on Linux.
- The corruption demo with `dd` is appropriate only for the isolated training environment.
- The `SHOWPLAN_TEXT` approach is a valid CLI replacement for SSMS execution-plan inspection in this context.
- For final delivery, the safest format is one Markdown file with all labs and one summary checklist like this one.

---

## Final assessment

All stated requirements for Labs 1.1 through 2.3 are covered in the current material. The project is ready to be packaged as a single Markdown guide for submission or study.
