import pandas as pd  # importa o pandas pra trabalhar com tabelas

# lista de dicionários: cada dicionário = uma linha da tabela de analistas
# cada chave (id_analista, nome, equipe) vira uma coluna
analistas = [
	{"id_analista": 1, "nome": "João", "equipe": "N1"},      # N1 = primeiro atendimento/triagem
	{"id_analista": 2, "nome": "Maria", "equipe": "N1"},
	{"id_analista": 3, "nome": "Pedro", "equipe": "N1"},
	{"id_analista": 4, "nome": "Ana", "equipe": "N2"},        # N2 = escalonamento/casos mais complexos
	{"id_analista": 5, "nome": "Carlos", "equipe": "N2"},
	{"id_analista": 6, "nome": "Fernanda", "equipe": "N3"},   # N3 = especialistas
	{"id_analista": 7, "nome": "Lucas", "equipe": "N3"},
	{"id_analista": 8, "nome": "Mariana", "equipe": "N1"},
]

# pd.DataFrame transforma a lista de dicionários numa tabela de verdade
# (linhas e colunas, como uma planilha)
df_analistas = pd.DataFrame(analistas)

# imprime a tabela no terminal pra conferir se ficou certo
print(df_analistas)

# salva a tabela de analistas num CSV, pra usar depois no SQL Server
df_analistas.to_csv("analistas.csv", index=False)
