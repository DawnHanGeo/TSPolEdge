function s = DeleteHuiche(str)

char2asc2=abs(str);%תascii��
char2asc2(char2asc2==13)=[];%ɾ���س���
char2asc2(char2asc2==10)=[];%ɾ�����з�
s=char(char2asc2);

end