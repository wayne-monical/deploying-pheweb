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

# OR clean data with the data_preprocessing.ipynb

# Copy data to the correct directory
rm -rf ~/deploying-pheweb/pheweb_docker2/my-new-pheweb/clean_data
cp -r ~/deploying-pheweb/data_preprocessing/clean_data ~/deploying-pheweb/pheweb_docker2/my-new-pheweb

# creating the pheno-list.json directly
#cp -r ~/deploying-pheweb/data_preprocessing/pheno-list.csv ~/deploying-pheweb/pheweb_docker2/my-new-pheweb
cp -r ~/deploying-pheweb/data_preprocessing/pheno-list.json ~/deploying-pheweb/pheweb_docker2/my-new-pheweb

# Pheweb data processing
cd my-new-pheweb

# Import the phenolist from a csv file
# pheweb phenolist import-phenolist pheno-list.csv

# read num_cases and num_controls from the association files, but they all need to be the same
pheweb phenolist read-info-from-association-files
pheweb process
cp '/home/wmonical/my-new-pheweb/generated-by-pheweb/tmp/pheno-list-successful-only.json' '/home/wmonical/my-new-pheweb/pheno-list.json'
pheweb process


## Using FINNGEN's PheWeb
conda create --name phewas_dev4 python=3.11.0
conda activate phewas_dev4
conda config --add channels conda-forge
conda install bioconda::pysam=0.22.1
conda install mysqlclient 
pip install --use-pep517 git+https://github.com/FINNGEN/pheweb.git
pip install --use-pep517 git+https://github.com/FINNGEN/pheweb.git@upgrade_deps.al
mkdir ~/my-new-pheweb2
mkdir ~/my-new-pheweb2/clean_data
cp -r ~/deploying-pheweb/data_preprocessing/clean_data ~/my-new-pheweb2/
cp -r ~/deploying-pheweb/data_preprocessing/pheno-list.json ~/my-new-pheweb2
cd my-new-pheweb2



# hosting website
pheweb serve --host 0.0.0.0 --port 55000


# Other necessary steps to host the website

# 1. Create firewall rules to allow traffic on port 55000
# powershell as admin
New-NetFirewallRule -DisplayName "Allow PheWeb 55000" -Direction Inbound -LocalPort 55000 -Protocol TCP -Action Allow

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


# save the file
docker save inspiring_cartwright -o pheweb-docker.tar

# zip the file
zip pheweb-docker.zip pheweb-docker.tar


# copy the exported container to Windows
cp ~/pheweb-docker.zip "/mnt/c/Users/w3mon/OneDrive/Documents/graduate school/kiryluk lab"


# unzip the file

# load the docker image
docker load --input pheweb-docker.tar


# Debugging
# Check that pheweb is running locally at http://localhost:55000
# If this step fails, then Pheweb is not running correctly.

# Check that the website is available at the WSL2 windows address at http://172.22.138.62:55000/
# Check that the website is available at the Windows address http://192.168.0.104:55000/
# If either of these step fails, then it's the firewall or Windows needs to forward traffic to WSL2.

# Check that the website is available at the public IP address of your router http://67.250.183.56:55000/
# If this step fails, then port forwarding is not set up correctly.



## Developing PheWeb

# 1. Clone the PheWeb repository
git clone https://github.com/wayne-monical/pheweb

cd pheweb

# 2.  Install the local PheWeb repository in editable mode for development
pip install --use-pep517 -e .

# 3. Do Development

# 4. Test
pytest



# 5. create test folder
cp ~/deploying-pheweb/data_preprocessing/clean_data/dermatophytosis_of_the_body.csv pheweb-test/clean_data/dermatophytosis_of_the_body.csv
cp ~/deploying-pheweb/data_preprocessing/clean_data/clean_data/dermatophytosis.csv pheweb-test/clean_data/clean_data/dermatophytosis.csv
cp ~/deploying-pheweb/data_preprocessing/clean_data/clean_data/dermatophytosis_of_nail.csv pheweb-test/clean_data/clean_data/dermatophytosis_of_nail.csv
cp ~/deploying-pheweb/data_preprocessing/clean_data/althetes_foot.csv pheweb-test/clean_data/althetes_foot.csv
cp ~/deploying-pheweb/data_preprocessing/clean_data/dermatomycoses.csv pheweb-test/clean_data/dermatomycoses.csv
cp ~/deploying-pheweb/data_preprocessing/clean_data/candidiasis.csv pheweb-test/clean_data/candidiasis.csv
cp ~/deploying-pheweb/data_preprocessing/clean_data/candidiasis_of_skin_and_nails.csv pheweb-test/clean_data/candidiasis_of_skin_and_nails.csv