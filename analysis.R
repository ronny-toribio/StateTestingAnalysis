# @authors: Ronny Toribio, Anna T. Schlecht, Kadir O. Altunel
# @project: State Testing Analysis

library(tidyverse)
library(shiny)

# import keystone school level data
ks.sc.2015 = readxl::read_xlsx("Keystone/School/2015.xlsx", skip=7)
ks.sc.2016 = readxl::read_xlsx("Keystone/School/2016.xlsx", skip=4)
ks.sc.2017 = readxl::read_xlsx("Keystone/School/2017.xlsx", skip=4)
ks.sc.2018 = readxl::read_xlsx("Keystone/School/2018.xlsx", skip=4)
ks.sc.2019 = readxl::read_xlsx("Keystone/School/2019.xlsx", skip=4)
# no 2020 data
ks.sc.2021 = readxl::read_xlsx("Keystone/School/2021.xlsx", skip=4)
ks.sc.2022 = readxl::read_xlsx("Keystone/School/2022.xlsx", skip=3)
ks.sc = rbind(
  ks.sc.2015,
  ks.sc.2016,
  ks.sc.2017,
  ks.sc.2018,
  ks.sc.2019,
  ks.sc.2021,
  ks.sc.2022
)

# import keystone state level data
ks.st.2015 = readxl::read_xlsx("Keystone/State/2015.xlsx", skip=4)
ks.st.2016 = readxl::read_xlsx("Keystone/State/2016.xlsx", skip=4)
ks.st.2017 = readxl::read_xlsx("Keystone/State/2017.xlsx", skip=2)
ks.st.2018 = readxl::read_xlsx("Keystone/State/2018.xlsx", skip=3)
ks.st.2019 = readxl::read_xlsx("Keystone/State/2019.xlsx", skip=3)
# no 2020 data
ks.st.2021 = readxl::read_xlsx("Keystone/State/2021.xlsx", skip=4)
ks.st.2022 = readxl::read_xlsx("Keystone/State/2022.xlsx", skip=2)
ks.st = rbind(
  ks.st.2015,
  ks.st.2016,
  ks.st.2017,
  ks.st.2018,
  ks.st.2019,
  ks.st.2021,
  ks.st.2022
)

# import PSSA school level data
ps.sc.2015 = readxl::read_xlsx("PSSA/School/2015.xlsx", skip=6)
ps.sc.2016 = readxl::read_xlsx("PSSA/School/2016.xlsx", skip=4)
ps.sc.2017 = readxl::read_xlsx("PSSA/School/2017.xlsx", skip=4)
ps.sc.2018 = readxl::read_xlsx("PSSA/School/2018.xlsx", skip=4)
ps.sc.2019 = readxl::read_xlsx("PSSA/School/2019.xlsx", skip=4)
# no 2020 data
ps.sc.2021 = readxl::read_xlsx("PSSA/School/2021.xlsx", skip=6)
ps.sc.2022 = readxl::read_xlsx("PSSA/School/2022.xlsx", skip=3)
ps.sc = rbind(
  ps.sc.2015,
  ps.sc.2016,
  ps.sc.2017,
  ps.sc.2018,
  ps.sc.2019,
  ps.sc.2021,
  ps.sc.2022
)

# import PSSA state level data
ps.st.2015 = readxl::read_xlsx("PSSA/State/2015.xlsx", skip=4)
ps.st.2016 = readxl::read_xlsx("PSSA/State/2016.xlsx", skip=4)
ps.st.2017 = readxl::read_xlsx("PSSA/State/2017.xlsx", skip=2)
ps.st.2018 = readxl::read_xlsx("PSSA/State/2018.xlsx", skip=4)
ps.st.2019 = readxl::read_xlsx("PSSA/State/2019.xlsx", skip=3)
# no 2020 data
ps.st.2021 = readxl::read_xlsx("PSSA/State/2021.xlsx", skip=3)
ps.st.2022 = readxl::read_xlsx("PSSA/State/2022.xlsx", skip=3)
ps.st = rbind(
  ps.st.2015,
  ps.st.2016,
  ps.st.2017,
  ps.st.2018,
  ps.st.2019,
  ps.st.2021,
  ps.st.2022
)

