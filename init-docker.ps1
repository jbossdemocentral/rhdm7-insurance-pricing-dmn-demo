. .\init-properties.ps1

# wipe screen
Clear-Host

set NOPAUSE=true

Write-Host "#################################################################"
Write-Host "##                                                             ##"
Write-Host "##  Setting up the ${DEMO}       ##"
Write-Host "##                                                             ##"
Write-Host "##                                                             ##"
Write-Host "##     ####  #   # ####    #   #   #####    #   #              ##"
Write-Host "##     #   # #   # #   #  # # # #     #      # #               ##"
Write-Host "##     ####  ##### #   #  #  #  #   ###       #                ##"
Write-Host "##     # #   #   # #   #  #     #   #        # #               ##"
Write-Host "##     #  #  #   # ####   #     #  #     #  #   #              ##"
Write-Host "##                                                             ##"
Write-Host "##  brought to you by,                                         ##"
Write-Host "##             %AUTHORS%                                         ##"
Write-Host "##                                                             ##"
Write-Host "##                                                             ##"
Write-Host "##  %PROJECT%      ##"
Write-Host "##                                                             ##"
Write-Host "#################################################################`n"


If (Test-Path "$SRC_DIR\$EAP") {
	Write-Host "Product sources are present...`n"
} Else {
	Write-Host "Need to download $EAP package from the Customer Support Portal"
	Write-Host "and place it in the $SRC_DIR directory to proceed...`n"
	exit
}

#If (Test-Path "$SRC_DIR\$EAP_PATCH") {
#	Write-Host "Product patches are present...`n"
#} Else {
#	Write-Host "Need to download $EAP_PATCH package from the Customer Support Portal"
#	Write-Host "and place it in the $SRC_DIR directory to proceed...`n"
#	exit
#}

If (Test-Path "$SRC_DIR\$DM_DECISION_CENTRAL") {
	Write-Host "Product sources are present...`n"
} Else {
	Write-Host "Need to download $DM_DECISION_CENTRAL package from the Customer Support Portal"
	Write-Host "and place it in the $SRC_DIR directory to proceed...`n"
	exit
}

If (Test-Path "$SRC_DIR\$DM_KIE_SERVER") {
	Write-Host "Product sources are present...`n"
} Else {
	Write-Host "Need to download $DM_KIE_SERVER package from the Customer Support Portal"
	Write-Host "and place it in the $SRC_DIR directory to proceed...`n"
	exit
}

Copy-Item "$SUPPORT_DIR\docker\Dockerfile" "$PROJECT_HOME" -force
Copy-Item "$SUPPORT_DIR\docker\.dockerignore" "$PROJECT_HOME" -force

Write-Host "Starting Docker build.`n"

$argList = "build --no-cache -t jbossdemocentral/rhdm7-insurance-pricing-dmn-demo --build-arg DM_VERSION=$DM_VERSION --build-arg DM_DECISION_CENTRAL=$DM_DECISION_CENTRAL --build-arg DM_KIE_SERVER=$DM_KIE_SERVER --build-arg EAP=$EAP --build-arg JBOSS_EAP=$JBOSS_EAP --build-arg PROJECT_GIT_REPO=$PROJECT_GIT_REPO --build-arg NIOGIT_PROJECT_GIT_REPO=$NIOGIT_PROJECT_GIT_REPO $PROJECT_HOME"
$process = (Start-Process -FilePath docker.exe -ArgumentList $argList -Wait -PassThru -NoNewWindow)
Write-Host "`n"

If ($process.ExitCode -ne 0) {
	Write-Error "Error occurred during Docker build!"
	exit
}

Write-Host "Docker build finished.`n"

Remove-Item "$PROJECT_HOME\Dockerfile" -Force

Write-Host "==============================================================================================="
Write-Host "=                                                                                             ="
Write-Host "=  You can now start the $PRODUCT in a Docker containers with:             ="
Write-Host "=                                                                                             ="
Write-Host "=  docker run -it -p 8080:8080 -p 9990:9990 jbossdemocentral/rhdm7-insurance-pricing-dmn-demo ="
Write-Host "=                                                                                             ="
Write-Host "=  Login into Decision Central at:                                                            ="
Write-Host "=                                                                                             ="
Write-Host "=    http://localhost:8080/decision-central  (u:dmAdmin / p:redhatdm1!)                       ="
Write-Host "=                                                                                             ="
Write-Host "=  See README.md for general details to run the various demo cases.                           ="
Write-Host "=                                                                                             ="
Write-Host "=  $PRODUCT $VERSION $DEMO Setup Complete.                       ="
Write-Host "=                                                                                             ="
Write-Host "==============================================================================================="
