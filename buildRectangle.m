

function Mymatrix = buildRectangle(x,y,a,b,thetai,z)

L1=1:1:100;
L1_max=numel(L1);
L2=1:1:100;
L2_max=numel(L2);
Mymatrix = zeros(L1_max, L2_max);

theta=thetai*pi/180;


if x-b*sin(theta)<0 || x+a*cos(theta)>L1_max || y+b*cos(theta)+a*sin(theta)>L2_max
    result=0;
                
elseif a*cos(theta)>b*sin(theta)
    result=1;
elseif a*cos(theta)<b*sin(theta)
    result=2;
else
    result=3;
end

switch(result)
    case 0
        fprintf('The rectangle is out of the map,please choose another one')
        for i=1:L1_max
            for j=1:L2_max
                Mymatrix(i,j)=0;
            end
        end
        
    case 1
        for i=1:L1_max
            for j=1:L2_max
                dist = abs(i-x);
                if i >= x-b*sin(theta) && i < x
                    if j >= y+dist/tan(theta) && j <= (b-(dist/sin(theta)))/cos(theta)+dist/tan(theta)+y
                        Mymatrix(i,j)=z;
                    else
                        Mymatrix(i,j)=0;
                    end
                elseif i >= x && i < x+a*cos(theta)-b*sin(theta)
                    if j >= y+dist*tan(theta) && j <= y+dist*tan(theta)+b/cos(theta)
                        Mymatrix(i,j)=z;
                    else
                        Mymatrix(i,j)=0;
                    end
                elseif i >= x+a*cos(theta)-b*sin(theta) && i <= x+a*cos(theta)
                    if j >= y+dist*tan(theta) && j <= (a-dist/cos(theta))/sin(theta)+dist*tan(theta)+y
                        Mymatrix(i,j)=z;
                    else
                        Mymatrix(i,j)=0;
                    end
                else
                    Mymatrix(i,j)=0;
                end
            end
        end
    
    case 2
        for i=1:L1_max
            for j=1:L2_max
                dist = abs(x-i);
                if i >= x-b*sin(theta) && i < x+a*cos(theta)-b*sin(theta)
                    if j >= y+dist/tan(theta) && j <= (b-(dist/sin(theta)))/cos(theta)+dist/tan(theta)+y
                        Mymatrix(i,j)=z;
                    else
                        Mymatrix(i,j)=0;
                    end
                elseif i >= x+a*cos(theta)-b*sin(theta) && i < x
                    if j >= y+dist/tan(theta) && j <= y+dist/tan(theta)+a/sin(theta)
                        Mymatrix(i,j)=z;
                    else
                        Mymatrix(i,j)=0;
                    end
                elseif i >= x && i <= x+a*cos(theta)
                    if j >= y+dist*tan(theta) && j <= (a-dist/cos(theta))/sin(theta)+dist*tan(theta)+y
                        Mymatrix(i,j)=z;
                    else
                        Mymatrix(i,j)=0;
                    end
                else
                    Mymatrix(i,j)=0;
                end
            end
        end   
    case 3
        for i=1:L1_max
            for j=1:L2_max
                if i >= x-b*sin(theta) && i < x
                    if j >= y+(x-i)/tan(theta) && j <= (b-((x-i)/sin(theta)))/cos(theta)+(x-i)/tan(theta)+y
                        Mymatrix(i,j)=z;
                    else
                        Mymatrix(i,j)=0;
                    end
                elseif i >= x && i <= x+a*cos(theta)
                    if j >= y+(i-x)*tan(theta) && j <= (a-(i-x)/cos(theta))/sin(theta)+(i-x)*tan(theta)+y
                        Mymatrix(i,j)=z;
                    else
                        Mymatrix(i,j)=0;
                    end
                else
                    Mymatrix(i,j)=0;
                end
            end
        end
        
end

                                  
end


        
        
        
        
        
        
   









