function plotMeanStd(x,y,more,less,rgb, rotated)
%
% If rotated==1 it will render x vs. y with x+less x-less as boundry
% If rotated==0 it will render x vs. y with y+less y-less as boundry
% Example:
% x=[-1:0.05:1];  y=sin(x*2); dev = abs(sin(x+0.5)*0.1)*3;
% plotMeanStd(x,y,dev,dev,[0.9 0.7 0.7],0); hold on; plot(x,y,'r','LineWidth',2);
% x=[-1:0.05:1]+0.2;  y=sin(x*2)+0.01; dev = abs(sin(x+0.5)*0.1)*3;
% hold on ; plotMeanStd(x,y,dev,dev,[0.7 0.7 0.9],0); hold on; plot(x,y,'b','LineWidth',2);
N = length(x);

x = reshape(x, N,1);
y = reshape(y,N,1);
more = reshape(more,N,1);
less = reshape(less,N,1);

if (rotated ==0),
    p = [[x;flipud(x)],[y+more;flipud(y-less)]];
    h=fill(p(:,1), p(:,2),rgb,'FaceAlpha',0.5); hold on;
    set(h,'edgecolor','none');
%     plot(x,y,'k-'); hold on;
else
    p = [[x+more;flipud(x-less)],[y;flipud(y)]];
    h=fill(p(:,1), p(:,2),rgb,'FaceAlpha',0.5); hold on;
    set(h,'edgecolor','none');
  
    %l=plot(x,y,'k-','linewidth',3);
    %set(l,'Color',rgb*0.7);
    
end;
