# 🌎 Motivation

Setting up Call of Duty 2 server requires a lot of configuration and can be a pain. Use this repo to automate process of provisioning and configuring. It utilizes terraform and creates EC2 instance then deploys desired CoD2 servers.

The CoD2 server will be launched inside docker. The docker image used is maintained here: [cod2-docker](https://github.com/rutkowski-tomasz/cod2-docker).

Thanks a lot to whole [killtube.org](https://killtube.org/) community for open-source developing. 🥰

# 🚀 Features

1. Creates key pair and stores locally
2. Configures AWS security groups
3. Creates EC2 instance
4. Performs initalization on provided machine
5. Installs required packages like: aws cli, unzip
6. Setups docker engine and docker-compose
7. Creates structure for CoD2 servers
8. Syncs S3 bucket with CoD2 server files
9. Setups files so you can run either 1.0, 1.2 and 1.3 version
10. Provides docker-compose files
11. Starts reverse-proxy
12. Configures CoD2 FastDL for reverse-proxy
13. Starts MySQL server
14. Starts PHPMYADMIN service
15. Starts sample CoD2 server

# 📝 Pre-requirements

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

# 🤷🏻‍♂️ How to use?

You have two options:

**Option A**: You have nothing set up - provide whole insfrastructure, install required packages, configure, deploy and run CoD2 servers.

**Option B**: You already have clean VPS machine - do everything above without creating new infrastructure

## 😌 Option A: CoD2 as code approach

```sh
terraform apply # See description below

# SSH connect to the created server
./scripts/connect.sh
```

To get the reverse-proxy (fastdl and phpmyadmin) working remember to configure DNS A record for subdomains `fastdl.yourdomain.com` and `pma.yourdomain.com`.

## 🖥️ Option B: Configure existing VPS

1. Create key for accessing server (skip if already exists)
```sh
SERVER=51.68.142.183
KEYNAME=mykey

ssh-keygen -t ed25519 -b 2048 -f ~/.ssh/$KEYNAME -N "" # Generate the key
ssh-copy-id -i ~/.ssh/$KEYNAME.pub ubuntu@$SERVER # Copy the key to the machine
```

2. Upload the necessary scripts on the machine
```sh
sudo scp -r -i ~/.ssh/$KEYNAME ./setup/* ubuntu@$SERVER:~
```

Expected structure:
```
/home/ubuntu
├── lamp
│   ├── docker-compose.yml.envsubst
│   └── html
│       └── index.php
├── reverse-proxy
│   ├── docker-compose.yml
│   └── nginx.conf.envsubst
├── scripts
│   ├── parts
│   │   ├── cod2.sh
│   │   ├── envsubst.sh
│   │   └── requirements.sh
│   └── start.sh
└── servers
    └── nl-example
        ├── nl
        │   ├── sample_fx.iwd
        │   └── server.cfg.envsubst
        └── docker-compose.yml
```

3. Run following commands

```sh
ssh -i ~/.ssh/$KEYNAME ubuntu@$SERVER # Connect to the machine

# Run the setup script
# !! Remember to adjust your variables
~/scripts/start.sh \
    --mysql_root_password=changemeplease \
    --aws_access_key_id=AAAAAAAAAAAAAAAAAAAA \
    --aws_secret_access_key=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX \
    --s3_bucket_name=s3://cod2-server-files \
    --s3_bukcet_region=eu-central-1 \
    --domain=yourdomain.com
```

To get the reverse-proxy (fastdl and phpmyadmin) working remember to configure DNS A record for subdomains `fastdl.yourdomain.com` and `pma.yourdomain.com`.

# 🆕 Updating or creating CoD2 servers

You can use this repo also for creating new servers and uploading the newest version of your mod. Let's say you want to update nl-example server. Place all the files that you want inside `setup/servers/nl-example`. Then run the command `./scripts/sync_server.sh nl-example`

# 🛣️ Roadmap

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
- ✅ [sync_server.sh] - Create script for syncing new version of server
- ✅ [libcod] - Change voron00 to zk version of libcod
- ✅ [docker] - Install reverse-proxy, add subdomain configuration for FastDL and phpmyadmin
- ✅ [start.sh] - Dynamic domain setup
