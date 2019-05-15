data {
  int<lower=0> N; // the number of rats
  int<lower=0> T; // the number of time points
  real x[T]; // day at which measurement was taken
  real y[N,T]; // matrix of weight times time
  real xbar; // the median number of days in the time series
}
parameters {
  real alpha[N]; // the intercepts of rat weights
  real beta[N]; // the slopes of rat weights
  
  real mu_alpha; // the mean intercept
  real mu_beta; // the mean slope
  
  real<lower=0> sigmasq_y;
  real<lower=0> sigmasq_alpha;
  real<lower=0> sigmasq_beta;
}
transformed parameters {
  real<lower=0> sigma_y; // sd of rat weight
  real<lower=0> sigma_alpha; // sd of intercept distribution
  real<lower=0> sigma_beta; // sd of slope distribution
  
  sigma_y = sqrt(sigmasq_y);
  sigma_alpha = sqrt(sigmasq_alpha);
  sigma_beta = sqrt(sigmasq_beta);
}
model {
  mu_alpha ~ normal(0, 100); // non-informative prior
  mu_beta ~ normal(0, 100); // non-informative prior
  sigmasq_y ~ normal(0, 100); // non-informative prior
  sigmasq_alpha ~ normal(0, 100); // non-informative prior
  sigmasq_beta ~ normal(0, 100); // non-informative prior
  alpha ~ normal(mu_alpha, sigma_alpha); // all intercepts are normal 
  beta ~ normal(mu_beta, sigma_beta);  // all slopes are normal
  for (n in 1:N) // for each sample
  for (t in 1:T)  // for each time point
  y[n,t] ~ normal(alpha[n] + beta[n] * (x[t] - xbar), sigma_y);
  
}
generated quantities {
  // determine the intercept at time 0 (birth weight)
  real alpha0;
  alpha0 = mu_alpha - xbar * mu_beta;
}
