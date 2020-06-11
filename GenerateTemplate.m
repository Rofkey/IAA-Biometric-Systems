function [template, mask]=GenerateTemplate(filename)
  %filename='file1.jpg'
  %%function [t,m]=GenerateTemplate(filename)

  A=imread(filename);

  %if ndims(A)>2
  %    A=rgb2gray(A);
  %endif
  %v=70;
  %C=(A<=v);
  %figure, imshow(C);
  %% Segmentation
  Pupil=PupilBoundary(A);  %Centroid and radius of the Pupil

  %% 2 Iris Extrraction
  %v=70;
  %C=(A<=v);
  %figure, imshow(A), title('Iris Extraction');

  %3 Median Filter
  Iris=irisExtraction(A,Pupil);

  %% Normalization
  [polar_array, noise_mask]=Normalization(double(A),50,150,Iris, Pupil);

  %% Encoding
  [template, mask] = Encoding(polar_array, noise_mask);
