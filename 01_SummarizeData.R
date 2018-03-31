devtools::install_github("tidyverse/ggplot2", ref="sf")
library(tidyverse)
library(sf)

VoterDataRaw <- as_tibble(data.table::fread("ncvoter_Statewide.txt"))

VoterDataSelect <- VoterDataRaw %>%
  select(county_id, voter_reg_num, status_cd, reason_cd, absent_ind,
         name_prefx_cd:name_suffix_lbl, race_code:birth_state,
         registr_dt, nc_house_abbrv, confidential_ind, 
         birth_year, ncid) %>%
  filter(status_cd=="A", nc_house_abbrv != "") %>%
  mutate(nc_house_abbrv=as.numeric(nc_house_abbrv))

NVoters <- VoterDataSelect %>% count(nc_house_abbrv)

nc_house_map <- 
  st_read(dsn="House 18 USSupCt - Shapefile",
          layer="House 18USSupCt") %>%
  mutate(nc_house_abbrv=as.numeric(as.character(DISTRICT)))

MapPops <- full_join(NVoters, nc_house_map, by="nc_house_abbrv")

ggplot(data=MapPops, aes(fill=n)) +geom_sf()
