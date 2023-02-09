import os, shutil
  
cdir = os.getcwd()
orgdir = '/opt/python_class'
os.chdir(orgdir)
try:
    os.system('git checkout .')
    os.system('git pull')
    print('pulling latest class materials....')
except:
    print('could not update from git!')
os.chdir(cdir)
try:
    if os.path.exists('/home/jovyan/data/python-for-hydrology'):
        shutil.rmtree('/home/jovyan/data/python-for-hydrology')
    shutil.copytree(orgdir,'/home/jovyan/data/python-for-hydrology')
    print('Copied all class materials to /home/jovyan/data/python-for-hydrology')
except:
    raise('could not copy class materials')
