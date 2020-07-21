library(dplyr)
library(ggplot2)
library(shredder)
library(rstan)

source(here::here('stage2/script/utility/raw_data.R'))

#set pallete for plots
bayesplot::color_scheme_set("brightblue")

#read in the fit data and extract the relevant parameters
fits <- joint_par%>%
  purrr::map(.f=function(model){
    object <- readRDS(file = here::here(sprintf('stage2/data/joint_model_invariant_%s.Rds',model)))
    
    object%>%
      stan_select(lp__,sigma_p,shape,log_loc,stan_starts_with('omega|log_pop|theta'))
    
  })

#convert to a tibble
fits_tbl <- fits%>%
  purrr::map_df(.f=function(x){
    tibble::tibble(
      part = c('lesion','os','joint'),
      fits = list(
        lesion = stan_select(x, sigma_p,stan_starts_with('theta|omega|log_pop')),
        os     = stan_select(x, shape,log_loc,theta_os),
        joint  = stan_select(x, stan_starts_with('theta_lesion')))
    )  
  },.id='model')

p <- fits_tbl%>%
  dplyr::filter(part=='lesion')%>%
  dplyr::mutate(
    trace_data = purrr::map(fits, .f=function(x){
      x%>%
        stan_select(log_pop_kg,log_pop_kd)%>%
        rstan:::.make_plot_data(stan_names(.))%>%
        purrr::pluck('samp')
    })
  )%>%
  dplyr::select(-fits)%>%
  tidyr::unnest()%>%
  ggplot(aes(x=iteration,y=value,colour = chain)) + 
  geom_path() +
  facet_grid(parameter~model) + 
  labs(
    title = 'Log Pop Traceplots'
    ) + 
  theme_minimal() + 
  theme(
    legend.position = 'bottom',
    axis.text.x = element_text(angle = 90),
    axis.title = element_blank()
    )

ggsave(filename = 'stage2/MCMC/multitrace.svg',p,device = 'svg')
