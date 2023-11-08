function showshow(D,A,DM)
figure(1111)
M = size(D.objs,2);
eM = M/DM;
for i = 1:DM
    DOBJS=D.objs;
    objs = DOBJS(:,(i-1)*eM+1:i*eM);
    subplot(1,DM,i)
    hold off
    if eM ==2
        plot(objs(:,1),objs(:,2),'black*')
    else
        plot3(objs(:,1),objs(:,2),objs(:,3),'black*')
    end
end
for i = 1:DM
    DOBJS=A.objs;
    objs = DOBJS(:,(i-1)*eM+1:i*eM);
    subplot(1,DM,i)
    hold on 
    if eM ==2
        plot(objs(:,1),objs(:,2),'red*')
    else
        plot3(objs(:,1),objs(:,2),objs(:,3),'red*')
    end
    hold off
end
end