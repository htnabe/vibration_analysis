# test Q_ijkl and N_mn_term
function test_not_itr_related_variables(measures_density, young_modulus, poisson_ratios, modulus_rigidity, d, Qs, part_Ns, mode_degrees)
    # values from the main program = values to be tested
    width = measures_density(1);
    thickness = measures_density(2);
    density = measures_density(3);
    Ex = young_modulus(1);
    Ey = young_modulus(2);
    Ez = young_modulus(3);
    nxy = poisson_ratios(1);
    nyz = poisson_ratios(2); 
    nxz = poisson_ratios(3);
    nyx = poisson_ratios(4);
    nzy = poisson_ratios(5);
    nzx = poisson_ratios(6);
    Gxy = modulus_rigidity(1);
    Gyz = modulus_rigidity(2);
    Gxz = mode_degrees(3);
    Qxx = Qs(1);
    Qxy = Qs(2);
    Qxz = Qs(3);
    Qyy = Qs(4);
    Qyz = Qs(5);
    Qzz = Qs(6);
    part_N11 = part_Ns(1);
    part_N22 = part_Ns(2);
    part_N33 = part_Ns(3);
    l = mode_degrees(1);
    m = mode_degrees(2);
    n = mode_degrees(3);

    # values to be used in the test
    t_d = 1 - nxy*nyx - nxz*nzx - nyz*nzy - 2*nxy*nyz*nzx;
    t_Qxx = Ex*(1 - nyz*nzy)/t_d;
    t_Qxy = Ex*(nyx + nyz*nzx)/t_d;
    t_Qxz = Ex*(nzx + nyx*nzy)/t_d;
    t_Qyy = Ey*(1 - nxz*nzx)/t_d;
    t_Qyz = Ey*(nzy + nxy*nzx)/t_d;
    t_Qzz = Ez*(1-nxy*nyx)/t_d;
    t_part_N11 = (pi^2)*(Gxy*((m/width)^2) + Gxz*((n/thickness)^2));
    t_part_N22 = (pi^2)*(Gyz*((n/thickness)^2) + t_Qxy*((m/width)^2));
    t_part_N33 = (pi^2)*(Gyz*((m/width)^2) + t_Qzz*((n/thickness)^2));
    t_Qs = [t_Qxx, t_Qxy, t_Qxz, t_Qyy, t_Qyz, t_Qzz];
    t_part_Ns = [t_part_N11, t_part_N22, t_part_N33];

    # cannot use `round` like Matlab in Octave. Insted use the following codes.
    unit = 10^15;
    ds = [t_d, d];
    ds = round_in_octave(ds, unit);
    t_d = ds(1); d = ds(2);
    unit = 10^5;
    Qs = round_in_octave(Qs, unit);
    t_Qs = round_in_octave(t_Qs, unit);
    unit = 10^15;
    part_Ns = round_in_octave(part_Ns, unit);
    t_part_Ns = round_in_octave(t_part_Ns, unit);
    if(t_d != d)
        error('Wrong Delta is calculated.');
    elseif(t_Qs != Qs)
        error('Some Q_ijkl is invalid.');
    elseif(t_part_Ns != part_Ns)
        error('Some N_mn is invalid.');
    end
end