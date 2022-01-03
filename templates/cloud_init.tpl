#cloud-config
repo_update: true
repo_upgrade: security
packages:
  - python-pip
runcmd:

  - amazon-linux-extras install docker -y
  - yum install docker jq git -y
  - service docker start
  - usermod -a -G docker ec2-user
  - curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
  - chmod +x /usr/local/bin/docker-compose
  - mkdir test
  - cd test
  - curl -L https://raw.githubusercontent.com/laravel/laravel/8.x/.env.example -o .env
  - docker run --rm -v "$(pwd)":/opt  -w /opt laravelsail/php80-composer:latest bash -c "laravel new ml-demo-meetup && cd ml-demo-meetup && php ./artisan sail:install --with=mysql"
  - curl -L https://raw.githubusercontent.com/zpol/toolkits/main/laravel_docker_fix.sh -o laravel_docker_fix.sh
  - chmod +x laravel_docker_fix.sh
  - ./laravel_docker_fix.sh
  - chmod -R 777 storage
  - docker-compose up -d

