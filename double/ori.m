global Q_area;
global p_area;
global p_area_t;
global u_area;
global q_area;
global u_max;
global Q_min;
global Q_max;
global w;
global v;
global p_area_task;
global w_task;
global v_task;
global fval;
global x;
v=[46 48 47 37];
w=[0.3 0.3 0 0.2;0.3 0.3 0.15 0.15;0 0.2 0.15 0.45;0.5 0 0.4 0];
Q_area=zeros(4,4);
p_area=[8.6 6 0 5.25;10 7.8 5.6 8.5;0 6.7 5.1 8.5;12.5 0 10.5 0];
Q_min=[25 20 0 15;24 24 14 14;0 16 14 25;27 0 26 0];
Q_max=[100 100 0 100;100 100 100 100;0 100 100 100;100 0 100 0];
u_max=[45 45 40 45 41 45 38 39 43 41 40 45 40 38 41];
u_area=[1 3 2 4 2 2 3 4 1 1 3 2 4 4 3];
q_area=zeros(4,4,15);
total(1:300)=0;
x=zeros(4,4);
fval=[0 0 0 0];
fval_n=zeros(300,4);
fvaly=zeros(1,15);
fvaly_n=zeros(300,15);
y=zeros(15,4);
num=1:300;
mismatch=zeros(4,4,300);
paruser1=@(y)user1(y,p_area);
paruser2=@(y)user2(y,p_area);
paruser3=@(y)user3(y,p_area);
paruser4=@(y)user4(y,p_area);
paruser5=@(y)user5(y,p_area);
paruser6=@(y)user6(y,p_area);
paruser7=@(y)user7(y,p_area);
paruser8=@(y)user8(y,p_area);
paruser9=@(y)user9(y,p_area);
paruser10=@(y)user10(y,p_area);
paruser11=@(y)user11(y,p_area);
paruser12=@(y)user12(y,p_area);
paruser13=@(y)user13(y,p_area);
paruser14=@(y)user14(y,p_area);
paruser15=@(y)user15(y,p_area);
q_area_n=zeros(15,4,300);
Q_area_n=zeros(4,4,300);
p_area_n=zeros(4,4,300);
for n=1:300
    total(n)=0;
    disp('time');
    disp(n);
    p_area_t=p_area';
    for i=1:4
        p_area_task=p_area_t(:,i);
        w_task=w(i,:);
        v_task=v(i);
        [x(i,:),fval(i)]=fmincon(@task,ga(@task,4,[],[],[],[],Q_min(i,:),Q_max(i,:)),[],[],[],[],Q_min(i,:),Q_max(i,:));
        %total(n)=total(n)+fval(i);
        Q_area(i,:)=x(i,:);
    end
    parfor j=1:15
        switch j
            case 1
                [y_1,fval1]=fmincon(paruser1,ga(paruser1,4,[1 1 1 1],u_max(1),[],[],[0 0 0 0]),[1 1 1 1],u_max(1),[],[],[0 0 0 0]);
                while fval1>0
                    [y_1,fval1]=fmincon(paruser1,ga(paruser1,4,[1 1 1 1],u_max(1),[],[],[0 0 0 0]),[1 1 1 1],u_max(1),[],[],[0 0 0 0]);
                end
                y(j,:)=y_1;
                fvaly(j)=fval1;
            case 2
                [y_2,fval2]=fmincon(paruser2,ga(paruser2,4,[1 1 1 1],u_max(2),[],[],[0 0 0 0]),[1 1 1 1],u_max(2),[],[],[0 0 0 0]);
                while fval2>0
                    [y_2,fval2]=fmincon(paruser2,ga(paruser2,4,[1 1 1 1],u_max(2),[],[],[0 0 0 0]),[1 1 1 1],u_max(2),[],[],[0 0 0 0]);
                end
                y(j,:)=y_2;
                fvaly(j)=fval2;
            case 3
                [y_3,fval3]=fmincon(paruser3,ga(paruser3,4,[1 1 1 1],u_max(3),[],[],[0 0 0 0]),[1 1 1 1],u_max(3),[],[],[0 0 0 0]);
                while fval3>0
                    [y_3,fval3]=fmincon(paruser3,ga(paruser3,4,[1 1 1 1],u_max(3),[],[],[0 0 0 0]),[1 1 1 1],u_max(3),[],[],[0 0 0 0]);
                end
                y(j,:)=y_3;
                fvaly(j)=fval3;
            case 4
                [y_4,fval4]=fmincon(paruser4,ga(paruser4,4,[1 1 1 1],u_max(4),[],[],[0 0 0 0]),[1 1 1 1],u_max(4),[],[],[0 0 0 0]);
                while fval4>0
                    [y_4,fval4]=fmincon(paruser4,ga(paruser4,4,[1 1 1 1],u_max(4),[],[],[0 0 0 0]),[1 1 1 1],u_max(4),[],[],[0 0 0 0]);
                end
                y(j,:)=y_4;
                fvaly(j)=fval4;
            case 5
                [y_5,fval5]=fmincon(paruser5,ga(paruser5,4,[1 1 1 1],u_max(5),[],[],[0 0 0 0]),[1 1 1 1],u_max(5),[],[],[0 0 0 0]);
                while fval5>0
                    [y_5,fval5]=fmincon(paruser5,ga(paruser5,4,[1 1 1 1],u_max(5),[],[],[0 0 0 0]),[1 1 1 1],u_max(5),[],[],[0 0 0 0]);
                end
                y(j,:)=y_5;
                fvaly(j)=fval5;
            case 6
                [y_6,fval6]=fmincon(paruser6,ga(paruser6,4,[1 1 1 1],u_max(6),[],[],[0 0 0 0]),[1 1 1 1],u_max(6),[],[],[0 0 0 0]);
                while fval6>0
                    [y_6,fval6]=fmincon(paruser6,ga(paruser6,4,[1 1 1 1],u_max(6),[],[],[0 0 0 0]),[1 1 1 1],u_max(6),[],[],[0 0 0 0]);
                end
                y(j,:)=y_6;
                fvaly(j)=fval6;
            case 7
                [y_7,fval7]=fmincon(paruser7,ga(paruser7,4,[1 1 1 1],u_max(7),[],[],[0 0 0 0]),[1 1 1 1],u_max(7),[],[],[0 0 0 0]);
                while fval7>0
                    [y_7,fval7]=fmincon(paruser7,ga(paruser7,4,[1 1 1 1],u_max(7),[],[],[0 0 0 0]),[1 1 1 1],u_max(7),[],[],[0 0 0 0]);
                end
                y(j,:)=y_7;
                fvaly(j)=fval7;
            case 8
                [y_8,fval8]=fmincon(paruser8,ga(paruser8,4,[1 1 1 1],u_max(8),[],[],[0 0 0 0]),[1 1 1 1],u_max(8),[],[],[0 0 0 0]);
                while fval8>0
                    [y_8,fval8]=fmincon(paruser8,ga(paruser8,4,[1 1 1 1],u_max(8),[],[],[0 0 0 0]),[1 1 1 1],u_max(8),[],[],[0 0 0 0]);
                end
                y(j,:)=y_8;
                fvaly(j)=fval8;
            case 9
                [y_9,fval9]=fmincon(paruser9,ga(paruser9,4,[1 1 1 1],u_max(9),[],[],[0 0 0 0]),[1 1 1 1],u_max(9),[],[],[0 0 0 0]);
                while fval9>0
                    [y_9,fval9]=fmincon(paruser9,ga(paruser9,4,[1 1 1 1],u_max(9),[],[],[0 0 0 0]),[1 1 1 1],u_max(9),[],[],[0 0 0 0]);
                end
                y(j,:)=y_9;
                fvaly(j)=fval9;
            case 10
                [y_10,fval10]=fmincon(paruser10,ga(paruser10,4,[1 1 1 1],u_max(10),[],[],[0 0 0 0]),[1 1 1 1],u_max(10),[],[],[0 0 0 0]);
                while fval10>0
                    [y_10,fval10]=fmincon(paruser10,ga(paruser10,4,[1 1 1 1],u_max(10),[],[],[0 0 0 0]),[1 1 1 1],u_max(10),[],[],[0 0 0 0]);
                end
                y(j,:)=y_10;
                fvaly(j)=fval10;
            case 11
                [y_11,fval11]=fmincon(paruser11,ga(paruser11,4,[1 1 1 1],u_max(11),[],[],[0 0 0 0]),[1 1 1 1],u_max(11),[],[],[0 0 0 0]);
                while fval11>0
                    [y_11,fval11]=fmincon(paruser11,ga(paruser11,4,[1 1 1 1],u_max(11),[],[],[0 0 0 0]),[1 1 1 1],u_max(11),[],[],[0 0 0 0]);
                end
                y(j,:)=y_11;
                fvaly(j)=fval11;
            case 12
                [y_12,fval12]=fmincon(paruser12,ga(paruser12,4,[1 1 1 1],u_max(12),[],[],[0 0 0 0]),[1 1 1 1],u_max(12),[],[],[0 0 0 0]);
                while fval12>0
                    [y_12,fval12]=fmincon(paruser12,ga(paruser12,4,[1 1 1 1],u_max(12),[],[],[0 0 0 0]),[1 1 1 1],u_max(12),[],[],[0 0 0 0]);
                end
                y(j,:)=y_12;
                fvaly(j)=fval12;
            case 13
                [y_13,fval13]=fmincon(paruser13,ga(paruser13,4,[1 1 1 1],u_max(13),[],[],[0 0 0 0]),[1 1 1 1],u_max(13),[],[],[0 0 0 0]);
                while fval13>0
                    [y_13,fval13]=fmincon(paruser13,ga(paruser13,4,[1 1 1 1],u_max(13),[],[],[0 0 0 0]),[1 1 1 1],u_max(13),[],[],[0 0 0 0]);
                end
                y(j,:)=y_13;
                fvaly(j)=fval13;
            case 14
                [y_14,fval14]=fmincon(paruser14,ga(paruser14,4,[1 1 1 1],u_max(14),[],[],[0 0 0 0]),[1 1 1 1],u_max(14),[],[],[0 0 0 0]);
                while fval14>0
                    [y_14,fval14]=fmincon(paruser14,ga(paruser14,4,[1 1 1 1],u_max(14),[],[],[0 0 0 0]),[1 1 1 1],u_max(14),[],[],[0 0 0 0]);
                end
                y(j,:)=y_14;
                fvaly(j)=fval14;
            case 15
                [y_15,fval15]=fmincon(paruser15,ga(paruser15,4,[1 1 1 1],u_max(15),[],[],[0 0 0 0]),[1 1 1 1],u_max(15),[],[],[0 0 0 0]);
                while fval15>0
                    [y_15,fval15]=fmincon(paruser15,ga(paruser15,4,[1 1 1 1],u_max(15),[],[],[0 0 0 0]),[1 1 1 1],u_max(15),[],[],[0 0 0 0]);
                end
                y(j,:)=y_15;
                fvaly(j)=fval15;
        end
    end
    %y(:,3)=zeros(1,15);
    %y(:,9)=zeros(1,15);   
    %y(:,14)=zeros(1,15);
    %y(:,16)=zeros(1,15);
    for j=1:15
        q_area_n(j,:,n)=y(j,:);
    end
    y_sum=zeros(4,4);
    for j=1:15
        %for i=0:3
         %   mark=y(j,4*i+1)+y(j,4*i+2)+y(j,4*i+3)+y(j,4*i+4);
         %   if mark<1.99
        %        y(j,4*i+1)=0;
        %        y(j,4*i+2)=0;
       %        y(j,4*i+3)=0;
       %         y(j,4*i+4)=0;
       %     end
       % end
       y_sum(:,u_area(j))=y_sum(:,u_area(j))+y(j,:)';
    end
    fvaly(1)=Copy_2_of_user1(y(1,:),p_area);
    fvaly(2)=Copy_2_of_user2(y(2,:),p_area);
    fvaly(3)=Copy_2_of_user3(y(3,:),p_area);
    fvaly(4)=Copy_2_of_user4(y(4,:),p_area);
    fvaly(5)=Copy_2_of_user5(y(5,:),p_area);
    fvaly(6)=Copy_2_of_user6(y(6,:),p_area);
    fvaly(7)=Copy_2_of_user7(y(7,:),p_area);
    fvaly(8)=Copy_2_of_user8(y(8,:),p_area);
    fvaly(9)=Copy_2_of_user9(y(9,:),p_area);
    fvaly(10)=Copy_2_of_user10(y(10,:),p_area);
    fvaly(11)=Copy_2_of_user11(y(11,:),p_area);
    fvaly(12)=Copy_2_of_user12(y(12,:),p_area);
    fvaly(13)=Copy_2_of_user13(y(13,:),p_area);
    fvaly(14)=Copy_2_of_user14(y(14,:),p_area);
    fvaly(15)=Copy_2_of_user15(y(15,:),p_area);
    fvaly_n(n,1)=user1(y(1,:),p_area);
    fvaly_n(n,2)=user2(y(2,:),p_area);
    fvaly_n(n,3)=user3(y(3,:),p_area);
    fvaly_n(n,4)=user4(y(4,:),p_area);
    fvaly_n(n,5)=user5(y(5,:),p_area);
    fvaly_n(n,6)=user6(y(6,:),p_area);
    fvaly_n(n,7)=user7(y(7,:),p_area);
    fvaly_n(n,8)=user8(y(8,:),p_area);
    fvaly_n(n,9)=user9(y(9,:),p_area);
    fvaly_n(n,10)=user10(y(10,:),p_area);
    fvaly_n(n,11)=user11(y(11,:),p_area);
    fvaly_n(n,12)=user12(y(12,:),p_area);
    fvaly_n(n,13)=user13(y(13,:),p_area);
    fvaly_n(n,14)=user14(y(14,:),p_area);
    fvaly_n(n,15)=user15(y(15,:),p_area);
    total(n)=total(n)-sum(fvaly);
    %y_sum=sum(y,1);
    %y_area=[y_sum(1:4);y_sum(5:8);y_sum(9:12);y_sum(13:16)];
    Qarea=Q_area;
    Q_area_n(:,:,n)=Q_area;
    for k=1:16
        if Qarea(k)>y_sum(k)
            Qarea(k)=y_sum(k);
        end
    end
    for k=1:4
        total(n)=total(n)+Copy_of_task(Qarea(k,:),v(k),w(k,:));
        fval_n(n,k)=Copy_of_task(Qarea(k,:),v(k),w(k,:))-Qarea(k,:)*p_area_t(:,k);
    end
    mismatch(:,:,n)=Q_area-y_sum;
    p_area=p_area+0.004*(Q_area-y_sum);
    p_area(3)=0;
    p_area(8)=0;
    p_area(9)=0;
    p_area(16)=0;
    p_area(p_area<0)=0;
    p_area_n(:,:,n)=p_area;
end
plot(num,total)