function WRITE_COEFFICIENT(coefficient, ratio, symbol_char)
  arr_ce_length = max(size(coefficient));
  x = 1:arr_ce_length;
  y = [ratio(x).' coefficient(x).'];
  y = y.';
  fileName = strcat('coefficient_', symbol_char);
  fullName = strcat(fileName, '_.dat');
  fid = fopen(fullName, 'w');
  fprintf(fid, '%11.10f %11.10f\n', y);
  fclose(fid);
end
