library(dplyr)
library(tidyr)
library(writexl)
freq_proposicao <- PLs_em_tramitação_na_CSAUDE_02_01_2026 |>
  count(Proposicao, name = "frequencia") |>
  mutate(proporcao = frequencia / sum(frequencia)) |>
  arrange(desc(frequencia))

freq_proposicao
freq_temas <- PLs_em_tramitação_na_CSAUDE_02_01_2026 |>
  separate_rows(Tema, sep = ";") |>
  mutate(Tema = trimws(Tema)) |>
  count(Tema, name = "frequencia") |>
  arrange(desc(frequencia))

freq_temas
freq_regime <- PLs_em_tramitação_na_CSAUDE_02_01_2026 |>
  count(Regime, name = "frequencia") |>
  arrange(desc(frequencia))

freq_regime

freq_tipo <- PLs_em_tramitação_na_CSAUDE_02_01_2026 |>
  count(Tipo, name = "frequencia") |>
  arrange(desc(frequencia))

freq_tipo

dados2 <- PLs_em_tramitação_na_CSAUDE_02_01_2026 |>
  mutate(
    Apresentacao_data = as.Date(Apresentacao, format = "%d/%m/%Y"),
    Data_ultima_acao_data = as.Date(`Data Última Ação`, format = "%d/%m/%Y"),
    
    dias_desde_ultima_acao = as.numeric(Sys.Date() - Data_ultima_acao_data),
    
    dias_entre_apresentacao_e_ultima_acao = as.numeric(
      Data_ultima_acao_data - Apresentacao_data
    )
  )
lista_resultados <- list(
  "Freq_Proposicao" = freq_proposicao,
  "Freq_Temas" = freq_temas,
  "Freq_Regime" = freq_regime,
  "Freq_Tipo" = freq_tipo,
  "Dados_Completos" = dados2
)
library(dplyr)
library(stringr)

dados3 <- PLs_em_tramitação_na_CSAUDE_02_01_2026 |>
  mutate(
    Situacao_CD_simplificada = case_when(
      str_detect(`Situação na CD`, "Pronta para Pauta") ~ "Pronto para Pauta",
      str_detect(`Situação na CD`, "Apensado") ~ "Apensado",
      str_detect(`Situação na CD`, "Tramitando em Conjunto") ~ "Tramitando em Conjunto",
      str_detect(`Situação na CD`, "Aguardando Parecer") ~ "Aguardando Parecer",
      str_detect(`Situação na CD`, "Aguardando Designação") |
        str_detect(`Situação na CD`, "Aguardando Devolução de Relator") ~ "Aguardando Designação de Relator(a)",
      str_detect(`Situação na CD`, "Aguardando análise do Presidente da Câmara") ~ "Aguardando Análise do PR-Câmara",
      str_detect(`Situação na CD`, "Aguardando") ~ "Aguardando Deliberação",  # caso genérico
      TRUE ~ "Outros"
    )
  )

write_xlsx(lista_resultados, "Resultados_Analise_PLs.xlsx")


cat("Arquivo 'Resultados_Analise_PLs.xlsx' criado com sucesso!\n")
