function s = DeleteHuiche(str)

char2asc2=abs(str);%转ascii码
char2asc2(char2asc2==13)=[];%删除回车行
char2asc2(char2asc2==10)=[];%删除换行符
s=char(char2asc2);

end