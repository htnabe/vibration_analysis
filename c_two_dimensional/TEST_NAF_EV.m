function TEST_NAF_EV(V, LAMBDA, N)
  itr_cnt = max(size(N));
  for cnt = 1:itr_cnt
    [t_V(:,:,cnt), t_LAMBDA(:,:,cnt)] = eigs(N(:,:,cnt));
  end
  is_eigen_vector_same = isequal(V, t_V);
  if !is_eigen_vector_same
    disp('Size of the vectors of main process: '), disp(size(V));
    disp('Size of the vectors of test: '), disp(size(t_V));
    error('Eigen vectors of the main process and those of test are not the same.');      
  end
  is_NAF_same = isequal(LAMBDA, t_LAMBDA);
  if !is_NAF_same
    disp('Size of the values of main process: '), disp(size(LAMBDA));
    disp('Size of the values of test: '), disp(size(t_LAMBDA));
    error('Frequencies are not the same.')
  end
  disp('Eigen vectors and natural angular frequencies passed the TEST!');
end