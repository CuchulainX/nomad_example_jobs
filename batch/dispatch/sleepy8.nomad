job sleepy8 {
  datacenters = ["dc1"]

  group "group" {
    task "sleepy.sh" {
      driver = "exec"

      config {
        command = "${NOMAD_TASK_DIR}/sleepy.sh"
      }

      template {
        destination = "local/sleepy.sh"
        data        = <<EOH
#!/bin/bash

SLEEP_SECS=$${SLEEP_SECS:-2} # provide default of 2 seconds
interruptable_sleep() { for i in $(seq 1 $((2*$${1}))); do sleep .5; done; }
sigint() { echo "$(date) - SIGINT received; Ending."; exit 0; }
trap 'sigint'  INT
echo "$(date) - Starting. SLEEP_SECS=$${SLEEP_SECS}"
while true; do echo "$(date) - Sleeping for $${SLEEP_SECS} seconds."; interruptable_sleep ${SLEEP_SECS}; done
EOH
      }

      resources {
        memory = 100
        cpu    = 100
      }
    }
  }
}
