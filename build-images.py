#!/usr/bin/env python3

"""
Dependencies: GitPython, pyyaml, docker, networkx
"""

import git
import yaml
import docker
import networkx
import matplotlib.pyplot as plt

# identify files that have changed 
repo = git.Repo('.')
changed_files = repo.git.diff('HEAD~1..HEAD', name_only=True)
changed_files = changed_files.split('\n')

# read/build image dependency graph
with open('.images.yml', 'r') as f:
    imgyml = yaml.safe_load(f)

G = networkx.DiGraph()
image_names = imgyml['images'].keys()
G.add_nodes_from(image_names)

for k,v in imgyml['images'].items():
    if 'children' in v.keys():
        for child in v['children']:
            G.add_edge(k, child)


# develop build plan
edges = []
modified_nodes = []
all_nodes = list(G.nodes())

for c in changed_files:
    # this is hack but it works ;)
    dirname = c.split('singleuser')[-1].split('/')[1]

#for dirname in ['wrf_hydro', 'scientific_r']:
    if dirname in all_nodes:
        
        # mark the matching node as modified
        modified_nodes.append(dirname)

        downstream_nodes = list(networkx.algorithms.dfs_successors(G, dirname).values())
        if len(downstream_nodes) > 0:
            downstream_nodes = downstream_nodes[0]
        else:
            continue

        subgraph_edges = [(dirname, d) for d in downstream_nodes]
        edges.append(subgraph_edges)

# rebuild the graph with just the selected nodes
G2 = networkx.DiGraph()
for subgraph in edges:
    G2.add_edges_from(subgraph)
G2.add_nodes_from(modified_nodes)

build_plan = list(networkx.topological_sort(G2))

if len(modified_nodes) > 0:
    print('The following image directories contain modified files:')
    i = 1
    for img in modified_nodes:
        print(f'{i}. {img}')

    i = 1
    print('\nThe following images need to be rebuilt:')
    for img in build_plan:
        print(f'{i}. {img}')
        i += 1

