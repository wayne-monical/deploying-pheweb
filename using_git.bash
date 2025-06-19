conda activate phewas_dev3
conda isntall git

git clone https://github.com/wayne-monical/deploying-pheweb.git

cd deploying-pheweb

git config --global user.email "wem2121@cumc.columbia.edu"
git config --global user.name "wayne-monical"

# authentication
git config --global credential.helper cache
