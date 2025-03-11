*** Settings ***
Resource    ../resources/common.robot

Suite Setup    Custom Setup
Test Teardown    Collect Logs
Suite Teardown    Collect Logs

*** Test Cases ***

Publish Raw Data Periodically
    Skip    msg=TODO
    ${values}=    Cumulocity.Device Should Have Measurements    type=sensor    minimum=1

Publish an Alert
    ${values}=    Cumulocity.Device Should Have Alarm/s    type=schedule_req    minimum=1    timeout=45

*** Keywords ***

Custom Setup
    ${DEVICE_SN}=    Setup
    Set Suite Variable    $DEVICE_SN
    Cumulocity.External Identity Should Exist    ${DEVICE_SN}
