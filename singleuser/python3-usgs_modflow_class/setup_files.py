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
    if os.path.exists('./data/python_class'):
    	shutil.rmtree('./data/python_class')
    shutil.copytree(orgdir,'./data/python_class')
    print('Copied all class materials to /home/jovyan/data')
except:
    raise('could not copy class materials')