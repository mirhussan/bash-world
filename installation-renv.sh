Installation Steps Ruby on rail in ubuntu OS
       - sudo apt-get update && sudo apt-get install -y git gcc bzip2 libssl-dev libreadline-dev zlib1g-dev

Installation Steps Ruby on Rail in EC2 / Redhat / Fedora / Alma 
       - sudo yum update && yum groupinstall "Development Tools"  && sudo yum install -y openssl-devel readline-devel zlib-devel  bzip2-devel libffi-devel libyaml-devel  libxml2-devel libxslt-devel
        ==> For postgres db we need to install following package
           - sudo yum install postgresql-devel

       - curl -fsSL https://github.com/rbenv/rbenv-installer/raw/main/bin/rbenv-installer | bash
       - export PATH="$HOME/.rbenv/bin:$PATH"
       - eval "$(rbenv init -)"
       - rbenv install 3.2.2
       - rbenv global 3.2.2
       - ruby -v
       - gem install bundler
       - bundle install
