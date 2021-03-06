# calculate C of the discriminant
clear;
a = 0.1;                    # length
b = 0.5;                    # width
c = 0.05;                   # thickness
Gxy = Gxz = 5.61 * 10^9;    # modulus of digidity
Gyz = 3.17 * 10^9;
Ey  = Ez = 10.50 * 10^9;    # young's modulus
nxy = nxz = 0.45;           # change here
nyz = 0.59;
l = m = n = 1;

measures = [a, b, c];
digidity_modulus = [Gxy, Gxz, Gyz];
TEST_VARIABLES(measures, digidity_modulus);

Ex = [9.4*10^9:10^7:100*10^9];
nyx = Ey*nxy./Ex;
nzx = Ez*nxz./Ex;
nzy = Ez*nyz/Ey;

young_modulus = [Ex, Ey, Ez];
poisson_ratio = [nxy, nxz, nyz, nyx, nzx, nzy];
TEST_POISSON(young_modulus, poisson_ratio);

Delta = 1 - nxy.*nyx - nxz.*nzx - nyz*nzy - 2*nxy*nyz.*nzx;
Qxx = Ex.*(1 - nyz*nzy)./Delta;
Qxy = Ex.*(nyx + nyz.*nzx)./Delta;
Qxz = Ex.*(nzx + nyx.*nzy)./Delta;
Qyy = Ey*(1 - nxz.*nzx)./Delta;
Qyz = Ey*(nzy + nxy.*nzx)./Delta;
Qzz = Ez*(1 - nxy.*nyx)./Delta;

Qs = [Qxx, Qxy, Qxz, Qyy, Qyz, Qzz];
TEST_DELTA_Q_PARAMS(Delta, nxy, nxz, nyz, nyx, nzx, nzy, Ex, Ey, Ez, Qs);

N11 = (pi^2)*(Qxx*((l/a)^2) + Gxy*((m/b)^2) + Gxz*((n/c)^2));
N12 = (pi^2)*((Qxy + Gxy)*(l*m)/(a*b));
N13 = (pi^2)*((Qxz + Gxz)*(l*n)/(a*c));
N21 = N12;
N22 = (pi^2)*(Gxy*((l/a)^2) + Gyz*((n/c)^2) + Qyy*((m/b)^2));
N23 = (pi^2)*((Qyz + Gyz)*(m*n)/(b*c));
N31 = N13;
N32 = N23;
N33 = (pi^2)*(Gxz*((l/a)^2) + Qzz*((n/c)^2) + Gyz*((m/b)^2));
N = [N11, N12, N13; N21, N22, N23; N31, N32, N33];

mode_degree = [l, m, n];
TEST_N(Qxx, Qxy, Qxz, Qyy, Qyz, Qzz, digidity_modulus, mode_degree, measures, N);

B = N11 + N22 + N33;
C = N23.^2 + N12.^2 + N13.^2 - N11.*N22 - N11.*N33 - N22.*N33;
D = 2.*N12.*N23.*N13 - (N23.^2).*N11 - (N12.^2).*N33 - (N13.^2).*N22 + N11.*N22.*N33;

coefficient_discriminant = [B, C, D];
TEST_BCD(coefficient_discriminant, N11, N12, N13, N21, N22, N23, N31, N32, N33);

density = 1.52*10^3;
N_arr_size = max(size(N11));
for cnt = 1:N_arr_size
  matrix_N(:,:,cnt) = [N11(cnt), N12(cnt), N13(cnt); N21(cnt), N22(cnt), N23(cnt); N31(cnt), N32(cnt), N33(cnt)];
  [V(:,:,cnt), LAMBDA(:,:,cnt)] = eigs (matrix_N(:,:,cnt));

  # LAMBDA(1) is the biggest => omega3. phi1 => vector3.
  vect3(:,cnt) = V(:,1,cnt);
  vect2(:,cnt) = V(:,2,cnt);
  vect1(:,cnt) = V(:,3,cnt);

  # negative N. A. F. is 'nan'.
  if LAMBDA(1,1,cnt)>0
    freq3(cnt) = sqrt(LAMBDA(1,1,cnt)/density);
  else
    freq3(cnt) = nan;
  end
  if LAMBDA(2,2,cnt)>0
    freq2(cnt) = sqrt(LAMBDA(2,2,cnt)/density);
  else
    freq2(cnt) = nan;
  end
  if LAMBDA(3,3,cnt)>0
    freq1(cnt) = sqrt(LAMBDA(3,3,cnt)/density);
  else
    freq1(cnt) = nan;
  end
end

TEST_NAF_EV(V, LAMBDA, matrix_N);
disp('PASSED ALL TESTS! YOU ARE SUPER GENIUS!');

# write coefficients and young-ratios on the same files
ratio_young = Ex./Ey;
WRITE_COEFFICIENT(B, ratio_young, 'B');
WRITE_COEFFICIENT(C, ratio_young, 'C');
WRITE_COEFFICIENT(D, ratio_young, 'D');

# write delta's data
WRITE_COEFFICIENT(Delta, ratio_young, 'delta');

# write natural angular frequencies and eigen vectors on files
WRITE_NAF(freq1, ratio_young, 1);
WRITE_NAF(freq2, ratio_young, 2);
WRITE_NAF(freq3, ratio_young, 3);
WRITE_EV(vect1, ratio_young, 1);
WRITE_EV(vect2, ratio_young, 2);
WRITE_EV(vect3, ratio_young, 3);