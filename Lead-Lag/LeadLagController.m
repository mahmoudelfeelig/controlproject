close all

% Define Laplace variable 's'
s = tf('s'); % Create a transfer function variable


% Lead-Lag Compensator Design
Kc = 6.7; % Compensator gain (to reduce overshoot decrease this but it'll increase the error)

z1 = .015;  % Lead zero    // rise and settling time
p1 = 1.8; % Lead pole (to reduce overshoot increase this)

z2 = 0.4; % Lag zero 
p2 = 2; % Lag pole (to reduce steady-state error reduce this)

omega = 88; % wn

Gc = Kc * ((s + z1) / (s + p1)); % Lead-Lag Compensator
G = tf(0.21 * omega^2, [1 omega omega^2 0 0]); % System transfer function
sys_cl = feedback(G * Gc, 1); % Closed-loop system with compensator

% Step, Ramp, and Parabolic Responses
time = 0:0.001:5; % Finer time resolution for accuracy
stepResponse = step(sys_cl, time);
rampResponse = lsim(sys_cl, time, time); % Ramp input
parabolicResponse = lsim(sys_cl, 0.5 * time.^2, time); % Parabolic input

% Plot Responses
figure;
plot(time, stepResponse, 'b', 'LineWidth', 1.5);
title('Step Response'); hold on;
plot(time, rampResponse, 'r', 'LineWidth', 1.5);
title('Ramp Response'); hold on;
plot(time, parabolicResponse, 'g', 'LineWidth', 1.5);
title('Responses');legend('Parabola'); legend('Step', 'Ramp', 'Parabola');

%%

% checking the stability of the system
pole(G)
pole(sys_cl)

%%

% info such as settling time, overshoot, etc..
info = stepinfo(sys_cl, 'RiseTimeLimits', [0 1], 'SettlingTimeThreshold', 0.05);
disp(info);
% info2 = stepinfo(G, 'RiseTimeLimits', [0 1], 'SettlingTimeThreshold', 0.05);
% disp(info2)

% Check Steady-State Error for Step Input
steady_state_error = abs(1 - stepResponse(end)); % Steady-state error
disp(['Steady-State Error for the step: ', num2str(steady_state_error)]);

steady_state_error_ramp = abs(1 - rampResponse(end)); % Steady-state error
disp(['Steady-State Error for the ramp: ', num2str(steady_state_error_ramp)]);

steady_state_error_parabola = abs(1 - parabolicResponse(end)); % Steady-state error
disp(['Steady-State Error for the parabola: ', num2str(steady_state_error_parabola)]);

%%

figure;
rlocus(sys_cl);
title('Root Locus with Lead-Lag Compensator');



%%

figure;
margin(sys_cl);
title('Bode Plot with Lead-Lag Compensator');
