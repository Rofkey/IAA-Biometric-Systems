%%% IRIS RECOGNITION SYSTEM
%%% STEP BY STEP

pkg load image
filename = 'file1.jpg';
A=imread(filename);
if ndims(A)>2
    A=rgb2gray(A);
endif
%figure, imshow(A);

%% 1.Pupil Boundary
Pupil=PupilBoundary(A);

%% 2 Iris Extrraction
v=25;
C=(A<=v);
%figure, imshow(C), title('Iris Extraction');

%%3 Median Filter
Iris=irisExtraction(A,Pupil);