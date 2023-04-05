**Work in progress - see roadmap at the bottom**

# Motivation

Setting up Call of Duty 2 server requires a lot of configuration and can be a pain. Use this repo to automate process of provisioning and configuring. It utilizes terraform and creates EC2 instance then deploys desired CoD2 servers on it.

Thanks a lot to whole [killtube.org](https://killtube.org/) community for open-source developing. This repository uses/installs following projects:
- [voron00/libcod](https://github.com/voron00/libcod)
- [Lonsofore/cod2install](https://github.com/Lonsofore/cod2install)
- [ibuddieat/zk_libcod](https://github.com/ibuddieat/zk_libcod)

# Pre-requirements

- terraform CLI
- AWS account (`aws_access_key_id` + `aws_secret_access_key` with S3 reader permission) 
- CoD2 server files uploaded to S3

```
S3 bucket
├── 1_0
│   ├── iw_00.iwd
│   ├── iw_01.iwd
│   ├── (...)
│   ├── iw_14.iwd
│   ├── localized_english_iw00.iwd
│   ├── localized_english_iw01.iwd
│   ├── (...)
│   └── localized_english_iw11.iwd
└── 1_3
    ├── iw_15.iwd
    └── localized_english_iw11.iwd
```

# Usage

```sh
# Provision required resources
terraform apply

# SSH connect to the created server
./scripts/connect.sh

# Setup
cd ~/setup && ./start.sh --mysql_password=example --user_name=cod --user_password=example --aws_access_key_id=example --aws_secret_access_key=example --s3_bucket_name=example
```

# Roadmap

- ✅ [terraform] - Create EC2 instance
- ✅ [terraform] - Enable communication with server using Security Groups
- ✅ [terraform] - Generate key for accessing server with SSH
- ✅ [terraform] - Extend the default storage for EC2
- ✅ [setup.sh] - Create setup.sh script, with required arguments
- ✅ [setup.sh] - Install required libs for libcod compilation, compile libcod
- [setup.sh] - Install LAMP stack, unlock required ports
- [setup.sh] - Install screen
- ✅ [setup.sh] - Sync CoD2 files with S3
- [setup.sh] - Create user
- [setup.sh] - Install FTP client for server management
- ✅ [terraform] - Execute setup.sh script on remote machine
- [server.sh] - Create server.sh script, with required parameters
- [server.sh] - Create startup script and add to CRON
- [server.sh] - Create links to server files
- [server.sh] - Create FTP user
- [server.sh] - Create structure for project
- [terraform] - Copy server.sh to remote instance
- [docker/idea] - Run server inside Docker instead of screen
- [idea] - Use zk_libcod
