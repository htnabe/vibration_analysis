function TEST_POISSON(young_modulus, poisson_ratio)
  t_Ex = [9.5*10^9:10^8:100*10^9];
  t_Ey = t_Ez = 10.50 * 10^9;
  t_nxy = t_nxz = 0.45;
  t_nyz = 0.59;
  t_nyx = t_Ey*t_nxy./t_Ex;
  t_nzx = t_Ez*t_nxz./t_Ex;
  t_nzy = t_Ez*t_nyz/t_Ey;
  
  t_poisson_ratio = [t_nxy, t_nxz, t_nyz, t_nyx, t_nzx, t_nzy];

  is_poisson_ratio_same = isequal(t_poisson_ratio, poisson_ratio);
  if !is_poisson_ratio_same
      index = find((t_poisson_ratio==poisson_ratio)==0);
      disp('Different index of N: '), disp(index);
      error('Wrong poisson ratio is inputted.');
  end

  poisson_not_include_nyz = [t_nxy, t_nxz, t_nyx, t_nzx];

  more_than_criteria = find(poisson_not_include_nyz>0.5);
  less_than_criteria = find(poisson_not_include_nyz<0);
  is_invalid_poisson = size(more_than_criteria)(2);
  is_poisson_ratio_minus = size(less_than_criteria)(2);

  if is_invalid_poisson
    disp('Invalid poisson ratio index: '),disp(more_than_criteria);
    error('Invalid poisson ratio is inputted(more than 0.5).');
  elseif is_poisson_ratio_minus
    disp('Suspicious poisson ratio index: '),disp(less_than_criteria);
    error('Invalid poisson ratio is inputted(less than 0).');
  end
  
  t_young_modulus = [t_Ex, t_Ey, t_Ez];  
  is_young_modulus_same = isequal(young_modulus, t_young_modulus);
  if !is_young_modulus_same
      index = find((young_modulus==t_young_modulus)==0);
      disp('Index of different N: '), disp(index);
      error('Wrong poisson ratio is inputted.');
  end
  disp('Poisson ratios passed TEST!');
end
