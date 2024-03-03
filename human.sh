  
#!/bin/bash 
 # 1>/dev/null 2>/dev/null
frontend_fqdn=$1
frontend_fqdn_ssh=$2
setsid /usr/bin/locust -f /tmp/locustfile.py --headless -u 1 -r 1 --host http://$frontend_fqdn   1>/dev/null 2>/dev/null

for i in {1..10}   # you can also use {0..9}
do
    echo "Running SSH to $frontend_fqdn_ssh over iteration $i..."
    setsid ssh $frontend_fqdn_ssh "ps -ef; cd /tmp; touch /tmp/ssh-done.log; echo 'ssh-round'>> /tmp/ssh-done.log; exit"  1>/dev/null 2>/dev/null
    sleep 2
done

