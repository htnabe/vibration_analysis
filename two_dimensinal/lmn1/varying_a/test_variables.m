function test_variables(width, thickness, density, Ex, Ey, Ez, nxy, nyz, nxz, Gxy, Gyz, Gxz)
  t_width = 0.500;
  t_thickness = 0.050;
  t_density = 1.52*10^3;
  t_Ex = 148 * 10^9;
  t_Ey = 10.50 * 10^9;
  t_Ez = 10.50 * 10^9;
  t_nxy = 0.30;
  t_nyz = 0.59;
  t_nxz = 0.30;
  t_Gxy = 5.61 * 10^9;
  t_Gyz = 3.17 * 10^9;
  t_Gxz = 5.61 * 10^9;
  if (t_width != width || t_thickness != thickness || t_density != density || t_Ex != Ex || t_Ey != Ey || t_Ez != Ez || t_nxy != nxy || t_nyz != nyz || t_nxz != nxz || t_Gxy != Gxy || t_Gxz != Gxz || t_Gyz != Gyz)
    error('Wrong variable(s) is inputted. Stop this process!');
  end
  if (width < 0 || thickness < 0 || density < 0 || Ex < 0 || Ey < 0 || Ez < 0 || nxy < 0 || nyz < 0 || nxz < 0 || Gxy < 0 || Gyz < 0 || Gyz < 0)
    error('Negative dimension value(s) has been entered. Stop this process!');
  end
end
