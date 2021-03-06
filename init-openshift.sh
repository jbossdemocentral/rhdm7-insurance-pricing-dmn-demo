#!/bin/sh

function echo_header() {
  echo
  echo "########################################################################"
  echo $1
  echo "########################################################################"
}

PRJ_DEMO="rhdm7-insurance"
PRJ_DEMO_NAME=$(./support/openshift/provision.sh info $PRJ_DEMO | awk '/Project name/{print $3}')

# Check if the project exists
oc get project $PRJ_DEMO_NAME > /dev/null 2>&1
PRJ_EXISTS=$?

if [ $PRJ_EXISTS -eq 0 ]; then
   echo_header "$PRJ_DEMO_NAME project already exists. Deleting project."
   ./support/openshift/provision.sh delete $PRJ_DEMO
   # Wait until the project has been removed
   echo_header "Waiting for OpenShift to clean deleted project."
   sleep 10
else if [ ! $PRJ_EXISTS -eq 1 ]; then
	echo "An error occurred communicating with your OpenShift instance."
	echo "Please make sure that your logged in to your OpenShift instance with your 'oc' client."
  exit 1
  fi
fi

echo_header "Provisioning Red Hat Decision Manager 7 Demo."
./support/openshift/provision.sh setup $PRJ_DEMO --with-imagestreams
echo_header "Setup completed."
