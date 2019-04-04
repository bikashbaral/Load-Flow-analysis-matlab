% Test Case
% 4
% 2
% [1 101 1 0 0 0 2.2 1.35; 2 101 1 0 0 0 2 1.25; 3 102 1.02 0 3.18 0 0.8 0.5; 4 103 1 0 0 0 0 0]
% [1 4 0.01 0.08 0.1 1; 1 3 0.005 0.05 0.15 1; 2 3 0.01 0.06 0.12 1; 2 4 0.005 0.04 0.08 1; 3 4 0.01 0.1 0.1 1]

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
disp(size(line_dat)(1))
for i = 1:size(line_dat)(1)
    Y_bus(line_dat(i, 1), line_dat(i, 2)) -= (1.0/(line_dat(i, 3) + j*line_dat(i, 4)))/line_dat(i, 6);	%this is divided by tap ratio
    Y_bus(line_dat(i, 2), line_dat(i, 1)) -= (1.0/(line_dat(i, 3) + j*line_dat(i, 4)))/line_dat(i, 6);	%this is divided by tap ratio
    Y_bus(line_dat(i, 1), line_dat(i, 1)) += (1.0/(line_dat(i, 3) + j*line_dat(i, 4)))/(line_dat(i, 6)^2) + j*line_dat(i, 5)/2;	%from bus is divided by (a*a)
    Y_bus(line_dat(i, 2), line_dat(i, 2)) += 1.0/(line_dat(i, 3) + j*line_dat(i, 4)) + j*line_dat(i, 5)/2;
end

iter = 0
while 1
	iter += 1;
	bus_pq = bus_dat(bus_dat(:, 2) == 101, :);
	bus_pv = bus_dat(bus_dat(:, 2) == 102, :);
	bus_sl = bus_dat(bus_dat(:, 2) == 103, :);
	bus_dat = [bus_pq; bus_pv; bus_sl];
	% disp(bus_pq)  %to check the values once 
    mismatch = zeros(2*nbs - nmc - 1, 1);
    %Computing mismatch of P for PQ bus
    for i = 1:size(bus_pq)(1)
	  n = bus_pq(i, 1);
	  mismatch(i) = bus_dat(n, 5) - bus_dat(n, 7);	%Pspecific
	  for j = 1:size(bus_dat)(1)	%to calculate the Pcal we will have to use the value of accross all nodes/buses
		m = bus_dat(j, 1);
		mismatch(i) -= abs(bus_dat(n, 3))*abs(bus_dat(m, 3))*abs(Y_bus(n, m))*cos(bus_dat(n, 4) - bus_dat(m, 4) - angle(Y_bus(n, m)));
	  end
    end
    %Computing mismatch of P for PV bus
    for i = 1:size(bus_pv)(1)
	  n = bus_pv(i, 1);
	  index = size(bus_pq)(1) + i;
	  mismatch(index) = bus_dat(n, 5) - bus_dat(n, 7);
	  for j = 1:size(bus_dat)(1)
		m = bus_dat(j, 1);
		mismatch(index) -= abs(bus_dat(n, 3))*abs(bus_dat(m, 3))*abs(Y_bus(n, m))*cos(bus_dat(n, 4) - bus_dat(m, 4) - angle(Y_bus(n, m)));
	  end
    end
    % Computing mismatch of Q for PQ bus
    for i = 1:size(bus_pq)(1)
	  n = bus_pq(i, 1);
	  index = size(bus_pq)(1) + size(bus_pv)(1) + i;
	  mismatch(index) = bus_dat(n, 6) - bus_dat(n, 8);
	  for j = 1:size(bus_dat)(1)
		m = bus_dat(j, 1);
		mismatch(index) -= abs(bus_dat(n, 3))*abs(bus_dat(m, 3))*abs(Y_bus(n, m))*sin(bus_dat(n, 4) - bus_dat(m, 4) - angle(Y_bus(n, m)));
	  end
    end
    
    jacobian = zeros(2*nbs - nmc - 1);
    %Computing Del(P)/Del(thetha) which is of size (nbs-1)x(nbs-1) or size(bus_pq)(1) + size(bus_pv)(1)	
    for i = 1:size(bus_pq)(1) + size(bus_pv)(1)	
	  for j = 1:size(bus_pq)(1) + size(bus_pv)(1)
		if i != j
		    jacobian(i, j) = abs(bus_dat(i, 3))*abs(bus_dat(j, 3))*abs(Y_bus(i, j))*sin(bus_dat(i, 4) - bus_dat(j, 4) - angle(Y_bus(i, j)));	%|Vi|*|Vj|*|Yij|*sin()
		else
		    jacobian(i, j) = -1*bus_dat(i, 3)*bus_dat(i, 3)*imag(Y_bus(i, i));	%-|v|^2*Bii
		    for k = 1:nbs
			  jacobian(i, j) -= abs(bus_dat(i, 3))*abs(bus_dat(k, 3))*abs(Y_bus(i, k))*sin(bus_dat(i, 4) - bus_dat(k, 4) - angle(Y_bus(i, k)));	%-Qi
		    end
		end
	  end
    end
    %Computing Del(Q)/Del(V) which is of size (nbs-nmc)x(nbs-nmc) or size(bus_pq)(1)
    for i = 1:size(bus_pq)(1)
	  for j = 1:size(bus_pq)(1)
		offset = size(bus_pq)(1) + size(bus_pv)(1);
		if i != j
		    jacobian(offset + i, offset + j) = abs(bus_dat(i, 3))*abs(bus_dat(j, 3))*abs(Y_bus(i, j))*sin(bus_dat(i, 4) - bus_dat(j, 4) - angle(Y_bus(i, j)));	%|Vi|*|Vj|*|Yij|*sin()
		else
		    jacobian(offset + i, offset + j) = -1*bus_dat(i, 3)*bus_dat(i, 3)*imag(Y_bus(i, i));	%-|v|^2*Bii
		    for k = 1:nbs
			  jacobian(offset + i, offset + j) += abs(bus_dat(i, 3))*abs(bus_dat(k, 3))*abs(Y_bus(i, k))*sin(bus_dat(i, 4) - bus_dat(k, 4) - angle(Y_bus(i, k)));	%Qi
		    end
		end
	  end
    end
    %Computing Del(P)/Del(V) which is of size (nbs-1)x(nbs-nmc) 
    for i = 1:size(bus_pq)(1) + size(bus_pv)(1)
	  for j = 1:size(bus_pq)
		offset = size(bus_pq)(1) + size(bus_pv)(1);
		if i != j
		    jacobian(i, offset + j) = abs(bus_dat(i, 3))*abs(bus_dat(j, 3))*abs(Y_bus(i, j))*cos(bus_dat(i, 4) - bus_dat(j, 4) - angle(Y_bus(i, j)));	%|Vi|*|Vj|*|Yij|*cos()
		else
		    jacobian(i, offset + j) = bus_dat(i, 3)*bus_dat(j, 3)*real(Y_bus(i, j));	%|V|^2*Gii
		    for k = 1:nbs
			  jacobian(i, offset + j) += abs(bus_dat(i, 3))*abs(bus_dat(k, 3))*abs(Y_bus(i, k))*cos(bus_dat(i, 4) - bus_dat(k, 4) - angle(Y_bus(i, k)));	%Pi
		    end
		end
	  end
    end
    %Computing Del(Q)/Del(thetha) which is of size (nbs-nmc)x(nbs-1)
    for i = 1:size(bus_pq)(1)
	  for j = 1:size(bus_pq)(1) + size(bus_pv)(1)
		offset = size(bus_pq)(1) + size(bus_pv)(1);
		if i != j
		    jacobian(offset + i, j) = -1*abs(bus_dat(i, 3))*abs(bus_dat(j, 3))*abs(Y_bus(i, j))*cos(bus_dat(i, 4) - bus_dat(j, 4) - angle(Y_bus(i, j)));	%-1*|Vi|*|Vj|*|Yij|*cos()
		else
		    jacobian(offset + i, j) = -1*bus_dat(i, 3)*bus_dat(j, 3)*real(Y_bus(i, j));		%-|V|^2*Gii
		    for k = 1:nbs
			  jacobian(offset + i, j) += abs(bus_dat(i, 3))*abs(bus_dat(k, 3))*abs(Y_bus(i, k))*cos(bus_dat(i, 4) - bus_dat(k, 4) - angle(Y_bus(i, k)));	%Pi
		    end
		end
	  end
    end
    %Computing Inverse using Gauss-Jordan Elimination Matrix
	r = size(jacobian)(1);
	b = eye(r);

	for j = 1 : r
		for i = j : r
			if jacobian(i,j) ~= 0
				for k = 1 : r
					s = jacobian(j,k);
					jacobian(j,k) = jacobian(i,k); 
					jacobian(i,k) = s;
					s = b(j,k); 
					b(j,k) = b(i,k);
					b(i,k) = s;
				end
				t = 1/jacobian(j,j);
				for k = 1 : r
					jacobian(j,k) = t * jacobian(j,k);
					b(j,k) = t * b(j,k);
				end
				for L = 1 : r
					if L ~= j
						t = -jacobian(L,j);
						for k = 1 : r
							jacobian(L,k) = jacobian(L,k) + t * jacobian(j,k);
							b(L,k) = b(L,k) + t * b(j,k);
						end
					end
				end            
			end
			break
		end
	end
    correction = b*mismatch;
    for i = 1:size(bus_pq)(1) + size(bus_pv)(1)
	bus_dat(i, 4) += correction(i);
    end
    
    for i = 1:size(bus_pq)(1)
	  offset = size(bus_pq)(1) + size(bus_pv)(1);
	  bus_dat(i, 3) += correction(offset + i)*bus_dat(i, 3);
    end
    
    disp("Iteration ")
    disp(iter)
    mismatch
    if(mismatch < 1e-4)
	  break
    end
end

for i = 1:nbs
    bus_dat(i, 4) *= 180.0/pi;
end

bus_dat
disp("The angle is in degree")
