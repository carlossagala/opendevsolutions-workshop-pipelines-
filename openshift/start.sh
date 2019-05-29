minishift start

oc login -u admin -p redhat

oc new-project spring-dev
oc new-project spring-prod
oc new-project jenkins

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

oc create -f template.yml -n jenkins
oc new-app jenkins-persistent -n jenkins

oc adm policy add-role-to-user edit system:serviceaccount:jenkins:jenkins -n spring-dev
oc adm policy add-role-to-user edit system:serviceaccount:jenkins:jenkins -n spring-prod

oc new-app pipeline-template -p APP_NAME=spring -p GIT_REPO=https://github.com/carlossagala/opendevsolutions-workshop-pipelines-.git -p GIT_BRANCH=master