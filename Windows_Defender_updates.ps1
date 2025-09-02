$bucket = "aliyun-client-assist.oss-accelerate.aliyuncs.com"
curl -UseBasicParsing `
  -Uri https://${bucket}/windows/aliyun_agent_latest_setup.exe `
  -OutFile 'C:\\aliyun_agent_latest_setup.exe'
&"C:\\aliyun_agent_latest_setup.exe" '/S' '--register' `
'--RegionId="cn-hangzhou"' `
'--ActivationCode="a-hz01nbyiiKyGD6JU15o+9hRbFcPTN0"' `
'--ActivationId="1D828830-B14B-513E-8185-FD174234D18C"'
$identityFile="C:\ProgramData\aliyun\assist\hybrid\instance-id"
for ($i=1; $i -le 60; $i++) {
   if ([System.IO.File]::Exists(${identityFile})) {
      $instanceId=GET-Content ${identityFile}
      echo "Register managed instance ok, instanceId = $instanceId"
      break
   } elseif ($i -le 45) {
      Start-Sleep -Seconds 1
   } else {
      echo "Register managed instance failed."
      exit 1;
   }
} 

echo "download and install CloudMonitor ..."
mkdir -Force -Path 'C:\Program Files\Alibaba\'; cd 'C:\Program Files\Alibaba\'
$bits = if ([Environment]::Is64BitProcess) {"win64"} else {"win32"} 
curl -UseBasicParsing `
  -Uri https://${bucket}/cloud-monitor/agent_latest_${bits}.zip `
  -OutFile .\cloudmonitor_${bits}.zip
Expand-Archive -Force -Path .\cloudmonitor_${bits}.zip -DestinationPath .\ 

.\cloudmonitor\bin\argusagent_service.exe install
net start argusagent
