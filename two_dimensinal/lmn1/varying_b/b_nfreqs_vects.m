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
