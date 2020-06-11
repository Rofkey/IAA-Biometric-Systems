function [polar_array, noise_mask]=Normalization(I,vdim,hdim,Iris, Pupil)
  %%  Normalization 
  % vdim=50;
  % hdim=150;
  I=double(I);
  radiuspixels = vdim + 2;
  angledivisions = hdim-1;

  r = 0:(radiuspixels-1);

  theta = 0:2*pi/angledivisions:2*pi;

  x_iris = Iris.Cx;
  y_iris = Iris.Cy;
  r_iris = Iris.R;

  x_pupil = Pupil.Cx;
  y_pupil = Pupil.Cy;
  r_pupil = Pupil.R;

  % calculate displacement of pupil center from the iris center
  ox = x_pupil - x_iris;
  oy = y_pupil - y_iris;

  sgn=0;
  if ox <= 0
    sgn = -1;
  elseif ox > 0
    sgn = 1;
  end

  if ox==0 && oy > 0
    sgn = 1;
  end

  r = double(r);
  theta = double(theta);

  a = ones(1,angledivisions+1) .* (ox .^ 2 + oy .^ 2);

  % need to do something for ox = 0
  if ox == 0
      phi = pi/2;
  else
      phi = atan(oy/ox);
  end

  b = sgn.*cos(pi - phi - theta);

  % calculate radius around the iris as a function of the angle

  r = (sqrt(a).*b) + ( sqrt( a.*(b.^2) - (a - (r_iris.^2))));

  r = r - r_pupil;

  rmat = ones(1,radiuspixels)'*r;

  rmat = rmat.* (ones(angledivisions+1,1)*[0:1/(radiuspixels-1):1])';
  rmat = rmat + r_pupil;


  % exclude values at the boundary of the pupil iris border, and the iris scelra border
  % as these may not correspond to areas in the iris region and will introduce noise.
  %
  % ie don't take the outside rings as iris data.
  rmat  = rmat(2:(radiuspixels-1), :);

  % calculate cartesian location of each data point around the circular iris
  % region
  xcosmat = ones(radiuspixels-2,1)*cos(theta);
  xsinmat = ones(radiuspixels-2,1)*sin(theta);

  xo = rmat.*xcosmat;    
  yo = rmat.*xsinmat;

  xo = x_pupil+xo;
  yo = y_pupil-yo;

  % extract intensity values into the normalised polar representation through
  % interpolation
  [x,y] = meshgrid(1:size(I,2),1:size(I,1)); 
  %image=rgb2gray(image);
  polar_array = interp2(x,y,I,xo,yo);  %%% permute(V,[2 1 3])

  % create noise array with location of NaNs in polar_array
  noise_mask = zeros(size(polar_array));
  coords = find(isnan(polar_array));
  noise_mask(coords) = 1;

  polar_array = double(polar_array)./255;


  % start diagnostics, writing out eye image with rings overlayed

  % get rid of outling points in order to write out the circular pattern
  coords = find(xo > size(I,2));
  xo(coords) = size(I,2);
  coords = find(xo < 1);
  xo(coords) = 1;

  coords = find(yo > size(I,1));
  yo(coords) = size(I,1);
  coords = find(yo<1);
  yo(coords) = 1;

  xo = round(xo);
  yo = round(yo);

  xo = int32(xo);
  yo = int32(yo);

  ind1 = sub2ind(size(I),double(yo),double(xo));

  %I = uint8(I);

  I(ind1) = 255;
  %get pixel coords for circle around iris
  [x,y] = circlecoords([x_iris,y_iris],r_iris,size(I));
  ind2 = sub2ind(size(I),double(y),double(x));
  %get pixel coords for circle around pupil
  [xp,yp] = circlecoords([x_pupil,y_pupil],r_pupil,size(I));
  ind1 = sub2ind(size(I),double(yp),double(xp));

  I(ind2) = 255;
  I(ind1) = 255;

  %replace NaNs before performing feature encoding
  coords = find(isnan(polar_array));
  polar_array2 = polar_array;
  polar_array2(coords) = 0.5;
  avg = sum(sum(polar_array2)) / (size(polar_array,1)*size(polar_array,2));
  polar_array(coords) = avg;

  end

  function [x,y] = circlecoords(c, r, imgsize,nsides)

      
      if nargin == 3
    nsides = 600;
      end
      
      nsides = round(nsides);
      
      a = [0:pi/nsides:2*pi];
      xd = (double(r)*cos(a)+ double(c(1)) );
      yd = (double(r)*sin(a)+ double(c(2)) );
      
      xd = round(xd);
      yd = round(yd);
      
      %get rid of -ves    
      %get rid of values larger than image
      xd2 = xd;
      coords = find(xd>imgsize(2));
      xd2(coords) = imgsize(2);
      coords = find(xd<=0);
      xd2(coords) = 1;
      
      yd2 = yd;
      coords = find(yd>imgsize(1));
      yd2(coords) = imgsize(1);
      coords = find(yd<=0);
      yd2(coords) = 1;
      
      x = int32(xd2);
      y = int32(yd2);   
  end