  
#!/bin/bash 
for i in $(cat mcd_inputs.tfvars | grep public-ips):
do
  echo $i
  myline=echo $i|awk -F"="{'print $2'}
  echo $myline
  #hostip=$(awk -F "=" {'print $2'} << $i)
  #echo $hostip
  #curl "$hostip:8080"
  #ssh "ubuntu@$i" "ls /tmp; docker ps; pwd" 
done

