**Work in progress - see roadmap at the bottom**

# Motivation

Setting up Call of Duty 2 server requires a lot of configuration and can be a pain. Use this repo to automate process of provisioning and configuring. It utilizes terraform and creates EC2 instance then deploys desired CoD2 servers on it.

Thanks a lot to whole [killtube.org](https://killtube.org/) community for open-source developing. This repository uses/installs following projects:
- [voron00/libcod](https://github.com/voron00/libcod)
- [Lonsofore/cod2docker](https://github.com/Lonsofore/cod2docker)
- [ibuddieat/zk_libcod](https://github.com/ibuddieat/zk_libcod)

# Pre-requirements

- terraform CLI
- AWS account (`aws_access_key_id` + `aws_secret_access_key` with S3 reader permission) 
- CoD2 server files uploaded to S3, bucket should look like this:

```
S3 bucket
├── 1_0
│   ├── iw_00.iwd
│   ├── iw_01.iwd
│   ├── iw_02.iwd
│   ├── (...)
│   ├── iw_13.iwd
│   ├── iw_14.iwd
│   └── localized_english_iw99.iwd
└── 1_3
    └── iw_15.iwd
```

`localized_english_iw99.iwd` comes from this [IzNoGoD's post](https://killtube.org/showthread.php?2873-CoD2-Install-CoD2-on-your-VDS-much-faster!&p=16261&viewfull=1#post16261)

# Usage

```sh
# Provision required resources
terraform apply # See description below

# SSH connect to the created server
./scripts/connect.sh
```

# What actions does `terraform apply` perform?

1. Create key pair and stores private one in `keys/private_key.pem`
2. Creates AWS security groups (opens instance communication)
3. Creates EC2 instance
4. Performs initalization on provided machine
5. Installs required packages like: aws cli, unzip
6. Setups docker engine and docker-compose
7. Creates structure for CoD2 servers
8. Syncs S3 bucket with CoD2 server files
9. Copies files to enable 1.3 version running
10. Provides docker-compose files
11. Starts LAMP stack
12. Configures folder for FastDL
13. Starts CoD2 server

# FastDL setup

When you want to enable fast download for server you need to copy files to fast download folder. Example for `myserver` file `test.iwd`

```sh
sudo scp -i ./keys/private_key.pem ./setup/cod2/myserver/test.iwd ubuntu@$(terraform output -raw public_ip):~/cod2/fastdl/myserver/
sudo scp -i ./keys/private_key.pem ./setup/cod2/myserver/test.iwd ubuntu@$(terraform output -raw public_ip):~/cod2/myserver/
```

# Use scripts to setup on existing machine

1. Put the necessary scripts on the machine
```sh
sudo scp -r -i ./keys/primary_server.pem ./setup/ ubuntu@$(terraform output -raw public_ip):~/setup
```

Expected structure:
```
/home/ubuntu
├── lamp
│   ├── docker-compose.yml
│   ├── downloads.conf
│   └── html
│       └── index.php
├── scripts
│   ├── parts
│   │   ├── cod2.sh
│   │   ├── mysql.sh
│   │   ├── parse_arguments.sh
│   │   └── requirements.sh
│   └── start.sh
└── servers
    ├── docker-compose.yml
    └── myserver
        ├── sample_fx.iwd
        └── server.cfg
```

2. Run following commands

```sh
chmod +x -R ~/scripts
cd ~/scripts
./start.sh --mysql_root_password=<your_mysql_root_password> --aws_access_key_id=<your_aws_access_key_id> --aws_secret_access_key=<your_aws_secret_access_key> --s3_bucket_name=<your_s3_bucket_name>
```

# Roadmap

- ✅ [terraform] - Create EC2 instance
- ✅ [terraform] - Enable communication with server using Security Groups
- ✅ [terraform] - Generate key for accessing server with SSH
- ✅ [terraform] - Extend the default storage for EC2
- ✅ [setup.sh] - Create setup.sh script, with required arguments
- ✅ [setup.sh] - Install required libs for libcod compilation, compile libcod
- ✅ [setup.sh] - Sync CoD2 files with S3
- ✅ [terraform] - Execute setup.sh script on remote machine
- ✅ [start.sh] - Create start.sh script, with required parameters
- ✅ [start.sh] - Initalize server files - copy from outside source
- ✅ [start.sh] - Add support for 1.3 version
- ✅ [start.sh] - Create structure for project
- ✅ [terraform] - Copy start.sh to remote instance
- ✅ [terraform] - Execute start.sh on remote instance
- ✅ [docker] - Run server inside Docker instead of screen
- ✅ [docker] - Install LAMP stack
- ✅ [docker] - Configure FastDL
- [libcod] - Change voron00 to zk version of libcod
