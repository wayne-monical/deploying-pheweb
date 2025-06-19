# install conda
# download the latest conda installer, then run
# bash Miniconda3-latest-Linux-x86_64.sh



# install PheWeb in a new conda environment
conda create --name phewas_dev python=3.8.20
conda activate phewas_dev
conda install -c conda-forge pysam


# tricky dependencies
conda install -c conda-forge libgcc=13     
conda install -c conda-forge python_abi=3.10  
conda install -c conda-forge libzlib=1.3.1    

c

conda install bioconda::pysam=0.23.0
conda install bioconda::pysam=0.22.1



# trying 2nd time
conda create --name phewas_dev2 python=3.10.0
conda activate phewas_dev2
conda config --add channels conda-forge
conda install bioconda::pysam=0.22.1
pip install --use-pep517 git+https://github.com/veetir/pheweb.git



# trying 3rd time
conda create --name phewas_dev3 python=3.8.20
conda activate phewas_dev3



# install problematic PheWeb dependencies   
conda install bioconda::pysam~=0.16
conda install setuptools~=75.3

# friendly dependencies
conda install Flask~=1.1
conda install Flask-Compress~=1.8
conda install Flask-Login~=0.5
conda install rauth~=0.7
conda install intervaltree~=3.1
conda install tqdm~=4.56
conda install scipy~=1.5
conda install numpy~=1.19
conda install requests[security]~=2.25
conda install gunicorn~=20.0.4
conda install boltons~=20.2
conda install cffi~=1.15
conda install wget~=3.2
conda install gevent~=21.1
conda install psutil~=5.8
conda install markupsafe==2.0.1

# in the WSL terminal
sudo apt update
sudo apt install g++

# pip install git+https://github.com/statgen/pheweb.git

pip install --use-pep517 git+https://github.com/statgen/pheweb.git
pip install git+https://github.com/wayne-monical/pheweb.git

conda install mysqlclient=2.0.1
conda install pip=23.0
pip install --use-pep517  git+https://github.com/FINNGEN/pheweb.git


# 4th try
conda activate phewas_dev2
conda install conda=23.1.0
conda install mysqlclient
conda install pip=23.0
pip install --use-pep517 git+https://github.com/FINNGEN/pheweb.git@upgrade_deps.al

#5th try
conda create --name phewas_dev5 python=3.13.0
conda activate phewas_dev5
pip3 install mysqlclient
pip3 install pandas~=1.5.3
pip3 install git+https://github.com/FINNGEN/pheweb.git@upgrade_deps.al

## 6th try
conda activate phewas_dev2
conda install pandas=1.5.3
pip3 install --use-pep517 --no-build-isolation git+https://github.com/FINNGEN/pheweb.git@upgrade_deps.al


## 7th try
git clone --branch upgrade_deps.al --single-branch https://github.com/FINNGEN/pheweb.git
cd pheweb
pip install --use-pep517 pheweb

## 8th try 
# https://github.com/statgen/pheweb/blob/master/etc/detailed-install-instructions.md
python3 -m pip install -U cython wheel pip setuptools   

# need to update ubuntu compiler libraries
sudo apt update
sudo apt install zlib1g-dev

# final install
git clone  https://github.com/wayne-monical/pheweb.git
pip install --use-pep517 /home/wmonical/pheweb



## Copy data from Windows to Linux
cp -r  "/mnt/c/Users/w3mon/OneDrive/Documents/graduate school/kiryluk lab/clean_data" ~/my-new-pheweb
cp -r  "/mnt/c/Users/w3mon/OneDrive/Documents/graduate school/kiryluk lab/pheno-list.csv" ~/my-new-pheweb


cd my-new-pheweb
pheweb phenolist import-phenolist pheno-list.csv
pheweb process
cp '/home/wmonical/my-new-pheweb/generated-by-pheweb/tmp/pheno-list-successful-only.json' '/home/wmonical/my-new-pheweb/pheno-list.json'
pheweb process


## hosting website
cd ~/my-new-pheweb
conda activate phewas_dev3
pheweb serve --host 0.0.0.0 --port 5000



# more tinkering
curl -H "Host: 67.250.183.56:5000" http://localhost:5000


# trying to forward traffic to WSL
ip addr | grep eth0ep eth0

# powershell as admin (This actually worked, unbeliably)
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=5000 connectaddress=172.22.138.62 connectport=5000

## Trying ngrok
# install ngrok 
docker pull ngrok/ngrok
docker run --rm -it --network="host" ngrok/ngrok config add-authtoken 2y8q2TMRuEklqm7vQqRDiCnllq4_9jRoiReiBaPjyN9ZsXjY
docker run --rm -it --network="host" ngrok/ngrok http 5000

docker run --rm -it ngrok/ngrok config add-authtoken 2y8q2TMRuEklqm7vQqRDiCnllq4_9jRoiReiBaPjyN9ZsXjY


sudo mkdir -p ~/.ngrok2

# fixed permissions
sudo chown -R $USER:$USER ~/.ngrok2
chmod 700 ~/.ngrok2

sudo echo "authtoken: 2y8q2TMRuEklqm7vQqRDiCnllq4_9jRoiReiBaPjyN9ZsXjY" > /home/wmonical/.ngrok2/ngrok.yml


docker run --rm -it \
  --network="host" \
  -v ~/.ngrok2:/home/ngrok/.config/ngrok \
  ngrok/ngrok http 5000


## local tunner 
sudo npm install -g localtunnel
sudo lt --port 5000 --subdomain pheweb101


### but local tunnel goes down after 30 minutes


## trying cloudflared
sudo apt install cloudflared

# have to create a cloudflare account
cloudflared tunnel login
cloudflared tunnel --url http://localhost:5000


# 
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared-linux-amd64.deb
cloudflared tunnel --url http://localhost:5000


# 
sudo apt install pagekite
pagekite 5000 yourname.pagekite.me




## Trying with a large port 
pheweb serve --host 0.0.0.0 --port 55000

# powershell as admin
New-NetFirewallRule -DisplayName "Allow PheWeb 55000" -Direction Inbound -LocalPort 55000 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "Allow port 55000" -Direction Inbound -LocalPort 55000 -Protocol TCP -Action Allow

# get WSL IP
ip addr show eth0 | grep inet # inet 172.22.138.62/20 brd 172.22.143.255 scope global eth0
# local address is accessible from http://172.22.138.62:55000/


# make new docker file
# remove the pheweb_docker2/my-new-pheweb directory
rm -rf pheweb_docker2/my-new-pheweb

# copy pheweb_docker/my-new-pheweb to pheweb_docker2/my-new-pheweb
cp -r pheweb_docker/my-new-pheweb pheweb_docker2/my-new-pheweb

# build the docker container
cd pheweb_docker2
docker build -t pheweb_docker2 .

# run the container 
docker run -p 55000:55000 pheweb_docker2


# I need to connect WSL2 to Windows
# command prompt as admin
netsh interface portproxy add v4tov4 listenport=55000 listenaddress=0.0.0.0 connectport=55000 connectaddress=172.22.138.62





