import os, shutil
  
cdir = os.getcwd()
orgdir = '/opt/iah2021-brazil-mf6'
os.chdir(orgdir)
try:
    os.system('git checkout .')
    os.system('git pull')
    print('pulling latest class materials....')
except:
    print('could not update from git!')
os.chdir(cdir)
try:
    if os.path.exists('./data/iah2021-brazil-mf6'):
    	shutil.rmtree('./data/iah2021-brazil-mf6')
    shutil.copytree(orgdir,'./data/iah2021-brazil-mf6')
    print('Copied all class materials to /home/jovyan/data')
except:
    raise('could not copy class materials')