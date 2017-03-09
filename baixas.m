function h = baixas(corte, n, ny, nx)

% corte = frequencia de corte
%n = ordem do filtro
%ny = tamanho y da imagem
%nx = tamanho x da imagem

I = 1;
while (I <= ny),
  J = 1;
  while (J <= nx),
     h(I,J) = 1 / (1 + 0.414*( (((I) ^ 2 + (J) ^ 2) ^ (1/2)) / corte) ^ (2 * n)); %equação do calculo das frequencias
    
     J = J + 1;
  end
  I = I + 1;
end