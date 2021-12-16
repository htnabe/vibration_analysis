# calculate natural angular frequencies and vectors varying a
clear;
disp ("Start\n")

b = 0.500; c = 0.050; # 幅b，厚さc
r = 1.52*10^3; # 密度
E_xx = 148*10^9; E_yy = 10.50*10^9; # 繊維方向弾性率，繊維垂直方向弾性率
E_zz = E_yy; # 二次元直交異方性材料の場合の仮定
n_xy = 0.30; n_yz = 0.59; n_xz = 0.30; # ポアソン比
n_yx = (E_yy * n_xy)/E_xx; # 推測されるポアソン比
n_zy = E_zz * n_yz/E_yy;
n_zx = E_zz * n_xz/E_xx;

for array = [n_yx n_zy n_zx]
  test_poisson(array);
end

Q_xyxy = 5.61*10^9; Q_yzyz = 3.17*10^9; # せん断弾性係数
Q_xzxz = Q_xyxy; # 二次元直交異方性材料の場合の仮定
l = m = n = 1; # モード次数

Delta = 1 - n_xy * n_yx - n_xz * n_zx - n_yz * n_zy - n_xy * n_yz * n_zx - n_xz * n_yx * n_zy;
Q_xxxx = E_xx * ((1 - n_yz * n_zy)/Delta);
Q_xxyy = E_xx * ((n_yx + n_yz * n_zx)/Delta);
Q_xxzz = E_xx * ((n_zx + n_yx * n_zy)/Delta);
Q_yyyy = E_yy * ((1 - n_xz * n_zx)/Delta);
Q_yyzz = E_yy * ((n_zy + n_xy * n_zx)/Delta);
Q_zzzz = E_zz * ((1 - n_xy * n_yx)/Delta);

# for分に関係ない部分
N_11_term = Q_xyxy * ((m*pi)/b)^2 + Q_xzxz * ((n*pi)/c)^2;
N_22_term = Q_yzyz * ((n*pi)/c)^2 + Q_yyyy * ((m*pi)/b)^2;
N_33_term = Q_zzzz * ((n*pi)/c)^2 + Q_yzyz * ((m*pi)/b)^2;

for cnt = 1:14001
  a = 10^(-5+0.0005*(cnt-1));
  measure(cnt) = a;
  N_11 = Q_xxxx * ((l*pi)/a)^2 + N_11_term;
  N_12 = (Q_xyxy + Q_xxyy)*(l*m*pi^2)/(a*b);
  N_13 = (Q_xxzz + Q_xzxz)*(l*n*pi^2)/(a*c);
  N_21 = (Q_xyxy + Q_xxyy)*(l*m*pi^2)/(a*b);
  N_22 = Q_xyxy * ((l*pi)/a)^2 + N_22_term;
  N_23 = (Q_yyzz + Q_yzyz) * (m*n*pi^2)/(b*c);
  N_31 = (Q_xxzz + Q_xzxz) * (l*n*pi^2)/(a*c);
  N_32 = (Q_yyzz + Q_yzyz) * (m*n*pi^2)/(b*c);
  N_33 = Q_xzxz * ((l*pi)/a)^2 + N_33_term;
  N = [N_11, N_12, N_13; N_21, N_22, N_23; N_31, N_32, N_33];
  [V(:,:,cnt), LAMBDA(:,:,cnt)] = eig (N);

  # 各ベクトルの第２成分（y軸方向成分）を常に正にする
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

  # 固有値が正なら固有角振動数が存在する
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

# 固有角振動数の書き込み
write_naf(cnt, measure, N_freq_1, 1);
write_naf(cnt, measure, N_freq_2, 2);
write_naf(cnt, measure, N_freq_3, 3);

# 固有ベクトルの書き込み
write_eigen_vector(cnt, measure, N_vec_1, 1);
write_eigen_vector(cnt, measure, N_vec_2, 2);
write_eigen_vector(cnt, measure, N_vec_3, 3);
