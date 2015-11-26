

% Catch equation


eq=sym(str1);

%catch variables

xi % 
xf %


while true
prompt = 'Write your variables or write ok to end\n\n';
str = input(prompt,'s');
if strcmp('ok',str)
break
end
eval([str '=sym('''  str ''');'])
end
% calculates first derivative in respect of x


