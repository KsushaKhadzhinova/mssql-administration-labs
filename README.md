# MS SQL Server Administration Portfolio

**Student:** Kseniya Khadzhinova  
**Technologies:** Docker, SQL Server 2022 (Linux), Ubuntu (WSL2), Bash, T-SQL

This repository contains a comprehensive set of laboratory works covering the full lifecycle of MS SQL Server administration, including deployment, disaster recovery, security, automation, and high availability.

---

## Infrastructure Architecture

The project simulates a distributed corporate network consisting of three nodes connected via a dedicated Docker virtual network.

```mermaid
graph TD
    subgraph Docker_Network [Docker Virtual Network]
    SQL1[<b>sql1</b><br/>Publisher / Distributor<br/>Port: 14331] 
    SQL2[<b>sql2</b><br/>Subscriber<br/>Port: 14332]
    SQL3[<b>sql3</b><br/>Log Shipping Standby<br/>Port: 14333]
    
    SQL1 -- Transactional Replication --> SQL2
    SQL1 -- Log Shipping --> SQL3
    end

    WSL[<b>Ubuntu WSL2</b><br/>Management: sqlcmd / Bash] 
    WSL --> SQL1
    WSL --> SQL2
    WSL --> SQL3
