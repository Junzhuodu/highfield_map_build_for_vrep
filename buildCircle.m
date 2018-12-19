function Mymatrix = buildCircle(x,y,r,z)


L1=1:1:100;
L1_max=numel(L1);
L2=1:1:100;
L2_max=numel(L2);
Mymatrix = zeros(L1_max, L2_max);


for i=1:L1_max
    for j=1:L2_max
        if i<x-r || i>x+r
            Mymatrix(i,j)=0;
        else
            if j<y-sqrt(r^2 - (x-i)^2) || j>y+sqrt(r^2-(x-i)^2)
                Mymatrix(i,j)=0;
            else
                Mymatrix(i,j)=z;
                
            end
        end
    end
end

           
        
  