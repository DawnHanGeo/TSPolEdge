function logic = isint(num)
% return a logic value 0 & 1,using to judge input number a int number.
% example : num = 2.3
%           isint(num);
%           ans =0
% must guarantee number being real number.
%author: liheng               IHEP         2012/9/10


if ~isreal(num), error('inputing your number must be a real number. '); end
if num+1 == round(num)+1, logic = 1; end
if num+1 ~= round(num)+1, logic = 0; end
