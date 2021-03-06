# calculate natural angular frequencies and vectors varying b
clear;
disp ('Start')

a = 0.100; c = 0.050; # length a, thickness c
r = 1.52*10^3; # density
E_xx = 148*10^9; E_yy = 10.50*10^9; # axial + vertical young's modulus
E_zz = E_yy; # two dimensinal orthotropy's condition
n_xy = 0.30; n_yz = 0.59; n_xz = 0.30; # poisson's ratio
n_yx = (E_yy * n_xy)/E_xx; # two dimensinal orthotropy's condition
n_zy = E_zz * n_yz/E_yy;
n_zx = E_zz * n_xz/E_xx;

for array = [n_yx n_zy n_zx]
  test_poisson(array);
end

Q_xyxy = 5.61*10^9; Q_yzyz = 3.17*10^9; # modulus of rigidity
Q_xzxz = Q_xyxy; # two dimensinal orthotropy's condition
l = m = n = 1; # mode degree

test_variables(a, c, r, E_xx, E_yy, E_zz, n_xy, n_yz, n_xz, Q_xyxy, Q_yzyz, Q_xzxz);

Delta = 1 - n_xy * n_yx - n_xz * n_zx - n_yz * n_zy - n_xy * n_yz * n_zx - n_xz * n_yx * n_zy;
Q_xxxx = E_xx * ((1 - n_yz * n_zy)/Delta);
Q_xxyy = E_xx * ((n_yx + n_yz * n_zx)/Delta);
Q_xxzz = E_xx * ((n_zx + n_yx * n_zy)/Delta);
Q_yyyy = E_yy * ((1 - n_xz * n_zx)/Delta);
Q_yyzz = E_yy * ((n_zy + n_xy * n_zx)/Delta);
Q_zzzz = E_zz * ((1 - n_xy * n_yx)/Delta);

# havenothing with iteration
N_13 = (Q_xxzz + Q_xzxz)*(l*n*pi^2)/(a*c);
N_31 = (Q_xxzz + Q_xzxz) * (l*n*pi^2)/(a*c);
N_11_term = Q_xxxx * ((l*pi)/a)^2 + Q_xzxz * ((n*pi)/c)^2;
N_22_term = Q_xyxy * ((l*pi)/a)^2 + Q_yzyz * ((n*pi)/c)^2;
N_33_term = Q_xzxz * ((l*pi)/a)^2 + Q_zzzz * ((n*pi)/c)^2;

# Arrays consist of elements to be tested
measures = [a, c];
young_modulus = [E_xx, E_yy, E_zz];
poisson_ratios = [n_xy, n_yz, n_xz, n_yx, n_zy, n_zx];
modulus_rigidity = [Q_xyxy, Q_yzyz, Q_xzxz];
Qs = [Q_xxxx, Q_xxyy, Q_xxzz, Q_yyyy, Q_yyzz, Q_zzzz];
part_Ns = [N_11_term, N_22_term, N_33_term, N_13, N_31];
mode_degrees = [l, m, n];

test_not_itr_related_variables(measures, young_modulus, poisson_ratios, modulus_rigidity, Delta, Qs, part_Ns, mode_degrees);

# make randam array(100) for test in iteration
is_enough_randum_num = false;
while(!is_enough_randum_num)
  randum_num_array = round((14000 - 1).*rand(100, 1)+1); # 1 < randum number < 14000
  unique_num_array = unique(randum_num_array);
  unique_size = size(unique_num_array)(1);
  if(unique_size == 100)
    is_enough_randum_num = true;
  end
end

disp ('Now Calculating')
for cnt = 1:14001
  b = 10^(-5+0.0005*(cnt-1));
  measure(cnt) = b;
  N_11 =  Q_xyxy * ((m*pi)/b)^2 + N_11_term;
  N_12 = (Q_xyxy + Q_xxyy)*(l*m*pi^2)/(a*b);
  N_21 = (Q_xyxy + Q_xxyy)*(l*m*pi^2)/(a*b);
  N_22 = N_22_term + Q_yyyy * ((m*pi)/b)^2;
  N_23 = (Q_yyzz + Q_yzyz) * (m*n*pi^2)/(b*c);
  N_32 = (Q_yyzz + Q_yzyz) * (m*n*pi^2)/(b*c);
  N_33 = N_33_term + Q_yzyz * ((m*pi)/b)^2;
  N = [N_11, N_12, N_13; N_21, N_22, N_23; N_31, N_32, N_33];

  # test the values in this iteration, but only for powers of 10
  exist_row = find(randum_num_array == cnt);
  if(size(exist_row)(1) == 1)  # if false, this should be 0.
    test_itr_related_variables(b, measures, modulus_rigidity, Qs, mode_degrees, part_Ns, N);
  end
  
  [V(:,:,cnt), LAMBDA(:,:,cnt)] = eig (N);

  # make one of an eigen vector's element plus
  if (V(:,1,cnt)(2) >0),
    N_vec_1(:,cnt) = V(:,1,cnt);
  else
    N_vec_1(:,cnt) = -V(:,1,cnt);
  endif
  if (V(:,2,cnt)(2) >0),
    N_vec_2(:,cnt) = V(:,2,cnt);
  else
    N_vec_2(:,cnt) = -V(:,2,cnt);
  endif
  if (V(:,3,cnt)(2) >0),
    N_vec_3(:,cnt) = V(:,3,cnt);
  else
    N_vec_3(:,cnt) = -V(:,3,cnt);
  endif

  if (LAMBDA(2,2,cnt)>0),
    N_freq_2(cnt) = sqrt(LAMBDA(2,2,cnt)/r);
  else
    N_freq_2(cnt) = nan;
  end;
  if (LAMBDA(3,3,cnt)>0),
    N_freq_3(cnt) = sqrt(LAMBDA(3,3,cnt)/r);
  else
    N_freq_3(cnt) = nan;
  end;
  if (LAMBDA(1,1,cnt)>0),
    N_freq_1(cnt) = sqrt(LAMBDA(1,1,cnt)/r);
  else
    N_freq_1(cnt) = nan;
  end;
  cnt++;
endfor

# write data on files
write_naf(cnt, measure, N_freq_1, 1);
write_naf(cnt, measure, N_freq_2, 2);
write_naf(cnt, measure, N_freq_3, 3);
write_eigen_vector(cnt, measure, N_vec_1, 1);
write_eigen_vector(cnt, measure, N_vec_2, 2);
write_eigen_vector(cnt, measure, N_vec_3, 3);
