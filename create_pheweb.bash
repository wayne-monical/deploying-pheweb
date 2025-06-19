# This is the script that I used to create a PheWeb instance on my Windows machine using WSL2 and Docker.
# Once you serve the Pheweb site, you can access it at http://localhost:55000.
# I use the 55000 port instead of the default 5000 port because it works with port forwarding. 

# Install WSL2 from the Microsoft Store

# in the WSL terminal, download the necessary C libraries
sudo apt update
sudo apt install g++
sudo apt install zlib1g-dev

# install conda
# download the latest conda installer, then run
# bash Miniconda3-latest-Linux-x86_64.sh


# Create a new conda environment
conda create --name phewas_dev2 python=3.10.0
conda activate phewas_dev2
conda config --add channels conda-forge
conda install bioconda::pysam=0.22.1
pip install --use-pep517 git+https://github.com/wayne-monical/pheweb.git



## Copy data from Windows to Linux
cp -r  "/mnt/c/Users/w3mon/OneDrive/Documents/graduate school/kiryluk lab/clean_data" ~/my-new-pheweb
cp -r  "/mnt/c/Users/w3mon/OneDrive/Documents/graduate school/kiryluk lab/pheno-list.csv" ~/my-new-pheweb

# Pheweb data processing
cd my-new-pheweb
pheweb phenolist import-phenolist pheno-list.csv
pheweb process
cp '/home/wmonical/my-new-pheweb/generated-by-pheweb/tmp/pheno-list-successful-only.json' '/home/wmonical/my-new-pheweb/pheno-list.json'
pheweb process


# hosting website
pheweb serve --host 0.0.0.0 --port 55000


# Other necessary steps to host the website

# 1. Create firewall rules to allow traffic on port 55000
# powershell as admin
New-NetFirewallRule -DisplayName "Allow PheWeb 55000" -Direction Inbound -LocalPort 55000 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "Allow port 55000" -Direction Inbound -LocalPort 55000 -Protocol TCP -Action Allow


# 2. Forward traffic from Windows to WSL2
# get your WSL2 IP address
ip addr | grep eth0ep eth0 # inet 172.22.138.62/20 brd 172.22.143.255 scope global eth0
# forward traffic from Windows to WSL2
netsh interface portproxy add v4tov4 listenport=55000 listenaddress=0.0.0.0 connectport=55000 connectaddress=172.22.138.62

#  3. Set up port forwarding from your router to your computer's IP address



# Using Docker to host PheWeb
# Install Docker Desktop for Windows
# Enable WSL2 integration in Docker Desktop settings

# create a new directory for the Dockerfile
mkdir pheweb_docker2

# copy data to the new directory
cp -r ~/my-new-pheweb pheweb_docker2

# create a Dockerfile in the new directory
# create an environment.yml file in the new directory

# build the docker container
cd pheweb_docker2
docker build -t pheweb_docker2 .

# run the container 
docker run -p 55000:55000 pheweb_docker2



# Debugging
# Check that pheweb is running locally at http://localhost:55000
# If this step fails, then Pheweb is not running correctly.

# Check that the website is available at the WSL2 windows address at http://172.22.138.62:55000/
# If this step fails, then 

# Check that the website is available at the Windows address http://192.168.0.104:55000/

# Check that the website is available at the public IP address of your router http://67.250.183.56:55000/








