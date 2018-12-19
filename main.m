clc
clear
%Read Information from common transfering files
filename = 'transferfiles.txt';
delimiter = '\t';
startRow = 2;
formatSpec = '%s%s%s%s%s%s%s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));
for col=[1,2,3,4,5,6,7]
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData(row), regexstr, 'names');
            numbers = result.numbers;
            invalidThousandsSeparator = false;
            if numbers.contains(',')
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            if ~invalidThousandsSeparator
                numbers = textscan(char(strrep(numbers, ',', '')), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch
            raw{row, col} = rawData{row};
        end
    end
end
transferfiles = table;
transferfiles.shape = cell2mat(raw(:, 1));
transferfiles.height = cell2mat(raw(:, 2));
transferfiles.x0 = cell2mat(raw(:, 3));
transferfiles.y0 = cell2mat(raw(:, 4));
transferfiles.xa = cell2mat(raw(:, 5));
transferfiles.yb = cell2mat(raw(:, 6));
transferfiles.orient = cell2mat(raw(:, 7));
% clearvars filename delimiter startRow formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp;

%Initialize the world map
world= zeros(500,500);
world(1,:)=1;
world(:,1)=1;
world(500,:)=1;
world(:,500)=1;
%Proof plotting the obstacles
for index=1:1:length(transferfiles.height)
    h=transferfiles.height(index,:);
    s=transferfiles.shape(index,:); 
    world= max(world,buildObstacle(h,s,transferfiles,index));
end

fileID =fopen('test.txt','w');
fclose(fileID);
dlmwrite('test.txt',world)

%Visualize in matlab
L1=1:500;
L2=1:500;
L1_max=numel(L1);
L2_max=numel(L2);
[L1,L2]=meshgrid(L1,L2);
mesh(L1,L2,world)


function output=buildObstacle(height,shape,transferfiles,index)
output= zeros(500,500);
L1=1:500;
L2=1:500;
L1_max=numel(L1);
L2_max=numel(L2);

if (shape =='circ')
    x= 5*transferfiles.x0(index);
    y= 5*transferfiles.y0(index);
    r= 5*transferfiles.xa(index);
    for i=1:L1_max
        for j=1:L2_max
            if i<x-r || i>x+r
                output(i,j)=0;
            else
                if j<y-sqrt(r^2 - (x-i)^2) || j>y+sqrt(r^2-(x-i)^2)
                    output(i,j)=0;
                else
                    output(i,j)=height;

                end
            end
        end
    end
elseif (shape == 'rect')
    
    x= 5*transferfiles.x0(index);
    y= 5*transferfiles.y0(index);
    a= 5*transferfiles.xa(index);
    b= 5*transferfiles.yb(index);
    orient= transferfiles.orient(index);
    theta=orient*pi/180;
    
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
                    output(i,j)=0;
                end
            end

        case 1
            for i=1:L1_max
                for j=1:L2_max
                    dist = abs(i-x);
                    if i >= x-b*sin(theta) && i < x
                        if j >= y+dist/tan(theta) && j <= (b-(dist/sin(theta)))/cos(theta)+dist/tan(theta)+y
                            output(i,j)=height;
                        else
                            output(i,j)=0;
                        end
                    elseif i >= x && i < x+a*cos(theta)-b*sin(theta)
                        if j >= y+dist*tan(theta) && j <= y+dist*tan(theta)+b/cos(theta)
                            output(i,j)=height;
                        else
                            output(i,j)=0;
                        end
                    elseif i >= x+a*cos(theta)-b*sin(theta) && i <= x+a*cos(theta)
                        if j >= y+dist*tan(theta) && j <= (a-dist/cos(theta))/sin(theta)+dist*tan(theta)+y
                            output(i,j)=height;
                        else
                            output(i,j)=0;
                        end
                    else
                        output(i,j)=0;
                    end
                end
            end

        case 2
            for i=1:L1_max
                for j=1:L2_max
                    dist = abs(x-i);
                    if i >= x-b*sin(theta) && i < x+a*cos(theta)-b*sin(theta)
                        if j >= y+dist/tan(theta) && j <= (b-(dist/sin(theta)))/cos(theta)+dist/tan(theta)+y
                            output(i,j)=height;
                        else
                            output(i,j)=0;
                        end
                    elseif i >= x+a*cos(theta)-b*sin(theta) && i < x
                        if j >= y+dist/tan(theta) && j <= y+dist/tan(theta)+a/sin(theta)
                            output(i,j)=height;
                        else
                            output(i,j)=0;
                        end
                    elseif i >= x && i <= x+a*cos(theta)
                        if j >= y+dist*tan(theta) && j <= (a-dist/cos(theta))/sin(theta)+dist*tan(theta)+y
                            output(i,j)=height;
                        else
                            output(i,j)=0;
                        end
                    else
                        output(i,j)=0;
                    end
                end
            end  
            
        case 3
            for i=1:L1_max
                for j=1:L2_max
                    if i >= x-b*sin(theta) && i < x
                        if j >= y+(x-i)/tan(theta) && j <= (b-((x-i)/sin(theta)))/cos(theta)+(x-i)/tan(theta)+y
                            output(i,j)=height;
                        else
                            output(i,j)=0;
                        end
                    elseif i >= x && i <= x+a*cos(theta)
                        if j >= y+(i-x)*tan(theta) && j <= (a-(i-x)/cos(theta))/sin(theta)+(i-x)*tan(theta)+y
                            output(i,j)=height;
                        else
                            output(i,j)=0;
                        end
                    else
                        output(i,j)=0;
                    end
                end
            end
        
     end

    
    
end
%fix bug: holes inside the rectangle area

end
