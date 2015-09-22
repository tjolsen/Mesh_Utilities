lc = 0.05;

// Geometry Boundary
Point(1) = {0,0,0,lc};
Point(2) = {1,0,0,lc};
Point(3) = {1,.5,0,lc};
Point(4) = {1,1,0,lc};
Point(5) = {0,1,0,lc};
Point(6) = {0,.5,0,lc};
Line(1) ={1,2};
Line(2) ={2,3};
Line(3) ={3,4};
Line(4) ={4,5};
Line(5) ={5,6};
Line(6) ={6,1};

// Crack Geometry
Point(7) = {.25,.5,0,lc};
Point(8) = {.75,.5,0,lc};

Line(7) = {6,7}; // <-- dummy divider
Line(8) = {7,8}; // <-- crack
Line(9) = {8,3}; // <-- dummy divider

//Make line loops and surfaces
Line Loop(1) = {1,2,-9,-8,-7,6}; // Bottom half
Line Loop(2) = {3,4,5,7,8,9}; // Top half
Plane Surface(1) = {1};
Plane Surface(2) = {2};

//Assign physical IDs (numbers picked just so they will be obvious in .msh file)
Physical Surface(100) = {1}; // bottom will have ID 100
Physical Surface(101) = {2}; // top will have ID 101
Physical Line(10) = {8}; // crack will have ID 10

// more physical ids on top and bottom for boundary conditions in a solver
Physical Line(1) = {1};
Physical Line(2) = {4};