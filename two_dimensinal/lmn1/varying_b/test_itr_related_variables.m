# test matrix N
function test_itr_related_variables(width, measures, modulus_rigidity, Qs, mode_degrees, part_Ns, N)
    # values from the main program = values to be tested
    leng = measures(1);
    thickness = measures(2);
    Qxx = Qs(1);
    Qxy = Qs(2);
    Qxz = Qs(3);
    Qyy = Qs(4);
    Qyz = Qs(5);
    Qzz = Qs(6);
    Gxy = modulus_rigidity(1);
    Gyz = modulus_rigidity(2);
    Gxz = modulus_rigidity(3);
    l = mode_degrees(1); m = mode_degrees(2); n = mode_degrees(3);
    part_N11 = part_Ns(1);
    part_N22 = part_Ns(2);
    part_N33 = part_Ns(3);
    N13 = part_Ns(4);
    N31 = part_Ns(5);

    # values to be used in the test
    t_N11 = part_N11 + Gxy*(pi*m/width)^2;
    t_N12 = (pi^2)*(Gxy + Qxy)*(l*m/(leng*width));
    t_N13 = N13;
    t_N21 = t_N12;
    t_N22 = part_N22 + Qyy*(pi*m/width)^2;
    t_N23 = (pi^2)*(Gyz + Qyz)*(n*m/(thickness*width));
    t_N31 = N31;
    t_N32 = t_N23;
    t_N33 = part_N33 + Gyz*(pi*m/width)^2;
    t_N = [t_N11, t_N12, t_N13; t_N21, t_N22, t_N23; t_N31, t_N32, t_N33];

    unit = 10^(-3);
    t_N = round_in_octave(t_N, unit);
    N = round_in_octave(N, unit);

    # test variables from the main process and this process
    N_itr_cnt = max(size(N));
    for(i=1:N_itr_cnt)
        if(t_N(i) != N(i))
            disp('element number'), disp(i)
            disp('Tested N:'); disp(N(i))
            disp('N used in test:'); disp(t_N(i))
            error('Wrong matrix [N] is calculated.');
        end
    end
end