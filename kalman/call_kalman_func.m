function kf = call_kalman_func(kf)
    % Predicts
    kf.x = kf.A*kf.x + kf.B*kf.u;
    kf.P = kf.A * kf.P * kf.A' + kf.Q;

    % Updates
    K = kf.P*kf.H'*inv(kf.H*kf.P*kf.H'+kf.R);
    kf.x = kf.x + K*(kf.z-kf.H*kf.x);
    kf.P = kf.P - K*kf.H*kf.P;
return
