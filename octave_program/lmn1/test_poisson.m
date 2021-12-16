function test_poisson(n)
  if (n >= 1)
    disp('Invalid poisson raio is inputted(more than 1). This result is unreliable.\n');
  elseif ( n < 0)
    disp('Suspicious poisson raio is inputted(less than 0). This result is unreliable.\n');
  end
end
