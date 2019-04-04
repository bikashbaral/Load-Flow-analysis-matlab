% Test Case
4
2
[1 101 1 0 0 0 2.2 1.35; 2 101 1 0 0 0 2 1.25; 3 102 1.02 0 3.18 0 0.8 0.5; 4 103 1 0 0 0 0 0]
[1 4 0.01 0.08 0.1 1; 1 3 0.005 0.05 0.15 1; 2 3 0.01 0.06 0.12 1; 2 4 0.005 0.04 0.08 1; 3 4 0.01 0.1 0.1 1]

% Test Case 2
6
2
[1 101 1 0 0 0 0.55 0.13; 2 101 1 0 0 0 0 0; 3 101 1 0 0 0 0.3 0.18; 4 101 1 0 0 0 0.5 0.05; 5 102 1.03 0 0.75 0 0.3 0.1; 6 103 1.02 0 0 0 0 0]
[6 2 0.08 0.37 0.28 1; 6 4 0.123 0.518 0.4 1; 5 1 0.723 1.05 0.2 1; 5 3 0.282 0.640 0.3 1; 2 4 0.097 0.407 0.240 1; 2 1 0 0.133 0 1.05; 4 3 0 0.3 0 1.025]


nbs = input("Enter number of buses ");
nmc = input("Enter number of machines ");

bus_dat = input("Enter bus data");
for i = 1:nbs
    bus_dat(i, 4) *= pi/180;
end


line_dat = input("Enter line data ");
Y_bus = zeros(nbs, nbs);
size(Y_bus)
% disp(Y_bus)
for i = 1:size(line_dat)(1)
    Y_bus(line_dat(i, 1), line_dat(i, 2)) -= (1.0/(line_dat(i, 3) + j*line_dat(i, 4)))/line_dat(i, 6);
    Y_bus(line_dat(i, 2), line_dat(i, 1)) -= (1.0/(line_dat(i, 3) + j*line_dat(i, 4)))/line_dat(i, 6);
    Y_bus(line_dat(i, 1), line_dat(i, 1)) += (1.0/(line_dat(i, 3) + j*line_dat(i, 4)))/(line_dat(i, 6)^2) + j*line_dat(i, 5)/2;%from bus is divided by (a*a)
    Y_bus(line_dat(i, 2), line_dat(i, 2)) += 1.0/(line_dat(i, 3) + j*line_dat(i, 4)) + j*line_dat(i, 5)/2;
end


