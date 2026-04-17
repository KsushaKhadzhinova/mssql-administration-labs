# Final Project Report

**Student:** Kseniya Khadzhinova  
**Project:** MS SQL Server Administration & Distributed Infrastructure  

---

## 1. Project Objective
The goal of this project was to design, deploy, and manage a distributed Microsoft SQL Server environment using Docker. The portfolio demonstrates proficiency in database lifecycle management, disaster recovery, security auditing, and high-availability configuration.

---

## 2. Laboratory Completion Status

| Lab ID | Module Description | Status | Verification Method |
| :--- | :--- | :--- | :--- |
| **1.1** | SQL Server Installation & Connectivity | **Completed** | Instance check via `sqlcmd` |
| **1.2** | Database Physical Architecture (MDF/NDF/LDF) | **Completed** | Filegroup validation scripts |
| **1.3** | Disaster Recovery: Corruption & Restoration | **Completed** | `dd` corruption & Page restore |
| **1.4** | Security: Role-Based Access Control (RBAC) | **Completed** | Audit of DENY/GRANT permissions |
| **2.1** | Administration Automation (SQL Agent) | **Completed** | Job history and Operator alerts |
| **2.2** | High Availability: Transactional Replication | **Completed** | Data sync between sql1 and sql2 |
| **2.3** | Monitoring & Performance Optimization | **Completed** | Columnstore index & DMVs |

---

## 3. Technical Environment Specifications

* **Platform:** Docker Engine on Ubuntu (WSL2)
* **SQL Version:** Microsoft SQL Server 2022 (Developer Edition)
* **Nodes:** * `sql1` (Port 14331): Primary / Publisher / Distributor
    * `sql2` (Port 14332): Subscriber
    * `sql3` (Port 14333): Standby (Log Shipping)

---

## 4. Definition of Done (DoD) Checklist

- [x] **Infrastructure:** All 3 containers are healthy and reachable via internal Docker network.
- [x] **Automation:** SQL Server Agent is enabled and executing scheduled backup jobs.
- [x] **Integrity:** The environment can be fully wiped and redeployed using `cleanup.sh` and `run_all_labs.sh`.
- [x] **Security:** Standard `sa` account is secured; application-level logins have restricted access.
- [x] **Language Consistency:** All documentation, logs, and T-SQL objects are named in English.
- [x] **Documentation:** Each lab folder contains a README with clear instructions and expected results.

---

## 5. Final Infrastructure Validation

### Orchestration Test
The master script `scripts/run_all_labs.sh` was executed on a clean environment. All steps, including database creation, file corruption simulation, and replication setup, were completed without manual intervention.

### Disaster Recovery Proof
The database `Test` was successfully recovered after a manual header corruption of the primary data file. No data loss occurred, and the recovery time objective (RTO) was under 30 seconds.

---

## 6. Conclusion
The infrastructure meets all requirements for a professional MS SQL Server environment. The project is ready for production simulation and academic defense.

---
**Verified by:** Kseniya Khadzhinova  
**Role:** Database Administrator (DBA)
