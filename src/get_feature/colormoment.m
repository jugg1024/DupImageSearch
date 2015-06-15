function y=colormoment(I)
    y=zeros(9,1);
    [m,n,~]=size(I);
    si = m*n;
    I=rgb2hsv(I);
    h=I(:,:,1); h = h(:);
    s=I(:,:,2); s = s(:);
    v=I(:,:,3); v = v(:);    
    %��һ�׾أ���ֵ��
    y(1)=sum(h)/si;
    y(2)=sum(s)/si;
    y(3)=sum(v)/si;
    %����׾أ����
    y(4)=sqrt(sum((h-y(1)).^2)/si);
    y(5)=sqrt(sum((s-y(2)).^2)/si);
    y(6)=sqrt(sum((v-y(3)).^2)/si);
    %�����׾�
    y(7)=abs(sum((h-y(1)).^3)/si).^(1/3);
    y(8)=abs(sum((s-y(2)).^3)/si).^(1/3);
    y(9)=abs(sum((v-y(3)).^3)/si).^(1/3);
end