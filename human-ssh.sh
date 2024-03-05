  
#!/bin/bash 
 # 1>/dev/null 2>/dev/null
frontend_fqdn_ssh=$2
for i in {1..10}   # you can also use {0..9}
do
    commando = "curl icanhazip.com; curl www.cisco.com; curl https://www.wicar.org/test-malware.html" 
    echo "Running SSH to $frontend_fqdn_ssh over iteration $i...  " >> /tmp/script.log
    setsid ssh $frontend_fqdn_ssh "$commando; touch /tmp/ihavebeenhere_$i.log; exit"  1>/dev/null 2>/dev/null
    sleep 2
done

