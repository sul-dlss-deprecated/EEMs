# Documented at http://github.com/collectiveidea/delayed_job 'Gory Details' section
# Will be available with 1.8.5 release
Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.max_attempts = 3
Delayed::Worker.max_run_time = 5.minutes
