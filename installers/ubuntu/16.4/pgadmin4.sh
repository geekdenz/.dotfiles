#!/bin/bash
sudo apt-get install -y virtualenv python-pip libpq-dev python-dev
cd
virtualenv pgadmin4
cd pgadmin4
source bin/activate

wget https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v1.4/pip/pgadmin4-1.4-py2.py3-none-any.whl

pip install pgadmin4-1.4-py2.py3-none-any.whl
echo "SERVER_MODE = False" >> lib/python2.7/site-packages/pgadmin4/config_local.py
echo "#!/bin/bash
source bin/activate
python lib/python2.7/site-packages/pgadmin4/pgAdmin4.py" > run.bash
chmod +x run.bash
