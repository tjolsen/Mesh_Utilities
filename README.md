Mesh Utilities
==============

This is a small collection of scripts/programs that I have written
in response to questions on scicomp.stackexchange that concern the
creation and manipulation of finite element meshes. Currently,
there are utilities to:

- Inject a crack into a 2D gmsh mesh, inserting zero-thickness quads
at the crack location (https://scicomp.stackexchange.com/questions/20795/using-gmsh-to-create-a-mesh-with-zero-thickness-quad-interface-elements)
- Refine a 2D linear triangle mesh into a mesh of straight-sided 6-node triangles
(https://scicomp.stackexchange.com/questions/27822/quadratic-trial-functions-for-a-2d-fem-calculation)
