function shifted = ShiftBits(template, shifts)
  shifted = zeros(size(template));
  width    = size(template, 2);

  absShifts = abs(shifts);

  offsetX = width-absShifts;

  if shifts == 0 % Without shift
    shifted = template; 
  elseif shifts < 0 % left shift
    x = 1:offsetX;
    shifted(:,x) = template(:,absShifts+x);
    
    x = (offsetX+1):width;
    shifted(:,x) = template(:,x-offsetX); 
  else %right shift
    x = (absShifts+1):width;
    shifted(:,x) = template(:,x-absShifts);
    
    x = 1:absShifts;
    shifted(:,x) = template(:,offsetX+x); 
  endif