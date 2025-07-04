# Deploying Pheweb

This repository contains the code for cleaning and deploying a pheweb website. The data preprocessing folder contains the necessary code for formatting the files appropriately. creating_pheweb.bash gives the code for installing pheweb, running pheweb, and creating a docker container to transport pheweb. The pheweb_docker2 folder has the appropriate docker files. 


# Deploying Pheweb with Port Forwarding

This is the code that I used to deploy the Pheweb package. Since I am on a windows machine, I used Windows Subsystem for Linux to run a linux environment, where I installed conda to create a virtual python environment, from which I ran the pheweb code. 

1. Install WSL2 from the Microsoft Store
2. In the WSL terminal, install the necessary C libraries for Pheweb

```
sudo apt update
sudo apt install g++
sudo apt install zlib1g-dev 
```

3. Install conda by downloading the latest conda installer, then run the following code

```
bash Miniconda3-latest-Linux-x86_64.sh 
```

4. Create a new conda environment for pheweb

```
conda create --name phewas_dev2 python=3.10.0 
```

5. Install your preferred version of pheweb. 

```
conda activate phewas_dev2
conda config --add channels conda-forge
conda install bioconda::pysam=0.22.1
pip install --use-pep517 git+https://github.com/wayne-monical/pheweb.git 
```


6. Copy data from the Windows file system to the Linux file system

7. Create a directory for the pheweb project. Assemble the the association files as csvs and the pheno-list file as a csv or as a json in the directory. To import the pheno-list from a csv, run the following command in the pheweb directory.

```
pheweb phenolist import-phenolist pheno-list.csv
```


7.1 Optionally, read the number of cases and controls from the association files.

```pheweb phenolist read-info-from-association-files
```

8. Run the following command to create the website. This step downloads a large amount of data and takes a very long time to run. 

```
pheweb process
```

9. To view the website, run the following command. I reccomend hosting at the 55000 port as opposed to the default 5000 port, because the 5000 port was blocked by my ISP. The website will be viewable by you (but not anyone else) at http://localhost:55000.

```
pheweb serve --host 0.0.0.0 --port 55000
```

10. Publishing the Website with Port Forwarding

When a member of the public attempts to access your website, they will do so by accessing a port of your public IP address, given by your router. Your router will need to forward the traffic to your computer. If you are using WSL, Windows will need to forward the traffic to WSL, since they have separate IP addresses. In order to make the website accessible by the public, you must take (and debug) the following steps. 

10.1. Create firewall rules to allow traffic on port 55000. In powershell as an admin, run the following command to allow traffic through the firewall at the 55000 port. 

```
New-NetFirewallRule -DisplayName "Allow PheWeb 55000" -Direction Inbound -LocalPort 55000 -Protocol TCP -Action Allow
```

10.2. Forward traffic from Windows to WSL2

```
# get your WSL2 IP address
ip addr | grep eth0ep eth0 # inet 172.22.138.62/20 brd 172.22.143.255 scope global eth0

# forward traffic from Windows to WSL2
netsh interface portproxy add v4tov4 listenport=55000 listenaddress=0.0.0.0 connectport=55000 connectaddress=172.22.138.62
```

10.3. Set up port forwarding from your router to your computer's IP address. Varies by router. 


# Debugging Port Forwarding

1. Check that pheweb is running locally at http://localhost:55000. If this step fails, then Pheweb is not running correctly. Check that you have set the correct port. 

2. Check that the website is available at the WSL2 windows address at http://<WSL2Address>:55000/. Check that the website is available at the Windows address http://<WindowsIPAddress>:55000/. If either of these step fails, then it's the firewall or Windows needs to forward traffic to WSL2.

3. Check that the website is available at the public IP address of your router http://<RouterAddress>:55000/. If this step fails, then port forwarding is not set up correctly.



# Containerizing Pheweb

1. Install Docker Desktop for Windows.

2. Enable WSL2 integration in Docker Desktop settings.

3. Create a new directory for the Dockerfile and copy over data from your pheweb deployment.

```
mkdir pheweb_docker2
cp -r ~/my-new-pheweb pheweb_docker2
```

4. Create a Dockerfile and environment.yml file in the new directory. See the files in this repo for example.

5. Build the docker container

```
cd pheweb_docker2
docker build -t pheweb_docker2 .
```

6. Run the container. 

```docker run -p 55000:55000 pheweb_docker2
```

7. Export the container
```
docker save inspiring_cartwright -o pheweb-docker.tar
```



# Developing PheWeb

1. Create and activate a new conda environment.

```
conda activate phewas_dev3
```

2. Fork the pheweb directory, then clone it to your machine. 

```
git clone https://github.com/<YourGithubUsername>/pheweb
```


3.  Install the local PheWeb repository in editable mode for development.

```
cd pheweb
pip install --use-pep517 -e .
```


# 4. Test

```
pytest
```


```
# this file is way too big. We have to delete it
ls -lh ~/deploying-pheweb/pheweb_docker2/my-new-pheweb/generated-by-pheweb/resources/rsids-v154-hg19.tsv.gz

 This is the script that I used to create a PheWeb instance on my Windows machine using WSL2 and Docker.
# Once you serve the Pheweb site, you can access it at http://localhost:55000.
# I use the 55000 port instead of the default 5000 port because it works with port forwarding. 

# Install WSL2 from the Microsoft Store




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
```
