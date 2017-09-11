function [QT,Points] = linear_to_quadratic(t,p)
% LINEAR_TO_QUADRATIC
%  
% Refine a linear triangle mesh to a quadratic triangle mesh, following a
% reasonably conventional node ordering (pardon my ASCII art...). The code
% is developed in response to a question on scicomp.stackexchange.com:
% https://scicomp.stackexchange.com/questions/27822/quadratic-trial-functions-for-a-2d-fem-calculation
%
%
% 3
% |  \
% |     \
% |       \
% 5          4
% |             \
% |                \
% |                   \
% 1----------6-----------2
%
%
%
% - Iputs:
%    - p: Coordinates of points in linear mesh (np x 2)
%    - t: connectivity of linear mesh (nt x 3)
%
% - Outputs:
%    - QT: Connectivity of quadratic triangles (first three of each tri are
%          same as linear mesh)
%    - Points: All point coordinates (including inserted points)
%
%
% License: This code is free to use/modify, subject to an MIT license. If
% you find it helpful, feel free to drop me a line and say so!
% This code is hosted on my personal github page: https://github.com/tjolsen


nt = size(t,1);
t_idx = (1:nt)';


% Edge structures:
% - Four columns: edge(i,:) = [nodeA, nodeB, leftTri, rightTri]
% - During construction, also keep the local face number (i.e. local face 1
% is across the triangle from local node 1, etc) in column 5
all_edges = [t(:,1) t(:,2) t_idx t_idx 3*ones(nt,1);
    t(:,2) t(:,3) t_idx t_idx 1*ones(nt,1);
    t(:,3) t(:,1) t_idx t_idx 2*ones(nt,1)];

%Edges are directed so edges(i,1) < edges(i,2)
forward_edges = all_edges(:,2) > all_edges(:,1);
all_edges(forward_edges,4) = 0;
all_edges(~forward_edges,3) = 0;

%Flip "backward" edges
all_edges(~forward_edges,[1,2]) = all_edges(~forward_edges,[2,1]);

% Pull out the unique edges, collapsing duplicates. Edges now have pointers
% to the left-hand and right-hand triangles in columns 3 and 4.
[unique_edges,~,ic] = unique(all_edges(:,[1,2]), 'rows');
Edges = [unique_edges, accumarray(ic, all_edges(:,3),[],@sum), accumarray(ic, all_edges(:,4),[],@sum)];

% Create an array that maps a triangle index to the new Edge index (with
% the sign indicating orientation of the edge w.r.t. the local triangle.
% The sign isn't useful here, but I'm recycling some code that I wrote for
% a DG code, so the internal face orientation is very important there...
t2f = accumarray([all_edges(:,3)+all_edges(:,4),all_edges(:,5)], sign(all_edges(:,3) - all_edges(:,4)).*ic, [], @sum);


% Key idea: We are inserting one new point per edge, so the total number of
% new points is "size(Edges,1)", and their indices are: 
% (size(p,1) +1):(size(p,1) + size(Edges,1).
% In addition, the new points are being inserted at the midpoint of each
% edge. Since no description of geometry is available, they cannot be
% projected to the boundary of a curved geometry (though this is not hard
% to do, provided that a level set function is given).
newPoints = [(p(Edges(:,1),1)+p(Edges(:,2),1))/2, (p(Edges(:,1),2)+p(Edges(:,2),2))/2];
Points = [p; newPoints];

% Make the quadratic triangle connectivity according to the conventions in
% the comments.
np = size(p,1);
QT = [t, np+(abs(t2f))];
end