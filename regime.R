# Carregar a biblioteca dplyr
library(dplyr)

# Calcular a frequência da coluna "Regime"
frequencia_regime <- PL_e_PLP_em_tramitação_na_CSAÚDE_14_11_2024_com_temas %>%
  group_by(Regime) %>%
  summarise(Frequencia = n())


# Exibir o resultado
print(frequencia_regime)
