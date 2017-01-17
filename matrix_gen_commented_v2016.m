% Take overall data and put into score matrix, also create and fill game
% line data in same form (game lines seem to be backwards showing the
% undedog with the -points)

%current total number of fbs teams
fbs=128;

% allocate score matrix
matrix=zeros(fbs);
mat2=matrix;
home=mat2;
%non fbs losses
non_fbs_loss=zeros(fbs,1);

% allocate game line matrix
%game_line=zeros(fbs);

% find rows where data stops for each week of season, manually evaluate
% from excel spreadsheet for now, -1 to get txt file
end_row=[1, 87, 162, 229, 288, 350, 404, 458, 515, 569, 630, 689, 754, 815, 829]; 

% copy and paste formatted tab from spreadsheet into txt file (for now)
load input2016_wk15.txt

for j=1:1:size(end_row,2)
input2=input2016_wk15(1:end_row(1,j),:);
%non fbs losses
non_fbs_loss=zeros(fbs,1);
%loop through rows of input file and put score and game line of FBS games
%into matrix
for i=1:1:size(input2,1)
    if input2(i,3)<(fbs+1) && input2(i,6)<(fbs+1) % only conside FBS
        if input2(i,2)==1 % check for home
            matrix(input2(i,3),input2(i,6))=input2(i,4)-input2(i,7)+.5; % add half point to indicate home team
            matrix(input2(i,6),input2(i,3))=input2(i,7)-input2(i,4);
            mat2(input2(i,3),input2(i,6))=input2(i,4)-input2(i,7);
            mat2(input2(i,6),input2(i,3))=input2(i,7)-input2(i,4);
            home(input2(i,3),input2(i,6))=1;
            home(input2(i,6),input2(i,3))=-1;
            %game_line(input2(i,1),input2(i,10))=input2(i,20);
        elseif input2(i,5)==0
            matrix(input2(i,3),input2(i,6))=input2(i,4)-input2(i,7);
            matrix(input2(i,6),input2(i,3))=input2(i,7)-input2(i,4);
            mat2(input2(i,3),input2(i,6))=input2(i,4)-input2(i,7);
            mat2(input2(i,6),input2(i,3))=input2(i,7)-input2(i,4);
            home(input2(i,6),input2(i,3))=-1;
            home(input2(i,3),input2(i,6))=-1;
        else
            matrix(input2(i,3),input2(i,6))=input2(i,4)-input2(i,7);
            matrix(input2(i,6),input2(i,3))=input2(i,7)-input2(i,4)+.5;
            mat2(input2(i,3),input2(i,6))=input2(i,4)-input2(i,7);
            mat2(input2(i,6),input2(i,3))=input2(i,7)-input2(i,4);
            home(input2(i,6),input2(i,3))=1;
            home(input2(i,3),input2(i,6))=-1;
            %game_line(input2(i,1),input2(i,10))=input2(i,20);
        end
    else
        if input2(i,3)>fbs
            non_fbs_loss(input2(i,6),1)=non_fbs_loss(input2(i,6),1)+1;
        end
    end
end


eval(['save matrix_index_2016_wk',num2str(j),'.mat matrix mat2 home input2 fbs end_row  non_fbs_loss'])

end
