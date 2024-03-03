  
#!/bin/bash 
setsid echo hello 1>/dev/null 2>/dev/null
locust -f /tmp/locustfile.py --headless -u 1 -r 1 --host http://$frontend_fqdn