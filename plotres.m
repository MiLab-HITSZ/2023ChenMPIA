function plotres(bulid_xyz,bulid_height,t,titlestr,Risk_map)
figure()
hold on 
mybar3(bulid_xyz);
for i=1:numel(t)
    plot3(t{i}(:,1),t{i}(:,2),t{i}(:,3),'Color','#A2AB28','LineStyle','-','Marker','o','LineWidth',1.5);
end
colormap('jet')
contourf(Risk_map)
colorbar;
xlim([0 50])
ylim([0 50])
zlim([0 max(bulid_height)+10])
xlabel('X(unit/100m)');
ylabel('Y(unit/100m)');
zlabel('Z(unit/1m)');
title(titlestr)
end 