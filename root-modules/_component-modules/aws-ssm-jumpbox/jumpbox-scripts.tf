locals {
  jumpbox_scripts = {
    create_mysql_user = <<-EOT
      #!/bin/bash

      echo -n New user name:
      read -s user
      echo

      echo -n New user password:
      read -s password

      echo
      mysql \$@ -e \"CREATE USER '\$user' IDENTIFIED BY '\$password';\"
    EOT
    alter_mysql_user  = <<-EOT
      #!/bin/bash

      echo -n User name:
      read -s user
      echo

      echo -n User new password:
      read -s password

      echo
      mysql \$@ -e \"ALTER USER '\$user' IDENTIFIED BY '\$password';\"
    EOT
  }
}