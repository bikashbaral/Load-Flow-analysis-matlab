jacobian = [5,7,9;4,3,8;7,5,6];
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
disp(b)