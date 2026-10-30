# Periodic Job
Periodic Jobs add a time dimension to the concept of Jobs. Periodic jobs are commonly used for automating system maintanence or administrative tasks. The traditional way of doing this is with a cron. We can use the `CronJob` instance to this in kubernetes and we use the `spec.schedule` to define the cron in the exact template of the Linux crontab entry. The following fields can also be used for the CronJob spec:

|directive|description|
|:----:|:----:|
|`.spec.schedule`| Crontab entry for specifying the Job's schedule. We can also use the `@daily` or `@hourly` shortcuts|
|`.spec.startingDeadlineSeconds`| Deadline in seconds for starting the Job to make the task valid only if executed during a certain time|
|`.spec.concurrencyPolicy`|Specifies how to manage concurrent executions of Jobs created by the same CronJob. The default behavior is `Allow` and allows the creation of new Jobs even if the last one hasn't finished yet. We can also use the `Forbid` and `Replace` values|
|`.spec.successfulJobHistoryLimit` and `.spec.failedJobHistoryLimit`|Specifies how many completed and failed Jobs should be kept for auditing purposes|