# Helpdesk: código do pipeline

Tratamento em Python, carga em SQL Server e consumo no Power BI. Os dados são simulados.

## Ordem de execução

1. `gerar_dados.py` cria `analistas.csv`.
2. `gerar_csv_bruto.py` cria `tickets_bruto.csv` com problemas propositais de qualidade.
3. `limpar_dados.py` trata os dados e cria `tickets_limpos.csv` (275 linhas brutas, 246 validadas).
4. `criar_banco.sql` cria o banco e as tabelas no SQL Server.
5. `carregar_sql.py` carrega os CSVs no banco.

O passo 2 usa a data atual, então uma nova geração muda as datas. Os CSVs publicados são a base usada no dashboard.

## Requisitos

Python 3 com `pandas`, `sqlalchemy` e `pyodbc`, além do SQL Server. A conexão usa autenticação do Windows em `localhost\SQLEXPRESS`.
