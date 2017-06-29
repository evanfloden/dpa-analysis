'''                                                                                                                      
Input: Newick file (tree extension) with a newick file                                                                   
Output: Newick file '_random.treet' with a new tree, with the same structure but with the leaves shuffled in a random way
'''                                                                                                                      
#!/usr/bin/python                                                                                                        
from Bio import Phylo
from StringIO import StringIO

import sys
import random
import re                                                               #regular expresion
import copy                                                             #deep copy
import os                                                               #file

sys.setrecursionlimit(5500)

arg1= sys.argv[1]
arg = re.sub('.co.ref.dnd', '', arg1)         #remove extension
argOut = arg+".co.ref.randomtree.dnd"                     #add output format

tree = Phylo.read(arg1, 'newick')
treeResult = Phylo.read(arg1, 'newick')
        
leavesRandom = list(tree.get_terminals())                     #copy by values
i = 0

random.shuffle(leavesRandom)

#recorrer el tree y modificar con el randomList
for leaf in treeResult.get_terminals() :
	leaf.name = leavesRandom[i].name
        i= i+1

print(arg+'\t>> New ref random Tree')
Phylo.write(treeResult,argOut, 'newick')
