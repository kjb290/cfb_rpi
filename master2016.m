format bank
%hf=[ 0, 0.25, 0.5, 0.75, 1; ... 
%     0, 1.35, 2.85, 4.1, 5];  
% hf2=[ 0, 0.25, 0.5, 0.75, 1; ... 
%     5, 4.1, 2.85, 1.35 0]; 


% load relavant data from matrix generation
load matrix_index_2016_wk15.mat
scaled=zeros(size(matrix));
teams=fbs;
per_dif=zeros(fbs,2,8);
pred=0;

%partition input by weeks
%week   1    2    3    4    5    6    7    8     9    10    11    12    13    14    15  
row=end_row;%[ 117, 235, 351, 460, 565, 674, 783, 895, 1011, 1123, 1236, 1351, 1465, 1502, 1504];
winners=zeros(fbs,15);
outcomes=zeros(fbs,15);
week=15;

% add columns to matrix [fcs loses,win%, wins, loses, games]
matrix=[matrix,zeros(size(matrix,1),5)];

% add fbs losses
matrix(:,size(matrix,1)+1)=non_fbs_loss;

% capping margin of victory
cap=28;

for i=1:1:size(matrix,1)
    wins=0;
    loses=0;
    games=0;
    for j=1:1:size(matrix,1)
        if matrix(i,j) > 0
            wins=wins+1;
        elseif matrix(i,j) < 0
            loses=loses+1;
        end
    end
    games=wins+loses;
    matrix(i,size(matrix,1)+3)=wins;
    matrix(i,size(matrix,1)+4)=loses;
    matrix(i,size(matrix,1)+5)=games+matrix(i,fbs+1);
    matrix(i,size(matrix,1)+2)=wins/(games+matrix(i,fbs+1));
    
end

%add in cusa title game, wk=88, latech=79, final wk+14
matrix(88,size(matrix,1)+3)=matrix(88,size(matrix,1)+3)+1;
matrix(88,size(matrix,1)+5)=matrix(88,size(matrix,1)+5)+1;
matrix(88,size(matrix,1)+2)=matrix(88,size(matrix,1)+3)/matrix(88,size(matrix,1)+5);

matrix(79,size(matrix,1)+4)=matrix(88,size(matrix,1)+4)+1;
matrix(79,size(matrix,1)+5)=matrix(88,size(matrix,1)+5)+1;
matrix(79,size(matrix,1)+2)=matrix(88,size(matrix,1)+3)/matrix(88,size(matrix,1)+5);

%add in mw title game, wk=88, latech=79, final wk+14
matrix(110,size(matrix,1)+3)=matrix(110,size(matrix,1)+3)+1;
matrix(110,size(matrix,1)+5)=matrix(110,size(matrix,1)+5)+1;
matrix(110,size(matrix,1)+2)=matrix(110,size(matrix,1)+3)/matrix(110,size(matrix,1)+5);

matrix(113,size(matrix,1)+4)=matrix(113,size(matrix,1)+4)+1;
matrix(113,size(matrix,1)+5)=matrix(113,size(matrix,1)+5)+1;
matrix(113,size(matrix,1)+2)=matrix(113,size(matrix,1)+3)/matrix(113,size(matrix,1)+5);

m=matrix;

for i=1:teams %loop through teams (rows)
win=0;
loss=0;
for j=1:teams % loop through opponents  
    opp_win=m(j,size(m,2)-3);
    if m(i,j) > 0 % check for win

        if m(i,j)>cap  %cap margin at 28 
            m(i,j)=cap;
        end
        
        scaled(i,j)=m(i,j)/cap+((m(j,teams+3)+1.7)/m(j,teams+5)+0.3)^1.5;
        win=win+scaled(i,j);
        
    elseif m(i,j) < 0 %this is loss

        
        if m(i,j)<(-1*cap)
            m(i,j)=(-1*cap);
        end
        temp(i,j)=abs(m(i,j));
        scaled(i,j)=-(temp(i,j)/cap)+(opp_win^.4-1.15);
        loss=loss+abs(scaled(i,j));
        
    end
    
end
wa(i,1)=win;
la(i,1)=loss;
adj_win(i,1)=win/(m(i,fbs+3)+loss+2*m(i,fbs+1));
end



m=[m,adj_win,wa,la];

%add in cusa title game, wk=88, latech=79, final wk+14
m(88,size(m,2)-1)=m(88,size(m,2)-1)+1.639417384437295;
m(88,size(m,2)-2)=m(88,size(m,2)-1)/(m(88,fbs+3)+m(88,fbs+8)+2*m(88,fbs+1));


m(79,size(m,2))=m(79,size(m,2))+0.769602256565828;
m(79,size(m,2)-2)=m(79,size(m,2)-1)/(m(79,fbs+3)+m(79,fbs+8)+2*m(79,fbs+1));


%add in mw title game, wk=88, latech=79, final wk+14
m(110,size(m,2)-1)=m(110,size(m,2)-1)+1.246560241580152;
m(110,size(m,2)-2)=m(110,size(m,2)-1)/(m(110,fbs+3)+m(110,fbs+8)+2*m(110,fbs+1));


m(113,size(m,2))=m(113,size(m,2))+0.376745113708686;
m(113,size(m,2)-2)=m(113,size(m,2)-1)/(m(113,fbs+3)+m(113,fbs+8)+2*m(113,fbs+1));


%calculate average adjusted opponents win %
for i=1:teams %loop through teams (rows)
count=0;
owp=0;
for j=1:teams % loop through opponents  
    
    if scaled(i,j)>0
        count=count+1;
        owp=owp+(m(j,teams+7)/(m(j,teams+7)+m(j,teams+8)+scaled(j,i)));
    elseif scaled(i,j)<0
        count=count+1;
        owp=owp+((m(j,teams+7)-scaled(j,i))/(m(j,teams+7)+m(j,teams+8)-scaled(j,i)));
    end
    
end
oppw(i,1)=owp/count;
end

m=[m,oppw];

% add in here
%m(43,129)=((m(43,129)*11)+m(38,127)/(m(38,123)+m(38,128)-scaled(38,43)-0.33804))/12;
%m(38,129)=((m(38,129)*11+m(43,127)-scaled(43,38)-1.047698)/(m(38,123)+m(38,128)))/12;

%calculate average adjusted opponents opponents win %
for i=1:teams %loop through teams (rows)
count=0;
owp=0;
for j=1:teams % loop through opponents  -6 for extra columns
    
    if m(i,j)~=0
        count=count+1;
        owp=owp+m(j,end);
    end
    
end
oppoppw(i,1)=owp/count;
end

m=[m,oppoppw];

[y,h]=max(m(:,fbs+6));
%scale factors
sc1=1.00; % opp
sc2=0; % opp opp
%ywp=(1-sc1*m(h,fbs+9)-sc2*m(h,fbs+10))/(m(h,fbs+6)-sc1*m(h,fbs+9)-sc2*m(h,fbs+10));
ywp=59;
yowp=30;
yoowp=11;
format long
RPI=m(:,teams+6)*ywp + m(:,teams+9)*yowp + m(:,teams+10)*yoowp;
[RPIa,team]=sort(RPI,'descend');






%read in team names
[dummy, strings]=xlsread('cfbscores_with_numbers_v2016.xlsx','teams','A2:D129');

output={num2cell(RPIa),strings(team,:)};
a=strings(team,:);
b=num2cell(RPIa);
c1=num2cell(oppw(team));
d1=num2cell(oppoppw(team));
e1=num2cell(m(team,end-4));
f1=num2cell(m(team,end-7));
g1=num2cell(m(team,end-3));
h1=num2cell(m(team,end-6));
i1=num2cell(m(team,end-2));
hold1=m(:,end-1);
hold2=m(:,end);
c=hold1(team,:);
d=hold2(team,:);

xlswrite('cfbscores_with_numbers_v2016.xlsx',a,'rankings_wk15','B2:B129');
xlswrite('cfbscores_with_numbers_v2016.xlsx',b,'rankings_wk15','C2:C129');
xlswrite('cfbscores_with_numbers_v2016.xlsx',c1,'rankings_wk15','D2:D129');
xlswrite('cfbscores_with_numbers_v2016.xlsx',d1,'rankings_wk15','E2:E129');
xlswrite('cfbscores_with_numbers_v2016.xlsx',e1,'rankings_wk15','F2:F129');
xlswrite('cfbscores_with_numbers_v2016.xlsx',f1,'rankings_wk15','G2:G129');
xlswrite('cfbscores_with_numbers_v2016.xlsx',g1,'rankings_wk15','H2:H129');
xlswrite('cfbscores_with_numbers_v2016.xlsx',h1,'rankings_wk15','I2:I129');
xlswrite('cfbscores_with_numbers_v2016.xlsx',i1,'rankings_wk15','J2:J129');

%toughest schedule rankings
%[oppwa,team]=sort(oppw,'descend');
%e=strings(team,:);
%f=num2cell(oppwa);
%xlswrite('cfbscores_with_numbers_v2014.xlsx',e,'rankings_wk12','H2:H129');
%xlswrite('cfbscores_with_numbers_v2014.xlsx',f,'rankings_wk12','I2:I129');

save matrix_index_2016_wk15.mat RPI scaled m -append
