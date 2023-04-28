function limites_graficas(polos_deseado,polo_posible,y1,y2)
    %Grafica de la asintota vertical asociada al tiempo de asentamiento,
    %izq cumple derecha no
    hold on
    plot([real(polos_deseado(1)) real(polos_deseado(1))],[5 -5],'r--')
    %Grafica del punto donde se ubican los polos a las condiciones
    %establecidas de Tiempo de asentamiento y overshoot
    hold on
    plot([real(polos_deseado)],[imag(polos_deseado)],'b^')
    %Grafica del punto con la posicion estimada del polo donde se desea
    %colocar
    hold on
    plot([real(polo_posible)],[imag(polo_posible)],'r+')
    %Graficas de las asintotas verticales asociadas al angulo con respecto al eje real 
    %del factor de calidad zeta, superar dicha vertical, puede producir una
    %sobrelongacion mayor a la establecida en design
    hold on
    fplot(y1,[-4,0],'k:')
    hold on
    fplot(y2,[-4,0],'k:')
    %mostrar en grafica la asintota vertical que delimita la seleccion del
    %polo para el tiempo de asentamiento
    text(real(polos_deseado(1))+0.5,-3,strcat('p=',string(real(polos_deseado(1)))))
end
