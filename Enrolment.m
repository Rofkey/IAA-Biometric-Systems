pkg load image
pkg load statistics

files = dir('DATA\DB\*.bmp');
for i = 1:numel(files)
  if ~files(i).isdir
    [template, mask] = GenerateTemplate(strcat('DATA\DB\', files(i).name));
    [path, name, ext] = fileparts(files(i).name)
     save(strcat('DATA\ENROLED\template', name), 'template');
     save(strcat('DATA\ENROLED\mask', name), 'mask');
  end
end
  

