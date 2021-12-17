function write_naf(cnt, measure, naf, num)
  x = 1:cnt-1;
  y = [measure(x).' naf(x).'];
  y = y.';
  num = int2str(num);
  fileName = strcat('b_freq',num);
  fullName = strcat(fileName, '.dat');
  fid = fopen(fullName, 'w');
  fprintf(fid, '%11.10f %11.10f\n', y);
  fclose(fid);
end
