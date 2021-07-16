Red Hat Decision Manager Insurance Pricing DMN Demo
=============================================
This demo project will provide you with an example of creating, deploying and leveraging a set of decisions,
defined in a DMN (Decision Model & Notation) model, in a Decision Server. You will be given examples of calling the rules as if
using it from an application through the REST API that is exposed by the server.

The DMN model used in this demo is a simple, pre-made, example that calculates the insurance price based on someone's age and their incident history. This is the DRD:

![Insurance Pricing DMN Model](./docs/demo-images/insurance-pricing-dmn.png)

The decision logic of the decision node "Insurance total price" is defined in a decision table:

<img src="./docs/demo-images/decision-table.png" title="Insurance Pricing Decision Table" width="50%" height="50%"/>

There are three options for you to install this project: local, OpenShift and Docker

Software
--------
The following software is required to run this demo:
- [JBoss EAP 7.3 zip](https://developers.redhat.com/download-manager/file/jboss-eap-7.3.0.zip)
- [Red Hat Decision Manager 7.11.0.GA Decision Central deployable for EAP 7](https://developers.redhat.com/download-manager/file/rhdm-7.11.0-decision-central-eap7-deployable.zip)
- [Red Hat Decision Manager: KIE-Server 7.11.0.GA deployable for EE7](https://developers.redhat.com/download-manager/file/rhdm-7.11.0-kie-server-ee8.zip)
- [7-Zip](http://www.7-zip.org/download.html) (Windows only): to overcome the Windows 260 character path length limit, we need 7-Zip to unzip the Decision Manager deployable.

Option 1 - Install on your machine
----------------------------------
1. [Download and unzip.](https://github.com/jbossdemocentral/rhdm7-insurance-pricing-dmn-demo/archive/master.zip) or [clone this repo](https://github.com/jbossdemocentral/rhdm7-insurance-pricing-dmn-demo.git).

2. Add the product ZIP files to the installs directory.

3. Run `init.sh` (Linux/macOS) or `init.ps1` (Windows) file.

4. Start Red Hat Decision Manager by running `./target/jboss-eap-7.3/bin/standalone.sh`

5. Login to http://localhost:8080/decision-central

    ```
    - login for admin and analyst roles (u:dmAdmin / p:redhatdm1!)
    ```
6. Click on the "insurance-pricing-dmn" project to open the Insurance Pricing DMN Demo project.

7. The project has a single, simple DMN model (insurance-pricing.dmn) which determines the price of the insurance based on age and incident history.

8. Build and deploy version 1.0.0 of the project. Click on the "Build and Deploy" in the upper right corner.

9. Go to "Menu -> Deploy -> Execution Servers" repository to see the insurance-pricing-dmn_1.0.0 KIE Container deployed on the Decision Server.

10. The Decision Server provides a Swagger UI that documents the full RESTful interface exposed by the server at: http://localhost:8080/kie-server/docs

11. In the Swagger UI:
   - navigate to "KIE Server and KIE containers"
   - expand the "GET" operation for resource "/server/containers"
   - click on "Try it out"
   - leave the parameters blank and click on "Execute"
   - when asked for credentials use: Username: kieserver, Password: kieserver1!
   - observe the response, which lists the KIE Containers deployed on the server and their status (STARTED, STOPPED, DISPOSED).

12. We can use the Swagger UI to test our Insurance Pricing DMN Decision Service. In the Swagger UI:
   - navigate to "DMN models"
   - expand the "POST" operation for resource "/server/containers/{containerId}/dmn"
   - click on "Try it out"
   - set the "containerId" parameter to the name of the KIE Container that hosts our rules, in this case `insurance-pricing-dmn`.
   - set "Parameter content type" to `application/json`.
   - set "Response content type" to `application/json`
   - use the following request as the "body" parameter:

   ```
   {
       "model-namespace":"http://www.trisotech.com/definitions/_bb8b9304-b29f-462e-9f88-03d0d868aec5",
       "model-name":"Insurance Pricing",
       "decision-name":null,
       "decision-id":null,
       "dmn-context":{
          "had previous incidents":false,
          "Age":23
       }
   }
   ```

   - observe the result. The Insurance Pricing DMN model will have been evaluated and has determined that, based on the age and incident history, that the "Insurance Total Price" is 2000.


Option 2 - Run on OpenShift
-----------------------------------------
This demo can be installed on Red Hat OpenShift in various ways. We'll explain the different options provided.

All installation options require an `oc` client installation that is connected to a running OpenShift instance. More information on OpenShift and how to setup a local OpenShift development environment based on the Red Hat Container Development Kit can be found [here](https://developers.redhat.com/products/cdk/overview/).

---
**NOTE**

The Red Hat Decision Manager 7 - Decision Central image requires a [Persistent Volume](https://docs.openshift.com/container-platform/3.7/architecture/additional_concepts/storage.html) which has both `ReadWriteOnce` (RWO) *and* `ReadWriteMany` (RWX) Access Types. If no PVs matching this description are available, deployment of that image will fail until a PV of that type is available.

---

### Automated installation, manual project import
This installation option will install the Decision Manager 7 and Decision Service in OpenShift using a single script, after which the demo project needs to be manually imported.

1. [Download and unzip.](https://github.com/jbossdemocentral/rhdm7-insurance-pricing-dmn-demo/archive/master.zip) or [clone this repo](https://github.com/jbossdemocentral/rhdm7-insurance-pricing-dmn-demo.git).

2. Run the `init-openshift.sh` (Linux/macOS) or `init-openshift.ps1` (Windows) file. This will create a new project and application in OpenShift.

3. Login to your OpenShift console. For a local OpenShift installation this is usually: https://{host}:8443/console

4. Open the project "RHDM7 Insurance Pricing DMN Demo". Open the "Overview". Wait until the 2 pods, "rhdm7-insurance-pricing-dmn-rhdmcentr" and "rhdm7-insurance-pricing-dmn-kieserver" have been deployed.

5. Open the "Networking -> Routes" screen. Click on the "Location" value next to "rhdm7-insurance-rhdmcentr". This opens the Decision Central console.

6. Login to Decision Central:

    ```
    - login for admin and analyst roles (u:dmAdmin / p:redhatdm1!)
    ```
7. Click on "Design" to open the design perspective.

8. Click on "Import project". Enter the following as the repository URL: https://github.com/jbossdemocentral/rhdm7-insurance-pricing-dmn-demo-repo.git , and click on "Import".

9. Select "insurance-pricing-dmn" and click on the "Ok" button on the right-hand side of the screen.

10. The project has a single, simple DMN model (insurance-pricing.dmn) which determines the price of the insurance based on age and incident history.

11. Build and deploy version 1.0.0 of the project. Click on the "Build and Deploy" in the upper right corner.

12. Go to "Menu -> Deploy -> Execution Servers" repository to see the insurance-pricing-dmn_1.0.0 KIE Container deployed on the Decision Server.

13. The Decision Server provides a Swagger UI that documents the full RESTful interface exposed by the server at. To open the Swagger UI, go back to
the OpenShift console, and go to the "Networking - Routes" screen. Copy the "Location" value next to "
rhdm7-insurance-kieserver". Paste the URL in a browser tab and add "/docs" to the URL. This will show the Swagger UI.

14. Follow instructions from above "Option 1- Install on your machine", starting at step 11.

### Scripted installation
This installation option will install the Decision Manager 7 and Decision Service in OpenShift using the provided `provision.sh` (Linux/macOS) or `provision.ps1` (Windows) script, which gives the user a bit more control how to provision to OpenShift.

1. [Download and unzip.](https://github.com/jbossdemocentral/rhdm7-insurance-pricing-dmn-demo/archive/master.zip) or [clone this repo](https://github.com/jbossdemocentral/rhdm7-insurance-pricing-dmn-demo.git).

2. In the demo directory, go to `./support/openshift`. In that directory you will find the `provision.sh` (Linux/macOS) and `provision.ps1` (Windows) script.

3. Run `./provision.sh -h` (Linux/macOS) or `./provision.ps1 -h` (Windows) to inspect the installation options.

4. To provision the demo, with the OpenShift ImageStreams in the project's namespace, run `./provision.sh setup rhdm7-insurance --with-imagestreams` (Linux/macOS) or `./provision.sh -command setup -demo rhdm7-insurance -with-imagestreams` (Windows)


    ---
    **NOTE**

    The `with-imagestreams` parameter installs the Decision Manager 7 image streams and templates into the project namespace instead of the `openshift` namespace (for which you need admin rights). If you already have the required image-streams and templates installed in your OpenShift environment in the `openshift` namespace, you can omit the `with-imagestreams` from the setup command.

    ---

5. A second useful option is the `--pv-capacity` (Linux/macOS)/ `-pv-capacity` (Windows) option, which allows you to set the capacity of the _Persistent Volume_ used by the Decision Central component. This is for example required when installing this demo in OpenShift Online, as the _Persistent Volume Claim_ needs to be set to `1Gi` instead of the default `512Mi`. So, to install this demo in OpenShift Online, you can use the following command: `./provision.sh setup rhdm7-install --pv-capacity 1Gi --with-imagestreams` (Linux/macOS) or `./provision.ps1 -command setup -demo rhdm7-install -pv-capacity 1Gi -with-imagestreams` (Windows).

6. After provisioning, follow the instructions from above "Option 2 - Automated installation, manual project import", starting at step 3.

7. To delete an already provisioned demo, run `./provision.sh delete rhdm7-install` (Linux/macOS) or `./provision.ps1 -command delete -demo rhdm7-install` (Windows).




Option 3 - Run in Docker
-----------------------------------------
The following steps can be used to configure and run the demo in a container

1. [Download and unzip.](https://github.com/jbossdemocentral/rhdm7-insurance-pricing-dmn-demo/archive/master.zip) or [clone this repo](https://github.com/jbossdemocentral/rhdm7-insurance-pricing-dmn-demo.git).

2. Add the product ZIP files to installs directory.

3. Run the 'init-docker.sh' (Linux/macOS) or 'init-docker.ps1' (Windows) file.

4. Start the container: `docker run -it -p 8080:8080 -p 9990:9990 jbossdemocentral/rhdm7-insurance-pricing-dmn-demo`

5. Follow instructions from above "Option 1- Install on your machine", starting at step 5 replacing *localhost* with *&lt;CONTAINER_HOST&gt;* when applicable.

Additional information can be found in the jbossdemocentral container [developer repository](https://github.com/jbossdemocentral/docker-developer)


Supporting Articles & Videos
----------------------------
- [Your first DMN Microservice on Red Hat Decision Manager 7](https://upload.wikimedia.org/wikipedia/commons/6/67/Learning_Curve_--_Coming_Soon_Placeholder.png)

- [Getting Started with Red Hat Decision Manager 7](https://developers.redhat.com/blog/2018/03/19/red-hat-decision-manager-7/)


Released versions
-----------------
See the tagged releases for the following versions of the product:

- v1.3 Red Hat Decision Manager 7.11.0.GA
- v1.2 Red Hat Decision Manager 7.7.0.GA
- v1.1 Red Hat Decision Manager 7.5.0.GA
- v1.0 Red Hat Decision Manager 7.0.0.GA

![Red Hat Decision Manager 7](./docs/demo-images/rhdm7.png)

![Insurance Pricing DMN Model](./docs/demo-images/insurance-pricing-dmn.png)

<img src="./docs/demo-images/decision-table.png" title="Insurance Pricing Decision Table" width="50%" height="50%"/>

![Execution Server View](./docs/demo-images/execution-server-view.png)


