import sys
import os


currentDir = os.path.dirname(sys.argv[0])
libDir = os.path.join(currentDir, "lib")
print(currentDir)
sys.path.append(libDir)
os.environ['path'] += ';./lib'
