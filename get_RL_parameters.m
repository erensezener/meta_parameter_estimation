alpha = [2, 2]; %[mean, sigma]
beta = [2, 2]; %[mean, sigma]
% gamma = [0.8 0.2]; %[mean, sigma] TODO larger than 1 gamma is problematic
gamma = 0.9;
Q = [0, 1; 0, 1; 0, 1]; %[mean, sigma; ... ; mean, sigma]

alpha_dynamics_sigma = 0.05; %parameter of the brownian motion for p(x_(t+1)|x_t)
beta_dynamics_sigma = 0.005; %parameter of the brownian motion for p(x_(t+1)|x_t)
dynamics_sigmas = [alpha_dynamics_sigma, beta_dynamics_sigma];

dynammics_fun = @(x, x_prev) mvnpdf(x, x_prev, dynamics_sigmas); %x = [alpha_mean, beta_mean]; 
dynammics_fun_aux = @(x_comb) dynammics_fun(x_comb(1,:), x_comb(2,:));

% p_x1 = @(x1) integral(dynammics_fun_aux(alpha