function TEST_DELTA_Q_PARAMS(d, nxy, nxz, nyz, nyx, nzx, nzy, Ex, Ey, Ez, Qs)
    t_delta = 1 - nxy.*nyx - nxz.*nzx - nyz.*nzy - 2*nxy*nyz.*nzx;
    is_delta_same = isequal(t_delta, d);
    if (!is_delta_same)
        error('Wrong delta is inputted')
    end

    t_Qxx = Ex.*(1-nyz*nzy)./d;
    t_Qxy = Ex.*(nyx+nyz.*nzx)./d;
    t_Qxz = Ex.*(nzx+nyx.*nzy)./d;
    t_Qyy = Ey*(1-nxz.*nzx)./d;
    t_Qyz = Ey*(nzy+nxy.*nzx)./d;
    t_Qzz = Ez*(1-nxy.*nyx)./d;
    t_Qs = [t_Qxx, t_Qxy, t_Qxz, t_Qyy, t_Qyz, t_Qzz];

    is_Q_same = isequal(t_Qs, Qs);
    if !is_Q_same
      index = find((t_Qs==Qs)==0);
      disp('Index of different Q: '), disp(index);
      error('Some of Q-parameters are wrong.');
    end
    disp('Delta and Q-params passed TEST!');
end