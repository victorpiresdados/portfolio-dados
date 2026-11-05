import re
import pandas as pd  # importa o pandas pra trabalhar com tabelas

# lê o CSV e transforma numa tabela (DataFrame)
df = pd.read_csv("tickets_bruto.csv")

# .info() mostra: quantas linhas, quais colunas existem,
# quantos valores não-nulos por coluna e o tipo de cada uma
print(df.info())

# .head() mostra as 5 primeiras linhas, só pra dar uma olhada nos dados
print(df.head())

# .duplicated() marca True nas linhas que são cópia exata de outra
# .sum() conta quantas vieram marcadas como True
print(df.duplicated().sum())

# remove as linhas duplicadas, mantendo a primeira ocorrência de cada uma
# reatribuímos o resultado a df, senão a limpeza não fica salva
df = df.drop_duplicates()

# confere quantas linhas sobraram (era 275, deve virar 260)
print(df.shape)

# .unique() lista todos os valores diferentes que aparecem na coluna
# isso revela as variações de escrita (maiúscula/minúscula, espaços, etc)
print(df["categoria"].unique())
print(df["prioridade"].unique())
print(df["canal"].unique())
print(df["status"].unique())

# .str.strip() remove espaços no início/fim do texto
# .str.lower() deixa tudo em minúsculo
# fazendo os dois em sequência, "  Acesso" e "ACESSO" viram "acesso"
df["categoria"] = df["categoria"].str.strip().str.lower()
df["prioridade"] = df["prioridade"].str.strip().str.lower()
df["canal"] = df["canal"].str.strip().str.lower()
df["status"] = df["status"].str.strip().str.lower()

# olha de novo os valores únicos pra ver o que ainda sobrou de bagunça
print(df["categoria"].unique())
print(df["prioridade"].unique())
print(df["canal"].unique())
print(df["status"].unique())

# .replace() troca cada valor da esquerda pelo da direita, exatamente como escrito
# aqui unificamos abreviação e forma completa
df["categoria"] = df["categoria"].replace({
    "hw": "hardware",
    "sw": "software",
})

# aqui unificamos a versão com e sem acento
df["prioridade"] = df["prioridade"].replace({
    "média": "media",
    "crítica": "critica",
})

# aqui unificamos "e-mail" (com hífen) e "email" (sem hífen)
df["canal"] = df["canal"].replace({
    "e-mail": "email",
})

# aqui tratamos "fechado" como sinônimo de "resolvido",
# e "em andamento" como sinônimo de "aberto"
df["status"] = df["status"].replace({
    "fechado": "resolvido",
    "em andamento": "aberto",
})

# confere se cada coluna ficou só com os valores esperados
print(df["categoria"].unique())
print(df["prioridade"].unique())
print(df["canal"].unique())
print(df["status"].unique())

# format="mixed" (usado antes aqui) deixa o pandas *adivinhar* o formato
# de cada string, e ele erra sistematicamente sempre que dia e mês são
# ambíguos (ambos <=12): "10/08/26" (dia-primeiro) vira 8/out em vez de 10/ago.
# Isso corrompia ~31% dos tickets resolvidos (deltas de -261 a +237 dias),
# que o filtro de outliers (0 a 15 dias) descartava calados como "ruído".
# Como os formatos usados na geração são conhecidos e finitos, dá pra decidir
# o formato certo pela estrutura da string em vez de adivinhar:
def parse_data_ambigua(valor):
    if pd.isna(valor) or valor == "":
        return pd.NaT
    texto = str(valor).strip()
    if re.match(r"^\d{4}-\d{1,2}-\d{1,2}$", texto):
        return pd.to_datetime(texto, format="%Y-%m-%d", errors="coerce")
    if "/" in texto:
        # sempre dia-primeiro no gerador: %d/%m/%Y ou %d/%m/%y
        formato = "%d/%m/%Y" if len(texto.split("/")[-1]) == 4 else "%d/%m/%y"
        return pd.to_datetime(texto, format=formato, errors="coerce")
    if "-" in texto:
        # não começa com ano de 4 dígitos, então é mês-primeiro: %m-%d-%Y
        return pd.to_datetime(texto, format="%m-%d-%Y", errors="coerce")
    return pd.NaT

df["data_abertura"] = df["data_abertura"].apply(parse_data_ambigua)
df["data_fechamento"] = df["data_fechamento"].apply(parse_data_ambigua)

# confere se as colunas viraram tipo "datetime" de verdade
print(df.dtypes)

# conta quantas datas o pandas não conseguiu interpretar
print(df["data_abertura"].isna().sum())
print(df["data_fechamento"].isna().sum())

# conta quantas linhas têm status "aberto"
# se bater com os 29 nulos de data_fechamento, confirma que
# os vazios são legítimos (tickets em aberto), não erro de dado
print((df["status"] == "aberto").sum())

print(df["id_analista"].isna().sum())

# remove só as linhas onde id_analista está vazio (NaN)
# subset=["id_analista"] indica que a checagem de vazio é só nessa coluna
df = df.dropna(subset=["id_analista"])

# confere quantas linhas sobraram (era 260, deve virar 246)
print(df.shape)

# como não sobrou mais NaN nessa coluna, já dá pra converter pra inteiro
df["id_analista"] = df["id_analista"].astype(int)
print(df.dtypes)

# salva o DataFrame limpo num novo CSV
# index=False evita que o pandas grave uma coluna extra com o número da linha
df.to_csv("tickets_limpos.csv", index=False)

print("Arquivo salvo com sucesso")