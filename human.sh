  
#!/bin/bash 
 # 1>/dev/null 2>/dev/null
frontend_fqdn=$1
frontend_fqdn_ssh=$2
setsid /usr/bin/locust -f /tmp/locustfile.py --headless -u 15 -r 1 --host http://$frontend_fqdn   1>/dev/null 2>/dev/null

touch /tmp/script.log


