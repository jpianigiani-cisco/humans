  
for i in ${cat mcd_inpus.tfvars | grep public-ips}:
do
  curl "$i:8080"
  ssh "ubuntu@$i" << EOF
  ls /tmp
  docker ps
  pwd
EOF 
done

