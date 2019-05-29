oc login -u admin -p redhat
oc new-project spring-dev
oc new-project spring-prod
oc new-project jenkins
oc tag openshift/jenkins:2 jenkins/jenkins:2
oc new-app jenkins-ephemeral -n jenkins
while : ; do
  echo "cerificando si Jenkins esta listo..."
  AVAILABLE_REPLICAS=$(oc get dc jenkins -n jenkins -o=jsonpath='{.status.availableReplicas}')
  if [[ "$AVAILABLE_REPLICAS" == "1" ]]; then
    echo "...Si. Jenkins esta listo."
    break
  fi
  echo "...no. Esperando 10 segundos mas."
  sleep 10
done

oc create -f ./pipeline/pipeline.yml -n jenkins


oc adm policy add-role-to-user edit system:serviceaccount:jenkins:jenkins -n spring-dev
oc adm policy add-role-to-user edit system:serviceaccount:jenkins:jenkins -n spring-prod