function plotACircle(R,Cx,Cy,I)
% pupil contour points
nPoints = 500;
theta = linspace(0,2*pi,nPoints);
rho = ones(1,nPoints)* R;
%[X,Y] = pol2cart(theta,rho);
X=cos(theta).*rho;
Y=sin(theta).*rho;
X = X + Cx;
Y = Y + Cy;
%figure, imshow(I,[]); hold on
plot(X,Y,'r','LineWidth',3); 
