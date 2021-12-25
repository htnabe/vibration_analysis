function TEST_BCD(coefficients, N11, N12, N13, N21, N22, N23, N31, N32, N33)
  t_B = N11 + N22 + N33;
  t_C = N23.^2 +N12.^2 + N13.^2 - N11.*N22 - N11.*N33 - N22.*N33;
  t_D = 2*N12.*N23.*N13 - (N23.^2).*N11 - (N12.^2).*N33 - (N13.^2).*N22 + N11.*N22.*N33;
  
  t_coefficient = [t_B, t_C, t_D];
  is_coefficient_same = isequal(t_coefficient, coefficients);
  if !is_coefficient_same
    index = find((t_coefficient==coefficients)==0);
    disp('Different index of coefficient: '), disp(index);
    error('Wrong coefficient(s) is inputted.');
  end
end