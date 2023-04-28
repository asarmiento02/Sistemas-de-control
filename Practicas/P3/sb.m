function funcion_de_transferencia = sb(sistema,variables_simbolicas,valor_real)
%SB La funcion permite sustituir y hacer el diagrama de bode desde una
%funcion de transferencia simbolica, al otorgarle los parametros de
funcion_de_transferencia = subs(sistema,variables_simbolicas,valor_real);
bode(sym2tf(funcion_de_transferencia))
end

