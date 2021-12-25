function TEST_VARIABLES(measure_arr, digidity_modulus_arr)
    t_leng = 0.1;
    t_width = 0.5;
    t_thickness = 0.05;
    t_Gxy = t_Gxz = 5.61 * 10^9;
    t_Gyz = 3.17 * 10^9;
    t_measures = [t_leng, t_width, t_thickness];
    t_digidity_modulus = [t_Gxy, t_Gxz, t_Gyz];

    is_measures_same = isequal(t_measures, measure_arr);
    if !is_measures_same
        index = find((t_measures==measure_arr)==0);
        disp('Index of different measure: '), disp(index);
        error('Wrong poisson measure is inputted.');
    end

    is_digidity_same = isequal(t_digidity_modulus, digidity_modulus_arr);
    if !is_digidity_same
        index = find((t_digidity_modulus==digidity_modulus_arr)==0);
        disp('Index of different digisity of modulus: '), disp(index);
        error('Wrong digidity of modulus is inputted.');
    end
    disp('Measures and digidity of modulus passed TEST!');
end