x = dlmread('.VFunctionEjeY.txt');
y = dlmread('.VFunctionEjeY.txt');
z = dlmread('.VFunctionEjeZ.txt');

h = plot3(x,y,z,"k-.");
waitfor(h);