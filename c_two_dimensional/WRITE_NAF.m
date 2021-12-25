function WRITE_NAF(naf, ratio_young, num)
  arr_length = max(size(ratio_young));
  x = 1:arr_length;
  v = [ratio_young(x).' naf(x).'];
  v = v.';
  num = int2str(num);
  fileName = strcat('naf',num);
  fullName = strcat(fileName, '.dat');
  fid = fopen(fullName, 'w');
  fprintf(fid, '%11.10f %11.10f\n', v);
  fclose(fid);
end
