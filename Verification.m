pkg load image
pkg load statistics

%FILENAME TO VERIFY
nameFile = '001_1_2.bmp';
[template1, mask1] = GenerateTemplate(strcat('DATA\APPLICANTS\TRUE\', nameFile));


[path, name, ext] = fileparts(nameFile);
name(size(name)(2)) = '1';
load(strcat('DATA\ENROLED\template', name), 'template');
load(strcat('DATA\ENROLED\mask', name), 'mask');

distance = Hamingd(template, mask, template1, mask1)
printf("---->");
printf("%d",distance);
printf("<----");

if (distance > 0.43)
  printf(' is not a valid user');
else
  printf(' is a valid user');
end

