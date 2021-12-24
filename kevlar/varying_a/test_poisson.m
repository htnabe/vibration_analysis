function test_poisson(n)
  if (n >= 1)
    error('Invalid poisson raio is inputted(more than 1).');
  elseif ( n < 0)
    error('Suspicious poisson raio is inputted(less than 0).');
  end
end
