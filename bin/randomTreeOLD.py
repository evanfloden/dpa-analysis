'''                                                                                                                      
Input:  Newick tree file                                                                  
Output: Newick tree file with the same structure but with the leaves shuffled randomly
        The output tree has .rnd extention added
'''                                                                                                                      
#!/usr/bin/python                                                                                                        
from Bio import Phylo
from StringIO import StringIO

import sys
import random
import re    # regular expresion
import copy  # deep copy
import os    #file

sys.setrecursionlimit(5500)

arg1   = sys.argv[1]
argOut = arg1+".rnd"                     #add output format

tree = Phylo.read(arg1, 'newick')
treeResult = Phylo.read(arg1, 'newick')
        
leavesRandom = list(tree.get_terminals())                     #copy by values
i = 0
random.shuffle(leavesRandom)

for leaf in treeResult.get_terminals() :
	leaf.name = leavesRandom[i].name
        i= i+1

Phylo.write(treeResult,argOut, 'newick')
