import pandas as pd
from sqlalchemy import create_engine
import urllib.parse  # ajuda a montar a string de conexão sem erro de caracteres especiais

# monta os parâmetros de conexão no formato que o driver ODBC entende
params = urllib.parse.quote_plus(
    "DRIVER={ODBC Driver 17 for SQL Server};"
    "SERVER=localhost\\SQLEXPRESS;"
    "DATABASE=HelpdeskDashboard;"
    "Trusted_Connection=yes;"   # usa seu login do Windows, sem usuário/senha
)

# cria a "ponte" de conexão que o pandas vai usar pra falar com o banco
engine = create_engine(f"mssql+pyodbc:///?odbc_connect={params}")

# lê os dois arquivos já limpos
df_analistas = pd.read_csv("analistas.csv")
df_tickets = pd.read_csv("tickets_limpos.csv")

# o CSV guarda tudo como texto — convertendo de volta pra data aqui,
# evitamos que o SQL Server tenha que "adivinhar" o formato sozinho

df_tickets["data_abertura"] = pd.to_datetime(df_tickets["data_abertura"])
df_tickets["data_fechamento"] = pd.to_datetime(df_tickets["data_fechamento"])

# print temporário só pra diagnosticar quantas linhas foram lidas do CSV
print("Linhas lidas de tickets_limpos.csv:", df_tickets.shape)

# to_sql insere os dados na tabela que já existe no SQL Server
# if_exists="append" adiciona linhas (a tabela já existe, com suas regras/constraints)
# index=False evita mandar o número da linha do pandas como se fosse uma coluna

df_analistas.to_sql("Analistas", con=engine, if_exists="append", index=False)
df_tickets.to_sql("Tickets", con=engine, if_exists="append", index=False)

print("Dados carregados com sucesso")