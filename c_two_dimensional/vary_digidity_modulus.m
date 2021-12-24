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

Ex = [8*10^9:10^8:150*10^9];
nyx = Ey*nxy./Ex;
nzx = Ez*nxz./Ex;
nzy = Ez*nyz/Ey;

young_modulus = [Ex, Ey, Ez];
poisson_ratio = [nxy, nxz, nyz, nyx, nzx, nzy];
TEST_POISSON(young_modulus, poisson_ratio);

Delta = 1 - nxy*nyx - nxz*nzx - nyz*nzy - 2*nxy*nyz*nzx;
Qxx = Ex .* ((1 - nyz.*nzy)./Delta);
Qxy = Ex .* ((nyx + nyz.*nzx)./Delta);
Qxz = Ex .* ((nzx + nyx.*nzy)./Delta);
Qyy = Ey * ((1 - nxz.*nzx)/Delta);
Qyz = Ey * ((nzy + nxy.*nzx)/Delta);
Qzz = Ez * ((1 - nxy.*nyx)/Delta);

Qs = [Qxx, Qxy, Qxz, Qyy, Qyz, Qzz];
TEST_DELTA_Q_PARAMS(Delta, nxy, nxz, nyz, nyx, nzx, nzy, Ex, Ey, Ez, Qs);

N11 = Qxx*((l*pi)/a)^2 + Gxy*((m*pi)/b)^2 + Gxz*((n*pi)/c)^2;
N12 = (Qxy + Gxy)*(l*m*pi^2)/(a*b);
N13 = (Qxz + Gxz)*(l*n*pi^2)/(a*c);
N21 = (Qxy + Gxy)*(l*m*pi^2)/(a*b);
N22 = Gxy*((l*pi)/a)^2 + Gyz*((n*pi)/c)^2 + Qyy*((m*pi)/b)^2;
N23 = (Qyz + Gyz)*(m*n*pi^2)/(b*c);
N31 = (Qxz + Gxz)*(l*n*pi^2)/(a*c);
N32 = (Qyz + Gyz)*(m*n*pi^2)/(b*c);
N33 = Gxz*((l*pi)/a)^2 + Qzz*((n*pi)/c)^2 + Gyz*((m*pi)/b)^2;
N = [N11, N12, N13; N21, N22, N23; N31, N32, N33];

mode_degree = [l, m, n]
TEST_N(Qxx, Qxy, Qxz, Qyy, Qyz, Qzz, digidity_modulus, mode_degree, measures, N);

B = N11 + N22 + N33;
C = N23.^2 + N12.^2 + N13.^2 - N11.*N22 - N11.*N33 - N22.*N33;
D = 2.*N12.*N23.*N13 - (N23.^2).*N11 - (N12.^2).*N33 - (N13.^2).*N22 + N11.*N22.*N33;
TEST_BCD(B, C, D, N11, N12, N13; N21, N22, N23; N31, N32, N33);
