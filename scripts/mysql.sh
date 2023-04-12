mysql -h $(terraform output -raw public_ip) -P 3307 -u root -p $(terraform output -raw mysql_root_password)
