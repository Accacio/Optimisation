

% Catch equation

prompt = 'Write your equation\n\n';
str1 = input(prompt,'s');
eq=sym(str1);

%catch variables

while true
prompt = 'Write your variables or write ok to end\n\n';
str = input(prompt,'s');
if strcmp('ok',str)
break
end
eval([str '=sym('''  str ''');'])
end
% calculates first derivative in respect of x
diff(str1,x)
