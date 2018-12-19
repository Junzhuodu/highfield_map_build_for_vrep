clear
clc
L1=1:1:100;
L2=1:1:100;
[L1,L2]=meshgrid(L1,L2);%%%map:100m*100m

usefuc1=@buildRectangle;
Q1=usefuc1(30,30,10,20,60,1);
Q2=usefuc1(20,85,50,10,0,1);
Q4=usefuc1(60,5,10,30,20,1);
Q5=usefuc1(85,40,10,50,0,1);

usefuc2=@buildCircle;
Q3=usefuc2(40,65,10,1);

Q=Q1|Q2|Q3|Q4|Q5;
        
       
mesh(L1,L2,Q) 
dlmwrite('filename.txt',Q)




