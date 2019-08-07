x = dlmread('.VFunctionEjeX.txt');
y = dlmread('.VFunctionEjeY.txt');

h = plot(x,y,"k-.");
waitfor(h);
