docker ps --filter "name=sql" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
