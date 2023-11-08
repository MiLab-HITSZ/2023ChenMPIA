function mybar3(bulid_xyz)
for i = 1:size(bulid_xyz,1)
    for j = 1:size(bulid_xyz,2)
        if bulid_xyz(i,j)>0
            PlotCuboid([i-0.5,j-0.5,0],[1,1,bulid_xyz(i,j)]);
        end
    end
end
end
function PlotCuboid(originPoint,cuboidSize)
vertexIndex=[0 0 0;0 0 1;0 1 0;0 1 1;1 0 0;1 0 1;1 1 0;1 1 1];
vertex=originPoint+vertexIndex.*cuboidSize;
facet=[1 2 4 3;1 2 6 5;1 3 7 5;2 4 8 6;3 4 8 7;5 6 8 7];
color=[1;2;3;4;5;6;7;8];
patch('Vertices',vertex,'Faces',facet,'FaceColor','#36907E');
end