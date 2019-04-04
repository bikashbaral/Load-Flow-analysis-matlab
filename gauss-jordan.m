a = [5,7,9;4,3,8;7,5,6];
r = size(a)(1);
b = eye(r);

for j = 1 : r
	for i = j : r
		if a(i,j) ~= 0
			for k = 1 : r
				s = a(j,k);
				a(j,k) = a(i,k); 
				a(i,k) = s;
				s = b(j,k); 
				b(j,k) = b(i,k);
				b(i,k) = s;
			end
			t = 1/a(j,j);
			for k = 1 : r
				a(j,k) = t * a(j,k);
				b(j,k) = t * b(j,k);
			end
			for L = 1 : r
				if L ~= j
					t = -a(L,j);
					for k = 1 : r
						a(L,k) = a(L,k) + t * a(j,k);
						b(L,k) = b(L,k) + t * b(j,k);
					end
				end
			end            
		end
		break
	end
end
disp(b)