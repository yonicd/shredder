library(magick)
library(bunny)

girl <- image_read("data-raw/3989510611_e88c931f7d_h.jpg") %>% 
  image_crop(geometry = "700x1191+0+0") %>% 
  image_trim() %>% 
  image_scale("50%")

mcmc_plot <- image_read("data-raw/figure6.png") %>% 
  image_crop("510x300+130+100") %>% 
  image_scale(geometry_size_percent(100, 200)) %>% 
  #image_negate() %>% 
  image_transparent("white", fuzz = 40) 


stan_logo <- image_read("data-raw/stan_logo.png")

stan_logo_mask<-stan_logo %>% 
  image_channel("A") %>% 
  image_noise() %>% 
  image_convert(type="Grayscale") %>% 
  image_morphology("Open", "Diamond:1") %>% 
  image_threshold("black", "94%")

stan_logo_art <- image_compose(stan_logo, stan_logo_mask, "CopyOpacity") %>%
  image_flatten() %>% 
  #image_compose(image_canvas(stan_logo, pseudo_image = "gradient:black-white"),
  #              "CopyOpacity") %>% 
  image_scale("50%")

bg_color <- "#ede6f2"
bg_color2 <- "#f6f3f9"
fg_color <- "#042a2b"
fgd_color1 <- "#772e25"
fgd_color2 <- "#411815"

shred_hex <- 
  image_canvas_hex(fill_color = bg_color, border_color = fg_color) %>%
  image_composite(image_blank(460, 660, "white"), gravity = "center",offset = "+0+100") %>% 
  image_composite(image_blank(460, 150, bg_color), gravity = "center", offset = "+0-160") %>% 
  image_composite(girl, gravity = "center", offset = "-80+270") %>% 
  image_composite(mcmc_plot, gravity = "center", offset = "+0+370") %>% 
  image_composite(stan_logo_art, gravity = "center", offset = "+100+40") %>% 
  image_composite(image_blur(image_border(image_blank(420, 620, "transparent"), 
                                 color="grey50", geometry = "60x60"), 
                             radius = 60, sigma = 40),
                  gravity = "center",offset = "-10+110") %>%  
  image_composite(image_border(image_blank(470, 670, "transparent"), 
                               color=fgd_color2, geometry = "60x60"), 
                  gravity = "center",offset = "+0+100") %>% 
  image_composite(image_border(image_blank(500, 700, "transparent"), 
                                 color=fgd_color1, geometry = "10x10"), 
                    gravity = "center",offset = "+0+100") %>% 
  image_annotate("shredder", gravity = "center", location = "+0-400", 
                 size=200, font="Aller", color = fg_color, weight = 400) %>%
  image_composite(image_canvas_hexborder(border_color = fg_color, border_size = 7), 
                  gravity = "center", operator = "Atop") #%>% 
  #image_scale("20%")
#  

shred_hex %>%
  image_scale("1200x1200") %>%
  image_write("data-raw/shred_hex.png", density = 600)

shred_hex %>%
  image_scale("200x200") %>%
  image_write("man/figures/logo.png", density = 600)

shred_hex_gh <- shred_hex %>%
  image_scale("400x400")

gh_logo <- bunny::github %>%
  image_scale("40x40")

shred_ghcard <- image_canvas_ghcard(fill_color = bg_color2) %>%
  image_composite(shred_hex_gh, gravity = "East", offset = "+100+0") %>%
  image_annotate("Stan ", gravity = "West", location = "+60-30", 
                 style = "italic", color=fg_color, size=65, font="Volkhov", weight = 700) %>%   
  image_annotate("models. Sliced.", gravity = "West", location = "+210-30",
                 color=fg_color, size=60, font="Volkhov", weight = 500) %>%
  image_compose(gh_logo, gravity="West", offset = "+60+40") %>%
  image_annotate("metrumresearchgroup/shredder", gravity="West", 
                 location="+110+45", size=38, font="Ubuntu Mono") %>%
  image_border_ghcard(bg_color2)

shred_ghcard %>%
  image_write("data-raw/shred_ghcard.png", density = 600)


