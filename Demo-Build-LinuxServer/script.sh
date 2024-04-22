#cloud-config
package_upgrade: true

packages:
  - ansible-core
  - rhel-system-roles

users:
  - name: ansinst
    gecos: Ansible User
    groups: users,admin,wheel
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    lock_passwd: true
    ssh_authorized_keys:
      - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDRCJCQ1UD9QslWDSw5Pwsvba0Wsf1pO4how5BtNaZn0xLZpTq2nqFEJshUkd/zCWF7DWyhmNphQ8c+U+wcmdNVcg2pI1kPxq0VZzBfZ7cDwhjgeLsIvTXvU+HVRtsXh4c5FlUXpRjf/x+a3vqFRvNsRd1DE+5ZqQHbOVbnsStk3PZppaByMg+AZZMx56OUk2pZCgvpCwj6LIixqwuxNKPxmJf45RyOsPUXwCwkq9UD4me5jksTPPkt3oeUWw1ZSSF8F/141moWsGxSnd5NxCbPUWGoRfYcHc865E70nN4WrZkM7RFI/s5mvQtuj8dRL67JUEwvdvEDO0EBz21FV/iOracXd2omlTUSK+wYrWGtiwQwEgr4r5bimxDKy9L8UlaJZ+ONhLTP8ecTHYkaU1C75sLX9ZYd5YtqjiNGsNF+wdW6WrXrQiWeyrGK7ZwbA7lagSxIa7yeqnKDjdkcJvQXCYGLM9AMBKWeJaOpwqZ+dOunMDLd5VZrDCU2lpCSJ1M="
