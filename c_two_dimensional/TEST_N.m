function TEST_N(Qxx, Qxy, Qxz, Qyy, Qyz, Qzz, digidity_modulus, mode_degree, measures, N)
    l = mode_degree(1);
    m = mode_degree(2);
    n = mode_degree(3);
    leng = measures(1);
    width = measures(2);
    thickness = measures(3);
    Gxy = digidity_modulus(1);
    Gxz = digidity_modulus(2);
    Gyz = digidity_modulus(3);
    
    t_N11 = (pi^2)*(Qxx*((l/leng)^2) + Gxy*((m/width)^2) + Gxz*((n/thickness)^2));
    t_N12 = (pi^2)*(Qxy + Gxy)*(l*m/(leng*width));
    t_N13 = (pi^2)*(Qxz + Gxz)*(l*n/(leng*thickness));
    t_N21 = t_N12;
    t_N22 = (pi^2)*(Gxy*((l/leng)^2) + Qyy*((m/width)^2) + Gyz*((n/thickness)^2));
    t_N23 = (pi^2)*(Qyz + Gyz)*(m*n/(width*thickness));
    t_N31 = t_N13;
    t_N32 = t_N23;
    t_N33 = (pi^2)*(Gxz*((l/leng)^2) + Gyz*((m/width)^2) + Qzz*((n/thickness)^2));
    t_N = [t_N11, t_N12, t_N13; t_N21, t_N22, t_N23; t_N31, t_N32, t_N33];

    # cannot use `round` like Matlab in Octave. Insted use the following codes. `unit` can be set by yourself.
    unit = 10^-5;
    N = ROUND_IN_OCTAVE(N, unit);
    t_N = ROUND_IN_OCTAVE(t_N, unit);

    is_N_tN_same = isequal(t_N, N);
    if !is_N_tN_same
        index = find((N==t_N)==0);
        disp('The number of indexes of different N: '), disp(size(index));
        error('N in the main process is invalid.');
    end
    disp('Elements of matrix N passed TEST!');
end