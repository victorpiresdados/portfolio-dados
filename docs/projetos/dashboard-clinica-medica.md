# Dashboard Clínica Médica

Projeto de análise de dados desenvolvido para acompanhar o desempenho
assistencial, operacional e financeiro de uma clínica médica.

## Objetivo

Transformar os registros de pacientes, médicos, consultas, exames e pagamentos
em uma visão gerencial que ajude a clínica a:

- acompanhar a demanda por atendimentos;
- monitorar consultas concluídas, cancelamentos e faltas;
- analisar a receita realizada e sua evolução;
- identificar perdas potenciais;
- comparar o desempenho de médicos, especialidades e convênios;
- apoiar decisões relacionadas à capacidade e à eficiência operacional.

## Dashboard

[Abrir o dashboard no Power BI](https://app.powerbi.com/view?r=eyJrIjoiOTc1NmZhN2UtMzY0YS00YzFiLTk5ZGUtZjdkYTY1NTI3MzhmIiwidCI6IjI0OTQ3ZDIyLTUyYTMtNGFjNS1iZTM3LTQ2ZTVjMzUzMDFiMSJ9&pageName=f2a625908e7d246c0093)

![Capa do Dashboard Clínica Médica](../assets/dashboard-clinica.png)

## Tecnologias utilizadas

- SQL Server
- Power BI
- Power Query
- Modelagem dimensional
- DAX
- HTML Content para cartões personalizados

## Estrutura dos dados

O banco de dados é organizado a partir das entidades `Pacientes`, `Médicos`,
`Convênios`, `Consultas`, `Exames` e `Pagamentos`.

Para o Power BI, o modelo analítico utiliza dimensões e fatos conectados:

- `vw_DimPaciente`
- `vw_DimMedico`
- `vw_DimConvenio`
- `vw_DimData`
- `vw_FatoConsultas`
- `vw_FatoExames`
- `vw_FatoPagamentos`

As dimensões se relacionam com as tabelas fato em relações de um para muitos,
permitindo que os filtros sejam aplicados de forma consistente no relatório.

## Principais indicadores

### Receita realizada

Valor financeiro associado às consultas efetivamente concluídas, considerando a
data da consulta como referência temporal.

### Taxa de realização

Percentual das consultas agendadas que foram concluídas.

```text
Taxa de realização = consultas concluídas / total de consultas agendadas
```

### Perda potencial

Estimativa do valor que deixou de ser realizado por causa de consultas
canceladas ou com ausência do paciente.

### Cancelamentos e faltas

Quantidade e participação das consultas com status de cancelamento ou
não comparecimento.

### Receita de exames

Valor dos exames relacionado à consulta correspondente, evitando duplicidades
por meio da agregação prévia dos exames por consulta.

## Perguntas de negócio

1. Qual é a receita realizada no período?
2. Como a receita evolui mês a mês?
3. Qual é a taxa de realização das consultas?
4. Quanto a clínica pode estar perdendo com cancelamentos e faltas?
5. Quais médicos e especialidades concentram mais atendimentos?
6. Quais convênios representam maior volume de consultas e receita?
7. Em quais períodos existe maior demanda?
8. Qual é a participação dos exames no resultado financeiro?

## Processo de desenvolvimento

1. Entendimento do problema e definição das perguntas de negócio.
2. Criação e validação das consultas no SQL Server.
3. Tratamento e organização dos dados para análise.
4. Construção do modelo dimensional conectado.
5. Desenvolvimento das métricas e indicadores.
6. Criação do layout e dos elementos visuais no Power BI.
7. Validação dos filtros, totais, rankings e regras de negócio.

## Principais aprendizados

- manutenção de uma fonte temporal consistente para consultas e exames;
- pré-agregação dos exames por consulta para evitar duplicidade de receita;
- construção de um modelo relacional que permita filtros cruzados;
- diferenciação entre receita realizada e perda potencial;
- comunicação de indicadores de saúde de forma simples e orientada à decisão.

## Código

[Ver o código SQL](../../codigo/clinica-medica/)

## Observação

Os dados utilizados no projeto são fictícios e destinados exclusivamente a
estudo e demonstração de competências em análise de dados.

