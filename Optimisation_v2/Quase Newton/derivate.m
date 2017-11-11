function [f_deriv] = deriv(expr, variab)
    f = expr;
    syms variab;
    f_deriv = diff(f);
    clear variab;
end
