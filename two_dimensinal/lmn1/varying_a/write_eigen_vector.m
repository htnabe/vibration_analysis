function write_eigen_vector(cnt, measure, eigen_vector, num)
  x = 1:cnt-1;
  v = [measure(x).' eigen_vector(:,x).'];
  v = v.';
  num = int2str(num);
  fileName = strcat('a_vect',num);
  fullName = strcat(fileName, '.dat');
  fid = fopen(fullName, 'w');
  fprintf(fid, '%11.10f %11.10f %11.10f %11.10f\n', v);
  fclose(fid);
end
