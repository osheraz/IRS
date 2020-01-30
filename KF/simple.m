clc;
clear all
R=1;
Q=2;
A=1;
C=1;
Mt=[1,0,0];
St=[10,0,0];
z=[2,3];
Mt_gag=Mt;
St_gag=St;
Kt=[0,0];

Mt_gag(1)=NaN;
St_gag(1)=NaN;
for i=1:2
Mt_gag(i+1)=A.*Mt(i);
St_gag(i+1)=A.*St(i).*A'+R;
Kt(i)=St_gag(i+1).*C'.*inv(C.*St_gag(i+1).*C'+Q);
Mt(i+1)= Mt_gag(i+1)+Kt(i).*(z(i)-C.*Mt_gag(i+1));
St(i+1)=(1-Kt(i).*C).*St_gag(i+1);
end


