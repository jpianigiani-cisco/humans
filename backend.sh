  


for i in ${cat mcd_inpus.tfvars}:
do
  curl $i

  ssh "ubuntu@$i" << EOF
  ls /tmp
  ./someaction.sh 'some params'
  pwd
  ./some_other_action 'other params'
EOF 'ps -ef | grep apache | grep -v grep | wc -l'
done

