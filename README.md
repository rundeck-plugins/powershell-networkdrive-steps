# Map and unmap Drive

Workflow steps Powershell to map and unmap a drive on remote Windows Nodes.

## Limitation

Currently, On Powershell is not possible to maintain drives mapping on a remote session, ones the remote session is closed.

## Workaround

The workaround for this plugin is mapping the drive using a Powershell's Schedule Job. This workaround needs that the Node-Executor calls the scheduled job, for example:

```
Get-ScheduledJob  | Where-Object {$_.name -Match "RundeckJobs*"} | ForEach-Object { 
  (Get-ScheduledJob -Name $_.name).StartJob() 
  Get-Job | Wait-Job
 } 
```
 
A new Powershell Node-Executor plugin version will implement this code.

The drive will be mapping for any step in the workflow until the `Unmapping` step is called.

Finally, this workaround works just for users that are part of the administrator group