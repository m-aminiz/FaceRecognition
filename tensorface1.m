clear all
counter = 0


dtr='yale_train';
str=dir(fullfile(dtr,'*.jpg'));


for s=1:15
    for e=1:10
        F_train=fullfile(dtr,str(e +counter).name);
        train_images=imread(F_train);
        train_images=imresize(train_images,[100 100]);
        train_images=im2double(train_images);
        tensor(:,e,s) = train_images(:);
    end
    counter = counter +10 ;
end



fprintf('unfolding...\n');
A1=unfold(tensor,1);
A2=unfold(tensor,2);
A3=unfold(tensor,3);
fprintf('As unfolded\n');

fprintf('svd...\n');
[Ut,~,~]=svd(double(A1),'econ');
[Vt,~,~]=svd(double(A2),'econ');
[Wt,~,~]=svd(double(A3),'econ');

fprintf('initializing S...\n');
S = TMpro(TMpro(TMpro(tensor,transpose(Ut),1),transpose(Vt),2),transpose(Wt),3);
fprintf('S inited\n');
fprintf('initializing S2...\n');
S2 = TMpro(TMpro(TMpro(S,Ut,1),Vt,2),Wt,3);
fprintf('S2 inited\n');

C = TMpro(TMpro(S,Ut,1),Vt,2);


dtes='yale_test';
stes=dir(fullfile(dtes,'*.jpg'));
%in the below line we can choose another image for test instead of 6 and we can choose it between 1 and 15
F_test=fullfile(dtes,stes(6).name);
test_image=imread(F_test);
test_image=imresize(test_image,[100 100]);
test_image=im2double(test_image);


distance = rand(0)
for E=1:10
    c1(:,:) = C(:,E,:)
    Xe = c1\test_image(:);
    for p=1:15
        H = transpose(Wt)
        Hp = H(:,p)
        distance(p) = norm(Xe - Hp)
    end  
    [M(E),i(E)] = min(distance)
    [value,index] = min(M)
    
end
    



function [B] = unfold(A,i)
clc;
[l m n]=size(A);
B=rand(0,0);
if(i==1)
    D=rand(l,n);
    for j=1:m
        for r=1:l
            for s=1:n
                D(r,s)=A(r,j,s);
            end
        end
        B=[B D];
    end
end
if(i==2)
    E=rand(l,m);
    for j=1:n
        for r=1:l
            for s=1:m
                E(r,s)=A(r,s,j);
            end
        end
        D=transpose(E);
        B=[B D];
    end
end
if(i==3)
    E=rand(m,n);
    for j=1:l
        for r=1:m
            for s=1:n
                E(r,s)=A(j,r,s);
            end
        end
        D=transpose(E);
        B=[B D];
    end
end

end



function [B] = TMpro(A,U,i)
B=rand(0,0,0);
[l, m, n]=size(A);
    if(i==1)
        [~, l2]=size(U);
        if(l~=l2)
           fprintf('fail for dimensions')
        end
        for j=1:m
            Atemp(:,:)=A(:,j,:);
            B(:,j,:) = U*Atemp;
        end
    end
    if(i==2)
        [~, m2]=size(U);
        if(m~=m2)
           fprintf('fail for dimensions')
        end
        for k=1:n
            Atemp(:,:)=A(:,:,k);
            B(:,:,k) = Atemp*transpose(U);
        end
    end
    if(i==3)
        [~, n2]=size(U);
        if(n~=n2)
           fprintf('fail for dimensions in mode %d\n',i)
        end
        for x=1:l
            Atemp(:,:)=A(x,:,:);
            B(x,:,:) = Atemp*transpose(U);
        end
    end
end


