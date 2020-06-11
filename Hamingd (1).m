function distance = Hamingd(template1, mask1, template2, mask2)

template1 = logical(template1);
mask1     = logical(mask1);

template2 = logical(template2);
mask2     = logical(mask2);

distance = NaN;

% shift template left and right, use the lowest Hamming distance
for shifts=-8:8
    t1shifted = ShiftBits(template1, shifts);
    m1shifted = ShiftBits(mask1, shifts);
    
    mask = m1shifted | mask2;
    
    nummaskbits = sum(sum(mask == 1));
    
    totalbits = (size(t1shifted,1)*size(t1shifted,2)) - nummaskbits;
    
    C = xor(t1shifted,template2);
    
    C = C & ~mask;
    bitsdiff = sum(sum(C==1));
    
    if totalbits == 0        
        distance = NaN;        
    else        
        distanceAux = bitsdiff / totalbits;        
        
        if  distanceAux < distance || isnan(distance)            
            distance = distanceAux;            
        end                
    end    
end