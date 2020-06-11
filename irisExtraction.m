function Iris=irisExtraction(I,Pupil)
  
%% step 3: Iris Edge Extraction
A=double(I);

%% 1. Smoothing
Am=medfilt2(A, [25 25]);
Am = uint8(Am);
%figure, imshow(A,[]); title('original image');
%figure, imshow(Am,[]); title('Filtered image');

%% 2. Edge Detection
edge_map = edge(Am,'canny');
%figure, imshow(edge_map,[]), title('Edge Detection by Canny');

%%% Center and Radius
Pupil.R = round(Pupil.R);

[M,N] = size(edge_map);
[Y,X] = find (edge_map >0);

% possible centers (within the pupil)
delta=5;
a = (Pupil.Cx - Pupil.R/3) : delta : (Pupil.Cx + Pupil.R/3);
b = (Pupil.Cy - Pupil.R/3) : delta : (Pupil.Cy + Pupil.R/3);

% possible radii
maxR = Pupil.R *3;
R = Pupil.R+20 : delta : maxR;

Accum = zeros(length(a),length(b),length(R));

for f = 1 : length(X)
    x = X(f);
    y = Y(f);
    for i = 1:length(a)
        for j = 1:length(b)
            r = round(sqrt((x-a(i))^2+(y-b(j))^2));%%euclidean distance
            fr = find(R == r);
             if(~isempty(fr))
                 Accum(i,j,fr(1)) = Accum(i,j,fr(1)) + 1; 
             end
        end
    end
end
maxIris=findMaxi(Accum,a,b,R);

Iris.Cx=maxIris.x;
Iris.Cy=maxIris.y;
Iris.R=maxIris.r;