function [delays, dopplers, pdp] = getChannelParams(maxSpeed_kmh,fc, modelName)
%getChannelParams  Return delay, Doppler shifts, and PDP for standard models
%
%   [delays, dopplers, pdp] = getChannelParams(maxSpeed_kmh, fc, modelName)
%
%   Inputs:
%     maxSpeed_kmh  — maximum mobile speed in km/h
%     fc            — carrier frequency in Hz
%     modelName     — string, one of:
%                     'TDL-A','TDL-B','TDL-C','EPA','EVA','ETU'
%
%   Outputs:
%     delays   — 1×L vector of path delays (s)
%     dopplers — 1×L vector of Doppler shifts (Hz)
%     pdp      — 1×L vector of path power magnitudes (linear)

% Convert speed to m/s and compute max Doppler
v_ms    = maxSpeed_kmh * (1000/3600);
Doppler_vel = (v_ms * fc) / 3e8;

switch lower(modelName)
  case 'tdl-a'
    delays = [ ...
      0.0000, 0.3819, 0.4025, 0.5868, 0.4610, 0.5375, 0.6708, ...
      0.5750, 0.7618, 1.5375, 1.8978, 2.2242, 2.1718, 2.4942, ...
      2.5119, 3.0582, 4.0810, 4.4579, 4.5695, 4.7966, 5.0066, ...
      5.3043, 9.6586 ] * 300e-9;
    pdp    = db2mag([ ...
      -13.4, 0, -2.2, -4, -6, -8.2, -9.9, -10.5, -7.5, ...
      -15.9, -6.6, -16.7, -12.4, -15.2, -10.8, -11.3, ...
      -12.7, -16.2, -18.3, -18.9, -16.6, -19.9, -29.7 ]).';
    
  case 'tdl-b'
    delays = [ ...
      0.0000, 0.1072, 0.2155, 0.2095, 0.2870, 0.2986, 0.3752, ...
      0.5055, 0.3681, 0.3697, 0.5700, 0.5283, 1.1021, 1.2756, ...
      1.5474, 1.7842, 2.0169, 2.8294, 3.0219, 3.6187, 4.1067, ...
      4.2790, 4.7834 ] * 300e-9;
    pdp    = db2mag([ ...
      0, -2.2, -4, -3.2, -9.8, -1.2, -3.4, -5.2, -7.6, -3, ...
      -8.9, -9, -4.8, -5.7, -7.5, -1.9, -7.6, -12.2, -9.8, ...
      -11.4, -14.9, -9.2, -11.3 ]).';

  case 'tdl-c'
    delays = [ ...
      0, 0.2099, 0.2219, 0.2329, 0.2176, 0.6366, 0.6448, 0.6560, ...
      0.6584, 0.7935, 0.8213, 0.9336, 1.2285, 1.3083, 2.1704, ...
      2.7105, 4.2589, 4.6003, 5.4902, 5.6077, 6.3065, 6.6374, ...
      7.0427, 8.6523 ] * 300e-9;
    pdp    = db2mag([ ...
      -4.4, -1.2, -3.5, -5.2, -2.5, 0, -2.2, -3.9, -7.4, ...
      -7.1, -10.7, -11.1, -5.1, -6.8, -8.7, -13.2, -13.9, ...
      -13.9, -15.8, -17.1, -16, -15.7, -21.6, -22.8 ]).';

  case 'epa'
    delays = [0 30 70 90 110 190 410] * 1e-9;
    pdp    = db2mag([0 -1.0 -2.0 -3.0 -8.0 -17.2 -20.8]).';

  case 'eva'
    delays = [0 30 150 310 370 710 1090 1730 2510] * 1e-9;
    pdp    = db2mag([0 -1.5 -1.4 -3.6 -0.6 -9.1 -7.0 -12.0 -16.9]).';

  case 'etu'
    delays = [0 50 120 200 230 500 1600 2300 5000] * 1e-9;
    pdp    = db2mag([-1 -1 -1 0 0 0 -3 -5 -7]).';

  otherwise
    error('Unknown model name "%s". Choose TDL-A/B/C or EPA/EVA/ETU.', modelName);
end

% Generate per-tap Doppler shifts (Jakes’ model approximation)
L       = numel(delays);
f_d_max = Doppler_vel;%/one_doppler_tap;
dopplers = f_d_max * cos(2*pi*rand(1,L));

end
