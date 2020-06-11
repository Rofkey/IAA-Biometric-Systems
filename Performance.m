pkg load image
pkg load statistics

FAR = 0;
FRR = 0;

files = dir('DATA\APPLICANTS\FALSE\*.bmp');
for i = 1:numel(files)   
   
    if ~files(i).isdir
       [template1, mask1] = GenerateTemplate(strcat(files(i).folder, '\', files(i).name));
       [path, name, ext] = fileparts(files(i).name);
       name(size(name)(2)) = '1';
       load(strcat('DATA\ENROLED\template', name), 'template');
       load(strcat('DATA\ENROLED\mask', name), 'mask');
       
       distance = Hamingd(template, mask, template1, mask1)
      
      if (distance <= 0.45)
         FAR = FAR+1;
       end
    end
end
  
FAR = FAR/size(files, 1);

files = dir('DATA\APPLICANTS\TRUE\*.bmp');
for i = 1:numel(files)   
    if ~files(i).isdir
       [template1, mask1] = GenerateTemplate(strcat(files(i).folder, '\', files(i).name));
       [path, name, ext] = fileparts(files(i).name);
       name(size(name)(2)) = '1';
       load(strcat('DATA\ENROLED\template', name), 'template');
       load(strcat('DATA\ENROLED\mask', name), 'mask');
       
       distance = Hamingd(template, mask, template1, mask1)
       
       if (distance > 0.45)
          FRR = FRR+1; 
       end
    end
end
FRR = FRR/size(files, 1);
  


msgbox(sprintf('FAR = %2.3g\nFRR = %2.3g',FAR,FRR));


