%  Analytic Model
clear all
close all
clc

%inputs
Q = 240; % # of slots
m = 3; % # of phases
p = 32; % # of poles
throw = 6;
L = 900e-3; % axial length, m
Di = 6197.6e-3; % inner diameter, m
Dr = 6172.2e-3; % rotor diameter, m
SlotWidth = 25.4e-3; % m
mu0 = 4*pi*1e-7; % permeability of the air

%calculations
q = Q/(m*p); % slots per pole per phase
Pitch = Q/p; % slots per pole
PitchNumber = throw/Pitch;
CoilSpan_rad = pi*PitchNumber; % coil pitch
Alpha_rad = pi*p/Q;
CoilSpan_deg = 180*PitchNumber;
Alpha_deg = 180*p/Q;
SlotPitch = pi*Di/Q; % m
TeethWidth = SlotPitch-SlotWidth; % m
HarmonicNumber = 1:2:51;
header = {'Harmonic Number','kp','kd','kw','Phase Angle (electrical)','Phase Angle (Mechanical)'};
for i = 1:length(HarmonicNumber)
    kp(i) = sin(HarmonicNumber(i)*CoilSpan_rad/2);
    kp(i) = fix(kp(i)*1e6)/1e6;
    kd(i) = sin(q*HarmonicNumber(i)*Alpha_rad/2)/(q*sin(HarmonicNumber(i)*Alpha_rad/2));
    kd(i) = fix(kd(i)*1e6)/1e6;
    kw(i) = kd(i)*kp(i);
    kw(i) = fix(kw(i)*1e6)/1e6;
end

PhaseAngle_elec(1) = Alpha_deg; %degree
PhaseAngle_mech(1) = 360/Q; % degree
for i = 2:length(HarmonicNumber)
    PhaseAngle_elec(i) = mod(HarmonicNumber(i)*PhaseAngle_elec(1),360);
    PhaseAngle_mech(i) = mod(HarmonicNumber(i)*PhaseAngle_mech(1),360);
end
result = [HarmonicNumber' kp' kd' kw' PhaseAngle_elec' PhaseAngle_mech'];
result = table(result,'VariableNames',header);